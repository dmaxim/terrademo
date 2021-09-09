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

# Cluster Network Variables
variable "vnet_address_space" {
  type        = string
  description = "Cluster Virtual Network address space"
}

variable "subnet_address_prefix" {
  type        = string
  description = "Cluster vnet primary subnet address prefix"
}

# Cluster Variables
variable "k8s_version" {
  type        = string
  description = "Kubernetes Version for the cluster"
}

variable "authorized_ips" {
  type        = string
  sensitive   = true
  description = "IP Addresses with access to the cluster API"
}

variable "default_node_pool_name" {
  type        = string
  description = "Node Pool name for the default nodes"
}

variable "default_node_count" {
  type        = string
  description = "Number of nodes in the default pool"
}

variable "default_node_pool_vm_size" {
  type        = string
  description = "VM Size for the nodes in the default pool"
}

variable "admin_user_name" {
  type        = string
  description = "Admin user account to create on the cluster nodes"
  sensitive   = true
}

variable "ssh_key" {
  type        = string
  sensitive   = true
  description = "Publish ssh key for access to the cluster nodes"
}