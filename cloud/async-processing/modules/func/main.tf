# Azure Storage

resource "azurerm_storage_account" "funcs" {
  name                     = join("", [var.storage_account_name, var.environment])
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = var.storage_account_tier
  account_replication_type = var.storage_account_replication_type
  account_kind             = var.storage_account_kind
}

resource "azurerm_app_service_plan" "funcs" {
  name                = join("-", ["plan", "func", var.namespace, var.environment])
  resource_group_name = var.resource_group_name
  location            = var.location
  kind                = "FunctionApp"

  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}


resource "azurerm_function_app" "app" {
  for_each                   = var.function_apps
  name                       = each.value.name
  resource_group_name        = var.resource_group_name
  location                   = var.location
  app_service_plan_id        = azurerm_app_service_plan.funcs.id
  storage_account_name       = azurerm_storage_account.funcs.name
  storage_account_access_key = azurerm_storage_account.funcs.primary_access_key
}