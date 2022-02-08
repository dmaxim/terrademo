terraform {
  backend "remote" {
    organization = "mxinformatics"

    workspaces {
      name = "peering-test"
    }
  }


}