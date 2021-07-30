
resource "azurerm_eventgrid_domain" "demo" {
  name                = join("-", ["eg", var.namespace, var.environment])
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = {
    environment = var.environment
  }
}

resource "azurerm_eventgrid_domain_topic" "demo_added" {
  name                = "resourceadded"
  domain_name         = azurerm_eventgrid_domain.demo.name
  resource_group_name = var.resource_group_name


}

resource "azurerm_eventgrid_domain_topic" "demo_deleted" {
  name                = "resourcedeleted"
  domain_name         = azurerm_eventgrid_domain.demo.name
  resource_group_name = var.resource_group_name


}