# Environment
variable "namespace" {}
variable "resource_group_name" {}
variable "location" {}
variable "environment" {}

# Cluster
variable "k8s_version" {}
variable "authorized_ips" {
  sensitive = true
}
variable "default_node_pool_name" {}
variable "default_node_count" {}
variable "default_node_pool_vm_size" {}
variable "cluster_subnet_id" {}

# Linux Environment
variable "admin_user_name" {
  sensitive = true
}
variable "ssh_key" {
  sensitive = true
}

