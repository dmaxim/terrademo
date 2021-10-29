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

variable "tenant_id" {
    type = string
    description = "Azure AD Tenant Id"
}

variable "dev_ops_admin_user" {
    type = string
    description = "User to grant access to the Terraform Key Vault"
}

# Service principal for RBAC

variable "dev_ops_principal_name" {
    type = string
    description = "Service principal used in DevOps pipelines"
}

