#---cloud-cli/dns/backends.tf ----

terraform {
  backend "remote" {
    organization = "mxinformatics"

    workspaces {
      name = "dns-management"
    }
  }


}