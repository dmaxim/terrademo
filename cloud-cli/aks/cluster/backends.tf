terraform {
  backend "remote" {
    organization = "mxinfo-demo"

    workspaces {
      name = "k8s-testing"
    }
  }


}