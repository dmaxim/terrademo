
provider "azurerm" {
  subscription_id = var.azure-subscription-id
  client_id       = var.azure-service-principal-id
  client_secret   = var.azure-service-principal-secret
  tenant_id       = var.azure-tenant-id
  features {}
}

provider "azuread" {
  client_id     = var.azure-service-principal-id
  client_secret = var.azure-service-principal-secret
  tenant_id     = var.azure-tenant-id
}