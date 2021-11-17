resource "azurerm_resource_group" "dev_ops" {
  name     = join("-", ["rg", var.namespace])
  location = var.location

  tags = {
    environment = var.ENVIRONMENT
  }
}


resource "azurerm_storage_account" "dev_ops" {
  name                      = join("", ["mxinfo", var.namespace, var.ENVIRONMENT])
  resource_group_name       = azurerm_resource_group.dev_ops.name
  location                  = azurerm_resource_group.dev_ops.location
  account_tier              = var.replication_type
  account_replication_type  = "LRS"
  enable_https_traffic_only = true


  tags = {
    Environment = var.ENVIRONMENT
  }
}