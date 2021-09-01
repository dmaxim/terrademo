
variable "namespace" {}

variable "audit_storage_account" {}

variable "environment" {}

variable "resource_group_name" {}

variable "location" {}

variable "audit_storage_account_tier" {}

variable "replication_type" {}

variable "sql_server_version" {}

variable "sql_admin" {}

variable "sql_admin_password" {}

variable "databases" {}

variable "sql_job_agent_user_name" {
    sensitive = true
}

variable "sql_job_agent_password" {
    sensitive = true
}