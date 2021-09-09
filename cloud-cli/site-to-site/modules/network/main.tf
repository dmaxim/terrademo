resource "azurerm_virtual_network" "wan" {
  name                = join("-", ["vnet", var.namespace, var.environment])
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = [var.vnet_address_space]
}

resource "azurerm_subnet" "gateway_subnet" {
  name                 = "GatewaySubnet"
  resource_group_name  = var.resource_group_name
  address_prefixes     = [var.gateway_subnet_address_prefix]
  virtual_network_name = azurerm_virtual_network.wan.name

}


resource "azurerm_subnet" "private_subnet" {
  name                 = "PrivateSubnet"
  resource_group_name  = var.resource_group_name
  address_prefixes     = [var.private_subnet_address_prefix]
  virtual_network_name = azurerm_virtual_network.wan.name

}
