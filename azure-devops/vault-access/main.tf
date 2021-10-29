
data "azurerm_key_vault" "devops_vault" {
  name                = var.key_vault_name
  resource_group_name = var.key_vault_resource_group
}

data "azurerm_key_vault_secret" "db_admin" {
  name         = var.secret_name
  key_vault_id = data.azurerm_key_vault.devops_vault.id
}


output "db_admin_secret" {
  sensitive = true
  value = data.azurerm_key_vault_secret.db_admin.value
}