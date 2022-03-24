#---cloud-cli/vnet-peers/backends.tf ----

terraform {
  backend "remote" {
    organization = "mxinformatics"

    workspaces {
      name = "simulated-peering-test"
    }
  }


}