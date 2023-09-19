# Don't know how to use helm_templates with terraform, but ideally we would...
# data "helm_template" "vcluster_instance" {
# 
# }

# resource "helm_release" "vclusters" {
#   for_each  = { for c in var.vclusters : c.name => c.namespace }
  
#   name       = each.key
#   namespace  = each.value

#   repository = "https://charts.loft.sh"
#   chart      = "vcluster"
#   create_namespace = true
  
#   values = [
#     "${file("${path.module}/k8s/vcluster.yaml.tmpl")}"
#   ]
# }