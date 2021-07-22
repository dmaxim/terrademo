

variable "resource_group_name" {
  type        = string
  description = "Resource group to use for the resources"
}

variable "resource_location" {
  type        = string
  description = "Location for all resources"

}

variable "environment" {
  type        = string
  description = "Environment name"

}

variable "application_storage_account" {
  type        = string
  description = "Base storage account name"

}

variable "index" {
  type        = string
  description = "Index for the resources to allow the creation of multiple isntances of a resource type"

}

variable "vnet_address_space" {
  type        = string
  description = "Address space for the vnet"
}

variable "subnet_address_space" {
  type        = string
  description = "Address space for the app service subnet"
}

variable "namespace" {
  type        = string
  description = "Namespace for all resources"
}

variable "database_vnet_name" {
  type        = string
  description = "Name of the SQL Server VNet"
}

variable "database_resource_group" {
  type        = string
  description = "Resource group for the SQL Server instance"
}

variable "sql_server_name" {
  type        = string
  description = "SQL Server name"
}

variable "database_name" {
  type        = string
  description = "Application Database Name"
}

variable "app_service_plan_id" {
  type        = string
  description = "Identifier for the App Service Plan"
}

variable "azure_tenant_id" {
    type = string
    description = "Azure AD Tenant Id"
}