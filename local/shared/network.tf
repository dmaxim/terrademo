# Create Virtual Network
resource "azurerm_virtual_network" "demo_shared_network" {
  name                = join("-", ["vnet", var.namespace, var.environment])
  location            = azurerm_resource_group.shared_rg.location
  resource_group_name = azurerm_resource_group.shared_rg.name
  address_space       = [var.vnet-address-space]
}

# Create subnet
resource "azurerm_subnet" "demo_shared_subnet" {
  name                 = join("-", ["snet", var.namespace, var.environment])
  resource_group_name  = azurerm_resource_group.shared_rg.name
  address_prefixes     = [var.subnet-address-prefix]
  virtual_network_name = azurerm_virtual_network.demo_shared_network.name

  service_endpoints = ["Microsoft.Sql"]

}
