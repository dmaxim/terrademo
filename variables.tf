variable "resource-group" {
    type= "string"
    default = "rg-demo-tfcloud-eventhub"
    description = "Resource group name"
}


variable "prefix" {
    type = "string"
    default = "tfcloud-eventhub"
    description = "Prefix to use for all resources created"
}

variable "hub-one" {
    type ="string"
    default = "hub-one"
    description = "Event Hub One Name"
}

variable "hub-two" {
    type = "string"
    default = "hub-two"
    description = "Event Hub Two Name"
}


variable "location" {
    type = "string"
    default = "eastus"
    description = "The azure region for all resources"
}

variable "environment" {
    type = "string"
    default = "Demo Event Hub Namespace"
}

variable "message-retention" {
    type = string
    default = "3"
}

variable "partition-count" {
    type = string
    default = "2"
}
