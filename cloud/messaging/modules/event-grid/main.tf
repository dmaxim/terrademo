

resource "azurerm_eventgrid_topic" "demo" {
  name                = join("-", ["egt", var.namespace, var.environment])
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = {
    environment = var.environment
  }

}