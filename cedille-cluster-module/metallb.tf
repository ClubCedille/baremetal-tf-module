# Authors: Simon Boyer, Michael Sakellaropoulos




# resource "kubernetes_manifest" "metallb_bgp_peer" {
#   manifest = {
#     "apiVersion" = "metallb.io/v1beta2"
#     "kind"       = "BGPPeer"
#     "metadata" = {
#       "name"      = "router"
#       "namespace" = "metallb-system"
#     }
#     "spec" = {
#       "myASN"       = 64500
#       "peerASN"     = 65530
#       "peerAddress" = cidrhost(var.network_config.network, 1)
#     }
#   }
#   depends_on = [
#     routeros_routing_bgp_connection.metallb-bgp,
#     kubernetes_manifest.metallb_operator
#   ]
# }