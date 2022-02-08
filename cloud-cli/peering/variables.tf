
variable "namespace" {
  type    = string
  default = "mxinfo-peer"

}

variable "environment" {
  type    = string
  default = "test"
}

variable "location" {
  type    = string
  default = "eastus"
}

variable "application_version" {
  type = string
}

variable "azure_storage_connection" {
  type        = string
  description = "Connection string to Azure Storage for message queue"
  sensitive   = true
}

variable "azure_service_bus_connection" {
  type        = string
  description = "Connection string for Azure Service Bus"
  sensitive   = true
}

variable "entity_context" {
  type        = string
  sensitive   = true
  description = "Database connection string for the entity context"
}


variable "firewall_ip_address" {
  type = string
  default = "10.20.0.4"
}