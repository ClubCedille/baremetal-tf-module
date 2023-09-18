module "cedille-cluster" {
  source = "../cedille-cluster-module"
  omni_cluster_name = "cedille-cluster"
  omni_cluster_endpoint = ""
  omni_sa_kubeconfig = var.omni_sa_kubeconfig

#   oidc-client-id = "SOME_ID"
#   oidc-issuer-url = "https://accounts.google.com"

  router_host = var.router_host
  router_user = var.router_user
  router_password = var.router_password

  network_config = var.network_config

  vlan = 10

  servers = var.servers

  vclusters = var.vclusters
}

