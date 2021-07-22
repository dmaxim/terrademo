# Storage account supporting the app service


resource "azurerm_storage_account" "demo-storage" {
  name                     = join("", [var.application-storage-account, var.environment])
  resource_group_name      = azurerm_resource_group.demo-rg.name
  location                 = azurerm_resource_group.demo-rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"
  /*
  network_rules {

    default_action             = "Allow"
    virtual_network_subnet_ids = [azurerm_subnet.demo-subnet.id]
   # ip_rules                   = [var.authorized-ips]
  }
*/
  tags = {
    environment = var.environment
  }
}


# Create Data Protection Api Container

resource "azurerm_storage_container" "veritas-dapi-container" {
  name                  = "dapi"
  storage_account_name  = azurerm_storage_account.demo-storage.name
  container_access_type = "private"
}
