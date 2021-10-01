variable "namespace" {
  type        = string
  description = "Namespace for all resources"
  default = "mxmess"
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

variable "whitelisted_ip_address" {
    type = string
    default = "24.9.188.221"
}
