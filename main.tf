# Variables
variable "azure-subscription-id" {}

variable "azure-service-principal-id" {}

variable "azure-service-principal-secret" {}

variable "azure-tenant-id" {}


terraform {
    backend "remote" {
        organization = "MxInformatics"

        workspaces {
            name = "terrademo"
        }
    }
}


# Init environment

provider "azurerm" {
    subscription_id = "${var.azure-subscription-id}"
    client_id       = "${var.azure-service-principal-id}"
    client_secret   = "${var.azure-service-principal-secret}"
    tenant_id       = "${var.azure-tenant-id}"
    version = "~> 1.30"
    
}


# Create resource group
resource "azurerm_resource_group" "event-hub-resource-group" {
    name     = "${var.resource-group}"
    location = "${var.location}"

    tags = {
        environment = "${var.environment}"
    }
}

#*********************************
# Create the Event Hub Namespace
#*********************************

resource "azurerm_eventhub_namespace" "event-hub-ns" {
  name                = "${var.prefix}-ns"
  location            = "${azurerm_resource_group.event-hub-resource-group.location}"
  resource_group_name = "${azurerm_resource_group.event-hub-resource-group.name}"

  sku      = "Standard"
  capacity = 1

  tags = {
    environment = "${var.environment}"
  }
}

