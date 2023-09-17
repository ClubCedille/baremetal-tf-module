# Author: Simon Boyer

resource "routeros_interface_bridge_port" "eth2port" {
  provider  = routeros
  bridge    = "bridge"
  for_each  = { for s in var.servers : s.hostname => s }
  interface = each.value.switch_port
  pvid      = var.vlan
}

resource "routeros_interface_vlan" "cluster-vlan-if" {
  interface = "bridge"
  mtu       = 1500
  name      = "vlan-${var.vlan}-if"
  vlan_id   = var.vlan
}

resource "routeros_ip_address" "lan" {
  address   = "${cidrhost(var.network_config.network, 1)}/${split("/", var.network_config.network)[1]}"
  comment   = "${var.omni_cluster_name} Network"
  interface = routeros_interface_vlan.cluster-vlan-if.name
}

resource "routeros_bridge_vlan" "cluster-vlan" {
  bridge   = "bridge"
  tagged   = ["vlan-${var.vlan}-if"]
  untagged = [for s in var.servers : s.switch_port]
  vlan_ids = var.vlan
}

resource "routeros_ip_pool" "dhcp_pool" {
  name    = "${var.omni_cluster_name}-pool"
  ranges  = ["${cidrhost(var.network_config.network, 0)}-${cidrhost(var.network_config.network, -1)}"]
  comment = var.omni_cluster_name
}

resource "routeros_ip_dhcp_server" "vlan_dhcp" {
  address_pool  = routeros_ip_pool.dhcp_pool.name
  authoritative = "yes"
  disabled      = false
  interface     = routeros_interface_vlan.cluster-vlan-if.name
  name          = "${var.omni_cluster_name}-dhcp-server"
}

resource "routeros_ip_dhcp_server_network" "dhcp_network" {
  address    = var.network_config.network
  gateway    = var.network_config.gateway
  dns_server = var.network_config.dns
  comment    = "${var.omni_cluster_name} network"
}

resource "routeros_ip_dhcp_server_lease" "servers_leases" {
  for_each    = { for i, v in var.servers : i => v }
  address     = cidrhost(var.network_config.network, each.key + 3)
  mac_address = each.value.mac_addr
  comment     = each.value.hostname

  provisioner "local-exec" {
    command = "until ping -c1 ${cidrhost(var.network_config.network, each.key + 3)}  2>&1; do :; done"
  }
}

resource "routeros_ip_dns_record" "server_dns" {
  for_each = { for i,v in routeros_ip_dhcp_server_lease.servers_leases : i => v }
  name     = "${each.value.comment}.${var.network_config.domain}"
  address  = each.value.address
  type     = "A"
}

resource "routeros_routing_bgp_connection" "metallb-bgp" {
  name = "${var.omni_cluster_name}-peer"
  as   = var.network_config.bgp_router_as
  remote {
    address = cidrhost(var.network_config.network, 2)
    as      = var.network_config.bgp_cluster_as
  }
  connect = true
  listen  = true
}

#resource "mikrotik_bgp_instance" "instance" {
#  name      = "${var.cluster_name}-bgp"
#  as        = var.network_config.bgp_router_as
#  router_id = "0.0.0.0"
#}

#resource "mikrotik_bgp_peer" "cluster-bgp" {
#  name           = "${var.cluster_name}-peer"
#  remote_as      = var.network_config.bgp_cluster_as
#  remote_address = cidrhost(var.network_config.network, 2)
#  instance       = mikrotik_bgp_instance.instance.name
#}