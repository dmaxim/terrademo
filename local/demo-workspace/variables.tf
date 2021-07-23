# --- Workspace setup ---

variable "github_token" {}
variable "github_owner" {}
variable "github_demo_repository" {}
variable "tfe_token" {}
variable "tf_workspace_name" {}
variable "repository_working_directory" {}


# --- Variable Setup  ---
variable "azure-subscription-id" {}
variable "azure-service-principal-id" {}

variable "azure-service-principal-secret" {
  sensitive = true
}

variable "azure-tenant-id" {}
variable "namespace" {}
variable "location" {}
variable "environment" {}
variable "database-name" {}
variable "sql-server-name" {}
variable "sql-server-resource-group" {}
variable "database-vnet-name" {}
variable "database-resource-group" {}
variable "application-storage-account" {}
variable "authorized-ips" {}
variable "vnet-address-space" {}
variable "subnet-address-prefix" {}
variable "certificate_secret_id" {
  sensitive = true
}