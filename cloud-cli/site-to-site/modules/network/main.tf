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


# # Create subnet for the Azure Firewall
# resource "azurerm_subnet" "firewall" {
#   name = "AzureFirewallSubnet"

#   resource_group_name  = azurerm_virtual_network.wan.resource_group_name
#   virtual_network_name = azurerm_virtual_network.wan.name
#   address_prefixes     = [cidrsubnet(var.vnet_address_space, 10, 0)]

# }

# # Create subnet for Azure Firewall managment 
# resource "azurerm_subnet" "firewall_management" {
#   name = "AzureFirewallManagementSubnet"
#   resource_group_name  = azurerm_virtual_network.wan.resource_group_name
#   virtual_network_name = azurerm_virtual_network.wan.name
#   address_prefixes     = [cidrsubnet(var.vnet_address_space, 10, 3)]
# }

resource "azurerm_subnet" "private_subnet" {
  name                 = "PrivateSubnet"
  resource_group_name  = var.resource_group_name
  address_prefixes     = [var.private_subnet_address_prefix]
  virtual_network_name = azurerm_virtual_network.wan.name

  enforce_private_link_endpoint_network_policies = true

  delegation {
    name = join("-", ["delegation", var.namespace, var.environment])

    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }  
  
  service_endpoints = ["Microsoft.Sql", "Microsoft.Storage"] # Service endpoints are required for network integration
}

resource "azurerm_subnet" "public_subnet" {
  name                 = "PublicSubnet"
  resource_group_name  = var.resource_group_name
  address_prefixes     = [var.public_subnet_address_prefix]
  virtual_network_name = azurerm_virtual_network.wan.name


  delegation {
    name = join("-", ["delegation", var.namespace, var.environment])

    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }

  service_endpoints = ["Microsoft.Storage"] # Service endpoints are required for network integration
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


resource "azurerm_subnet_network_security_group_association" "private_subnet" {
  subnet_id                 = azurerm_subnet.private_subnet.id
  network_security_group_id = azurerm_network_security_group.private_subnet.id
}


