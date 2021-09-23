variable "namespace" {
  type        = string
  description = "Namespace for all resources"
  default = "move-old"
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


variable "storage_name" {
  type = string
  description = "Azure storage account name"
  default = "olddemo"
}


variable "storage_queue_name" {
  type = string
  description = "Azure  storage queue name"
  default = "demoevent"
}