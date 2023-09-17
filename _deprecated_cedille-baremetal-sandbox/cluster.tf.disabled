module "sandbox-cluster" {
  source = "../"
  cluster_name = "sandbox"
  cluster_endpoint = "sandbox.codegameeat.com"
  talos_version = "1.4.0"
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

