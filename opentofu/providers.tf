terraform {
  required_version = ">= 1.7.0"

  required_providers {
    exoscale = {
      source  = "exoscale/exoscale"
      version = "~> 0.64.1"
    }
    tls = {
      source = "hashicorp/tls"
      version = "~> 4.1.0"
    }
  }
}

provider "exoscale" {}
