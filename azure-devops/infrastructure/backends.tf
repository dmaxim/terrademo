terraform {
    backend "azurerm" {
        resource_group_name = "rg-mxinfo-devops-infra"
        storage_account_name = "mxinfodevopsinfra"
        container_name = "terraform"
        key = "devops.infra.tfstate"
    }
}