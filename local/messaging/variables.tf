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

variable "hub-name" {
  type        = string
  description = "Base name for all event hubs"
  default     = "setimessage"
}