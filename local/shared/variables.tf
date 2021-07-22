variable "azure-subscription-id" {}

variable "azure-service-principal-id" {}

variable "azure-service-principal-secret" {
  sensitive = true
}

variable "azure-tenant-id" {}


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

variable "sql-server-storage-account-tier" {
  type        = string
  description = "Account Tier for Azure SQL Server audit storage"
}


variable "sql-server-storage-replication-type" {
  type        = string
  description = "Account replication type for Azure SQL Server audit storage"
}

variable "storage-account-prefix" {
  type        = string
  description = "Prefix for storage account names"
}

variable "sql-server-version" {
  type        = string
  description = "SQL Server Version"
}

variable "sql-admin" {
  type        = string
  description = "User name for SQL Server Admin Access"
}

variable "sql-admin-password" {
  type        = string
  description = "SQL Admin Password"
  sensitive = true
}

variable "authorized-ip" {
  type        = string
  description = "Ip Address for SQL Server access"
  sensitive = true
}

variable "vnet-address-space" {
  type = string
  description = "CIDR for vnet"
}

variable "subnet-address-prefix" {
  type = string
  description = "Address space for subnet"
}