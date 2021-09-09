terraform {
  backend "remote" {
    organization = "seti-demo"

    workspaces {
      name = "k8s-poc"
    }
  }


}