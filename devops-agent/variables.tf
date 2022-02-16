
variable "namespace" {
  type = string
  default = "devops"
}

variable "location" {
  type = string
  default = "eastus"
}

variable "environment" {
  type = string
  default = "dev"
}

variable "vm_size" {
  type = string
  default = "Standard_D2_V2"
}

variable "configuration_key_vault" {
  type = string
  default = "kv-setrans-devops-prod"
}

variable "configuration_key_vault_resource_group" {
  type = string
  default = "rg-setrans-devops-prod"
}
