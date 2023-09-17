## OMNI:

resource "local_file" "kubeconfig" {
  filename = "${var.omni_cluster_name}.kubeconfig.yaml"
  content  = file(var.omni_sa_kubeconfig)
}

# resource "talos_machine_secrets" "secrets" {}

# data "talos_client_configuration" "this" {
#   cluster_name         = var.cluster_name
#   client_configuration = talos_machine_secrets.secrets.client_configuration
#   endpoints            = [var.cluster_endpoint]
# }

# data "talos_cluster_kubeconfig" "kubeconfig" {
#   client_configuration = talos_machine_secrets.secrets.client_configuration
#   node                 = talos_machine_configuration_apply.controlplanes[0].node
#   wait                 = true
# }

# resource "local_file" "kubeconfig" {
#   filename = "${var.cluster_name}.kubeconfig.yaml"
#   content  = data.talos_cluster_kubeconfig.kubeconfig.kubeconfig_raw
# }