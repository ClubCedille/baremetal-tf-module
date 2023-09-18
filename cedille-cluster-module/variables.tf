variable "omni_cluster_name" {
  type = string
}

variable "omni_cluster_endpoint" {
  type = string
}

variable "omni_sa_kubeconfig" {
  type = string
  sensitive = true
}

variable "talos_version" {
  type    = string
  default = "1.5.1"
}

variable "talos_repo" {
  type    = string
  default = "https://github.com/siderolabs/talos"
}

variable "router_host" {
  type    = string
  default = "192.168.88.1"
}

variable "router_user" {
  type    = string
  default = "admin"
}

variable "router_password" {
  type      = string
  sensitive = true
}

variable "servers" {
  type = list(object({
    controlplane = bool
    switch_port  = string
    mac_addr     = string
    hostname     = string
  }))
}

variable "vclusters" {
  type = list(object({
    name = string
    namespace = string
  }))
}

variable "vlan" {
  type = number
}

variable "network_config" {
  type = object({
    lease_time     = optional(string, "30d 00:00:00")
    domain         = string
    gateway        = string
    network        = string
    dns            = string
    bgp_cluster_as = optional(number, 64500)
    bgp_router_as  = optional(number, 65530)
  })
}

# variable "oidc-issuer-url" {
#   type = string
# }

# variable "oidc-client-id" {
#   type = string
# }

# variable "oidc-client-secret" {
#   type      = string
#   sensitive = true
# }