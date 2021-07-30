

resource "azurerm_eventgrid_topic" "demo" {
  name                = join("-", ["egt", var.namespace, var.environment, "resource-added"])
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = {
    environment = var.environment
  }

}

resource "azurerm_eventgrid_topic" "demo_deleted" {
  name                = join("-", ["egt", var.namespace, var.environment, "resource-deleted"])
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = {
    environment = var.environment
  }

}