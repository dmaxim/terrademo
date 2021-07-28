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