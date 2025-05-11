terraform {
  required_version = ">= 1.11.0"

  required_providers {
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.1.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.36.0"
    }
  }
}

provider "kubernetes" {
  config_path    = "./k8s-demo-config"
  config_context = "kind-k8s-demo"
}
