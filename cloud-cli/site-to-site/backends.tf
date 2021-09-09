terraform {
  backend "remote" {
    organization = "mxinfo-demo"

    workspaces {
      name = "site-to-site"
    }
  }


}