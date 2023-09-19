terraform {
  required_version = "~> 1.3"
  required_providers {
    talos = {
      source = "siderolabs/talos"
      version = "0.2.0"
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
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.23.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.11.0"
    }
  }
}

provider "kubernetes" {
    config_path = var.omni_sa_kubeconfig
}

provider "helm" {
  kubernetes {
    config_path = var.omni_sa_kubeconfig
  }
}

provider "routeros" {
  hosturl  = "https://${var.router_host}" # Or set MIKROTIK_HOST environment variable
  username = var.router_host              # Or set MIKROTIK_USER environment variable
  password = var.router_password          # Or set MIKROTIK_PASSWORD environment variable
  insecure = true                         # Or set MIKROTIK_INSECURE environment variable
}