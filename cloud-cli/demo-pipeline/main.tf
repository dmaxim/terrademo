
resource "azurerm_resource_group" "demo" {
  name     = join("-", ["rg", var.namespace, var.environment])
  location = var.location

}


resource "azurerm_storage_account" "demo-storage" {
  name                     = join("", ["pipeline1", var.environment])
  resource_group_name      = azurerm_resource_group.demo.name
  location                 = azurerm_resource_group.demo.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"

  tags = {
    environment = var.environment
  }
}
