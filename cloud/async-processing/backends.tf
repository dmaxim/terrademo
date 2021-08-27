terraform {
  backend "remote" {
    organization = "mxinfo-demo"

    workspaces {
      name = "async-processing"
    }
  }


}