#--- devops-agent/configuration.tf ---#
# Retrieve secret values from Azure Key Vault

data "azurerm_key_vault" "configuration" {
  name                = var.configuration_key_vault
  resource_group_name = var.configuration_key_vault_resource_group
}

data "azurerm_key_vault_secret" "vm_admin_user" {
  name         = "devops-vm-admin"
  key_vault_id = data.azurerm_key_vault.configuration.id
}


data "azurerm_key_vault_secret" "vm_admin_ssh_key_path" {
  name         = "devops-vm-admin-ssh-key-path"
  key_vault_id = data.azurerm_key_vault.configuration.id
}

data "azurerm_key_vault_secret" "windows_admin_password" {
  name         = "devops-windows-admin-password"
  key_vault_id = data.azurerm_key_vault.configuration.id
}

data "azurerm_key_vault_secret" "vm_admin_ssh_key" {
  name         = "devops-vm-admin-ssh-public-key"
  key_vault_id = data.azurerm_key_vault.configuration.id
}