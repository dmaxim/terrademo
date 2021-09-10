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

variable "local_vpn_address" {
  type = string
  description = "Local external ip address"
}

variable "local_address_space" {
  type = string
  description = "Local network address space"
}

variable "public_ssh_key" { 
  type = string
  sensitive = true
  description = "Public SSH Key for remote access to vm"
  
}

variable "vpn_shared_key" {
  type = string
  sensitive = true
  description = "IPSec shared key used by local vpn router and azure network gateway"
}