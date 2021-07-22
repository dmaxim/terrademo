variable "azure-subscription-id" {}

variable "azure-service-principal-id" {}

variable "azure-service-principal-secret" {}

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

variable "database-name" {
  type        = string
  description = "Veritas database name"
}

variable "sql-server-name" {
  type        = string
  description = "Name of the shared SQL Server instance"
}

variable "sql-server-resource-group" {
  type        = string
  description = "SQL Server resource group"
}

variable "database-vnet-name" {
  type        = string
  description = "Database VNET name"
}

variable "database-resource-group" {
  type        = string
  description = "Database resource group name"
}


variable "application-storage-account" {
  type        = string
  description = "Azure Storage account used by the application"
}

variable "authorized-ips" {
  type        = string
  description = "IP Addresses with access to vnet resources"
}

variable "vnet-address-space" {
  type        = string
  description = "Address space for the app service vnet"
}

variable "subnet-address-prefix" {
  type        = string
  description = "Subnet addresses"
}