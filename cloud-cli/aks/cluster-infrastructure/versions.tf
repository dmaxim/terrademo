
terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.1.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.2.0"
    }
  }
  required_version = "~> 1.0"
}