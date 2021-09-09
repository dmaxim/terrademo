variable "resource_group_name" {
    type = string
    description = "Resource group for the identities"
}


variable "location" {
    type = string
    description = "The Azure region for all resources"
}

variable "environment" {
    type = string
    description = "Environment Name"
}