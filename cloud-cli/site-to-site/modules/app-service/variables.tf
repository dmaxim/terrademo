variable "namespace" {}
variable "environment" {}
variable "resource_group_name" {}
variable "location" {}
variable "app_service_subnet_id" {}
variable "entity_context" {
  sensitive = true
}

variable "azure_storage_connection" {
  sensitive = true
}