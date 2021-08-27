// Resource Group

resource "azurerm_resource_group" "messaging" {
  name     = var.resource_group_name
  location = var.location

}

// ASB

