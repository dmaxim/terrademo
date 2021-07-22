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

variable "app-service-vnet-name" {
  type        = string
  description = "Backend App Service VNet Name"
}

variable "app-service-resource-group" {
  type        = string
  description = "Resource group name of the back end app service vnet"
}