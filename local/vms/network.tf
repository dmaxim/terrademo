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

# Create Network Security Group
resource "azurerm_network_security_group" "demo_shared_sg" {
  name                = join("-", ["nsg", var.namespace, var.environment])
  resource_group_name = azurerm_resource_group.shared_rg.name
  location            = azurerm_resource_group.shared_rg.location


  security_rule {
    name                       = "SQL-HC"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = 80
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}



