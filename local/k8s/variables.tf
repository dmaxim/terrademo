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

variable "vnet_address_space" {
  type        = string
  description = "Cluster VNET address space"
}

variable "subnet_address_prefix" {
  type        = string
  description = "Cluster subnet address space"
}

variable "k8s_version" {
  type        = string
  description = "AKS Cluster K8s version"
}

variable "authorized_ips" {
  type        = string
  description = "IP addresses for cluster API access"
}

variable "ssh_key" {
  type        = string
  description = "Public SSH Key for remote access to nodes"
  sensitive   = true
}
  