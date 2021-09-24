variable "namespace" {
  type        = string
  description = "Namespace for all resources"
  default = "move-new"
}


variable "location" {
  type        = string
  description = "The Azure region for all resources"
  default = "eastus"

}

variable "environment" {
  type        = string
  description = "Environment name"
  default = "demo"
}
