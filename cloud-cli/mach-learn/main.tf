resource "azurerm_resource_group" "ml" {
  name     = join("-", ["rg", var.namespace, var.environment])
  location = var.location

  tags = {
    environment = var.environment
  }
}


resource "azurerm_application_insights" "ml" {
  name                = join("-", ["ai", var.namespace, var.environment])
  location            = azurerm_resource_group.ml.location
  resource_group_name = azurerm_resource_group.ml.name
  application_type    = "web"
}


resource "azurerm_key_vault" "ml" {
  name                = join("-", ["kv", var.namespace, var.environment])
  location            = azurerm_resource_group.ml.location
  resource_group_name = azurerm_resource_group.ml.name
  tenant_id           = var.azure_tenant_id
  sku_name            = "premium"


}

resource "azurerm_storage_account" "ml" {
  name                     = "mxinfomlws"
  location                 = azurerm_resource_group.ml.location
  resource_group_name      = azurerm_resource_group.ml.name
  account_tier             = "Standard"
  account_replication_type = "LRS"

}

resource "azurerm_machine_learning_workspace" "ml" {
  name                    = join("-", ["ml", var.namespace, var.environment])
  location                = azurerm_resource_group.ml.location
  resource_group_name     = azurerm_resource_group.ml.name
  application_insights_id = azurerm_application_insights.ml.id
  key_vault_id            = azurerm_key_vault.ml.id
  storage_account_id      = azurerm_storage_account.ml.id

  identity {
    type = "SystemAssigned"
  }
}