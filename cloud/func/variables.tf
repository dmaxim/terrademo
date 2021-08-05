
variable "location" {
  type        = string
  description = "Azure resource location"
}

variable "namespace" {
  type        = string
  description = "Namespace for Azure resources"
}

variable "environment" {
  type        = string
  description = "Environment for resource classification"
}

variable "storage_account_name" {
  type        = string
  description = "Azure storage for the function app"
}