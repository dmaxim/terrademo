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
  type = string
  description = "Address space for the WAN Vnet"
}

variable "gateway_subnet_address_prefix" {
  type = string
  description = "Gateway Subnet address space"
}


variable "private_subnet_address_prefix" {
  type = string
  description = "Private Subnet address space"
}