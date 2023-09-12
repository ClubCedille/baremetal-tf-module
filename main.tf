terraform {
  required_version = "~> 1.3"
  required_providers {
    talos = {
      source = "siderolabs/talos"
      version = "0.2.0"
    }
    xenorchestra = {
      source = "Antoine-BL/xenorchestra"
      version = "1.0.0"
    }
    http = {
      source = "hashicorp/http"
      version = "3.3.0"
    }
    macaddress = {
      source = "ivoronin/macaddress"
      version = "0.3.2"
    }
    routeros = {
      source = "terraform-routeros/routeros"
      version = "1.10.4"
    }
  }
}

locals {
  certSANs = concat(routeros_dns_record.controlplane-records[*].name, routeros_dns_record.worker-records[*].name, var.cluster_endpoint)
}

// ------------
// MIKROTIK
// ------------

resource "routeros_bridge" "bridge" {
  name           = "xen_bridge"
  fast_forward   = true
  vlan_filtering = true
  comment        = "Xen bridge"
}

resource routeros_bridge_port "eth2port" {
  bridge    = routeros_bridge.bridge.name
  for_each = toset(var.routeros_network_interfaces)
  interface = each.key
  pvid      = var.vlan
  comment   = "bridge port"
}

resource "routeros_interface_bridge_vlan" "bridge_vlan" {
  vlan_ids = "0-4094"
  bridge = "xen_bridge"
  tagged = concat(["bridge"], routeros_network_interfaces)
  untagged = []
}

resource "routeros_pool" "bar" {
  name    = "dhcp-pool"
  ranges  = "${cidrhost(var.subnet, 0)}-${cidrhost(var.subnet, -1)}"
  comment = "Home devices"
}

resource "routeros_dhcp_server" "default" {
  address_pool  = routeros_pool.bar.name
  authoritative = "yes"
  disabled      = false
  interface     = var.net_interfaces
  name          = "main-dhcp-server"
}

resource "routeros_dhcp_server_network" "default" {
  address    = var.subnet
  gateway    = cidrhost(var.subnet, 1)
  dns_server = cidrhost(var.subnet, 1)
  comment    = "Default DHCP server network"
}

resource "macaddress" "controlplanes" {
  count = var.controlplane.nb_vms
  prefix = [0, 22, 62]
}

resource "routeros_dhcp_lease" "controlplanes" {
  count = var.controlplane.nb_vms
  address    = cidrhost(var.subnet, count.index + 2)
  macaddress = macaddress.controlplanes[count.index].address
  comment    = format("%s-cp-%s", var.cluster_name, count.index)
  blocked    = "false"
}

resource "macaddress" "workers" {
  count = var.worker.nb_vms
  prefix = [0, 22, 62]
}

resource "routeros_dhcp_lease" "workers" {
  count = var.worker.nb_vms
  address    = cidrhost(var.subnet, count.index + var.max_controlplanes)
  macaddress = macaddress.workers[count.index].address
  comment    = format("%s-worker-%s", var.cluster_name, count.index)
  blocked    = "false"
}

resource "routeros_dns_record" "cluster-record" {
  name    = var.cluster_endpoint
  address = routeros_dhcp_lease.controlplanes[0].address
  ttl     = 300
}

resource "routeros_dns_record" "controlplane-records" {
  count = var.worker.nb_vms
  name    = format("%s-cp-%s.%s", var.cluster_name, count.index, var.cluster_endpoint)
  address = routeros_dhcp_lease.controlplanes[count.index].address
  ttl     = 300
}

resource "routeros_dns_record" "worker-records" {
  count = var.worker.nb_vms
  name    = format("%s-worker-%s.%s", var.cluster_name, count.index, var.cluster_endpoint)
  address = routeros_dhcp_lease.workers[count.index].address
  ttl     = 300
}

// ------------
// TALOS
// ------------

