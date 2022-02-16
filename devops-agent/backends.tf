terraform {
  backend "azurerm" {
    resource_group_name  = "rg-setrans-devops-prod"
    storage_account_name = "setransdevopsprod"
    container_name       = "terraform"
    key                  = "devops.vms.tfstate"
  }
}