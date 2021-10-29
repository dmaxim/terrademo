
# Create the resource group

resource "azurerm_resource_group" "dev_ops" {
  name     = join("-", ["rg", "mxinfo", var.namespace, var.environment])
  location = var.location

  tags = {
    Environment = var.environment
  }
}

# Create the Azure Storage Account

resource "azurerm_storage_account" "dev_ops" {
  name                      = join("", ["mxinfo", var.namespace, var.environment])
  resource_group_name       = azurerm_resource_group.dev_ops.name
  location                  = azurerm_resource_group.dev_ops.location
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  enable_https_traffic_only = true

  tags = {
    Environment = var.environment
  }
}


# Create the Azure Storage Container 
resource "azurerm_storage_container" "dev_ops" {
  name                  = var.azure_storage_container
  storage_account_name  = azurerm_storage_account.dev_ops.name
  container_access_type = "private"
}