variable "namespace" {
  type        = string
  description = "Namespace for Azure resources"
  default     = "devops"
}

variable "location" {
  type        = string
  description = "Azure region for the resources"
  default     = "eastus"
}

variable "azure_storage_container" {
  type        = string
  description = "Name for the Azure Storage Container to be used for Terraform state"
  default     = "terraform"
}

variable "environment" {
  type        = string
  description = "Environment tag for all resources"
  default     = "infra"
}