#---cloud-cli/vnet-peers/versions.tf ----

terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }

  }
  required_version = ">= 1.0"
}