variable "resource_group_name" {
  type        = string
  description = "Resource group for all infrastructure"
}

variable "namespace" {
  type        = string
  description = "Namespace for all resources"
}


variable "location" {
  type        = string
  description = "The Azure region for all resources"

}

variable "environment" {
  type        = string
  description = "Environment name"
}


variable "asb_sku" {
  type        = string
  description = "SKU for the ASB Namespace"
}

# SQL Server

variable "audit_storage_account" {
  type        = string
  description = "Name of the storage account to create for storing the SQL Server audit logs"
}

variable "audit_storage_account_tier" {
  type        = string
  description = "SQL Server account tier"
}

variable "replication_type" {
  type        = string
  description = "SQL Server replication type"
}

variable "sql_server_version" {
  type        = string
  description = "SQL Server Version"
}

variable "sql_admin" {
  type        = string
  description = "SA User account name"
  sensitive   = true
}

variable "sql_admin_password" {
  type        = string
  description = "SA Admin Password"
  sensitive   = true
}

variable "sql_job_agent_user_name" {
  description = "User Name to run SQL Elastic Jobs under"
  sensitive   = true
}

variable "sql_job_agent_password" {
  description = "Password for the SQL Job Agent user"
  sensitive   = true
}

variable "whitelist_ip_address" {
  description = "IP Address for external access to the sql database"
}

# App Services for Web Jobs
variable "webjob_app_service_plan_tier" {
  type        = string
  description = "Performance tier of the web job application service plan"
}

variable "webjob_app_service_plan_size" {
  type        = string
  description = "App service plan size for the web job application service plan"

}
# Function Apps
variable "function_app_storage_account" {
  type        = string
  description = "Azure storage account for use by the function apps"
}

variable "vnet_address_space" {
  type        = string
  description = "CIDR Block for the VNET containing the azure resources"
}