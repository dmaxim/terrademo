
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

resource "azurerm_storage_encryption_scope" "dev_ops" {
  name               = "microsoftmanaged"
  storage_account_id = azurerm_storage_account.dev_ops.id
  source             = "Microsoft.Storage"
}


# Create the Azure Storage Container 
resource "azurerm_storage_container" "dev_ops" {
  name                  = var.azure_storage_container
  storage_account_name  = azurerm_storage_account.dev_ops.name
  container_access_type = "private"
}

data "azurerm_client_config" "current" {}

data "azuread_user" "dev_ops_admin" {
    user_principal_name = var.dev_ops_admin_user
}

# Create the Key Vault To Use For Terraform Secrets

resource "azurerm_key_vault" "dev_ops" {
  name                        = join("-", ["kv", "mxinfo", var.namespace, var.environment])
  resource_group_name         = azurerm_resource_group.dev_ops.name
  location                    = azurerm_resource_group.dev_ops.location
  enabled_for_disk_encryption = false
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

}

# Allow the admin user to access secrets

resource "azurerm_key_vault_access_policy" "dev_ops_reader" {
    key_vault_id = azurerm_key_vault.dev_ops.id
    tenant_id  = data.azurerm_client_config.current.tenant_id
    object_id = data.azuread_user.dev_ops_admin.id

    secret_permissions = [
        "Get",
        "List"
    ]
}

# Allow the service principal to access secrets

resource "azurerm_key_vault_access_policy" "dev_ops_sp_reader" {
    key_vault_id = azurerm_key_vault.dev_ops.id
    tenant_id  = data.azurerm_client_config.current.tenant_id
    object_id = azuread_service_principal.dev_ops.id

    secret_permissions = [
        "Get",
        "List"
    ]
}