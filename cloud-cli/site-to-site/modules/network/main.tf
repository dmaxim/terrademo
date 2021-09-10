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

# Create Network Security Group
resource "azurerm_network_security_group" "private_subnet" {
  name                = join("-", ["nsg", "private", var.namespace, var.environment])
  resource_group_name = var.resource_group_name
  location            = var.location


  # security_rule {
  #   name                       = "SQL-HC"
  #   priority                   = 300
  #   direction                  = "Inbound"
  #   access                     = "Allow"
  #   protocol                   = "Tcp"
  #   source_port_range          = "*"
  #   destination_port_range     = 80
  #   source_address_prefix      = "*"
  #   destination_address_prefix = "*"
  # }
}
