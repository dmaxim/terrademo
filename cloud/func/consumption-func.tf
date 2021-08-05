

# Azure Storage

resource "azurerm_storage_account" "funcs" {
  name                     = join("", [var.storage_account_name, var.environment]) 
  resource_group_name      = azurerm_resource_group.funcs.name
  location                 = azurerm_resource_group.funcs.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
}

resource "azurerm_app_service_plan" "funcs" {
  name                = join("-", ["plan", var.namespace, var.environment])
  resource_group_name = azurerm_resource_group.funcs.name
  location            = azurerm_resource_group.funcs.location
  kind                = "FunctionApp"

  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}


resource "azurerm_function_app" "app_one" {
  name                       = join("-", ["appone", var.namespace, var.environment])
  resource_group_name        = azurerm_resource_group.funcs.name
  location                   = azurerm_resource_group.funcs.location
  app_service_plan_id        = azurerm_app_service_plan.funcs.id
  storage_account_name       = azurerm_storage_account.funcs.name
  storage_account_access_key = azurerm_storage_account.funcs.primary_access_key
}