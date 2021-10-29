

variable "key_vault_name" {
  type        = string
  description = "Name of the devops key vault"
}

variable "key_vault_resource_group" {
  type        = string
  description = "Azure Key Vault resource group"
}

variable "secret_name" {
  type        = string
  description = "The name of the secret to read"
}