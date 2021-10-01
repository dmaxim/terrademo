terraform {
  backend "remote" {
    organization = "mxinfo-demo"

    workspaces {
      name = "s2s"
    }
  }


}