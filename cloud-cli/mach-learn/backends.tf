terraform {
  backend "remote" {
    organization = "mxinfo-demo"

    workspaces {
      name = "machine-learning"
    }
  }


}