terraform {
  backend "remote" {
    organization = "mxinfo-demo"

    workspaces {
      name = "az-func"
    }
  }


}