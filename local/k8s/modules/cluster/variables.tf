variable "location" {}
variable "environment" {}
variable "namespace" {}
variable "resource_group_name" {}
variable "k8s_version" {}
variable "authorized_ips" {}
variable "ssh_key" {
    sensitive = true
}
variable "cluster_subnet_id" {}
