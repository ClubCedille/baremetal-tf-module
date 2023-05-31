module "sandbox-cluster" {
  source = "../"
  cluster_name = "sandbox"
  cluster_endpoint = "sandbox.codegameeat.com"
  talos_version = "1.4.0"
  disks_sr_id = "51084a9c-4d01-253d-0019-308b8fc5d3d3"
  iso_sr_id = "38ce84a4-6610-f94b-23db-9623daa21b90"
  network_id = "aa5492ec-c016-d624-b556-2ad053223459"
  xen_pool_id = "40f23bd4-e6d0-983a-34da-feb1bbd89bb2"
  oidc-client-id = "NA"
  oidc-issuer-url = "not.applicable.com"
  subnet = "10.0.1.0/24"
  routeros_network_interfaces = ["ether2", "ether3", "ether4"]
  vlan = 10
  controlplane = {
    cpus = 1
    disk_gb = 20
    memory_max = 4
    nb_vms = 3
  }
  worker = {
    cpus = 2
    disk_gb = 40
    memory_max = 12
    nb_vms = 3
  }
}

