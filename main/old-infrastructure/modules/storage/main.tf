
// Create storage account for queue
resource "azurerm_storage_account" "queue" {
  name                     = var.storage_queue_account
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

}

// Create a test queue

resource "azurerm_storage_queue" "demo" {
  name                 = var.storage_queue_name
  storage_account_name = azurerm_storage_account.queue.name
}

