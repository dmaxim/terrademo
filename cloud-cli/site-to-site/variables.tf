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


variable "vnet_address_space" {
  type        = string
  description = "Address space for the WAN Vnet"
}

variable "gateway_subnet_address_prefix" {
  type        = string
  description = "Gateway Subnet address space"
}


variable "private_subnet_address_prefix" {
  type        = string
  description = "Private Subnet address space"
}

variable "public_subnet_address_prefix" {
  type        = string
  description = "Public Subnet address space"
}

variable "local_vpn_address" {
  type        = string
  description = "Local external ip address"
}

variable "local_address_space" {
  type        = string
  description = "Local network address space"
}

variable "public_ssh_key" {
  type        = string
  sensitive   = true
  description = "Public SSH Key for remote access to vm"

}

variable "vpn_shared_key" {
  type        = string
  sensitive   = true
  description = "IPSec shared key used by local vpn router and azure network gateway"
}


variable "bastion_subnet_address_prefix" {
  type        = string
  description = "Address space for the bastion host"
}

variable "whitelisted_ip_address" {
  type        = string
  description = "IP Address to allow access to the bastion host"
}

variable "audit_storage_account" {
  type        = string
  description = "SQL Server Audit Storage account name"
}

variable "audit_storage_account_tier" {
  type        = string
  description = "SQL Server Audit Storage account tier"
}

variable "replication_type" {
  type        = string
  description = "Audit storage account replication type"
}

variable "sql_admin" {
  type        = string
  sensitive   = true
  description = "SQL Admin account"
}

variable "sql_admin_password" {
  type        = string
  sensitive   = true
  description = "SA Account for SQL server"
}


variable "entity_context" {
  type        = string
  sensitive   = true
  description = "Database connection string for the entity context"
}

variable "asb_sku" {
  type        = string
  default     = "Standard"
  description = "SKU for the Azure Service Bus Namespace"
}

variable "azure_storage_connection" {
  type = string
  description = "Connection string to Azure Storage for message queue"
  sensitive = true
}