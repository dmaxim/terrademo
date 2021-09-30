terraform {
  backend "remote" {
    organization = "mxinfo-demo"

    workspaces {
      name = "move-app-service"
    }
  }


}