#--- cloud-cli/vnet-peers/routes.tf ---#

# Create the necessary routes to route from the spoke through the hub network to the on prem network

# Create the route table in the Hub resource group
resource "azurerm_route_table" "hub_spoke" {
  name                          = join("-", ["rt", "hub", "spoke"])
  location                      = azurerm_resource_group.hub.location
  resource_group_name           = azurerm_resource_group.hub.name
  disable_bgp_route_propagation = false # Propagate the gateway routes

  #   route {
  #     name           = "UDR-Hub_Spoke"
  #     address_prefix = "10.1.0.0/16"
  #     next_hop_type  = "vnetlocal"
  #   }

  tags = {
    environment = var.hub_environment
  }
}

# Create route from hub to spoke
resource "azurerm_route" "to_spoke" {
  name                   = "to-spoke"
  resource_group_name    = azurerm_resource_group.hub.name
  route_table_name       = azurerm_route_table.hub_spoke.name
  address_prefix         = var.spoke_vnet_address_space
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = azurerm_firewall.firewall.ip_configuration[0].private_ip_address

}


# Associate the route with the Hub Gateway Subnet
resource "azurerm_subnet_route_table_association" "hub_spoke" {
  subnet_id      = azurerm_subnet.hub_gateway_subnet.id
  route_table_id = azurerm_route_table.hub_spoke.id
}

#------ Create the default route from the spoke subnet-----

# Create route table in the Spoke resource group
resource "azurerm_route_table" "spoke_hub" {
  name                          = join("-", ["rt", "spoke", "hub"])
  location                      = azurerm_resource_group.spoke.location
  resource_group_name           = azurerm_resource_group.spoke.name
  disable_bgp_route_propagation = true # Note this is disabled

  tags = {
    environment = var.spoke_environment
  }
}


# Create route from spoke to hub

resource "azurerm_route" "to_hub" {
  name                   = "to-hub"
  resource_group_name    = azurerm_resource_group.spoke.name
  route_table_name       = azurerm_route_table.spoke_hub.name
  address_prefix         = "0.0.0.0/0" # Route all external traffic to the hub vnet via the firewall
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = azurerm_firewall.firewall.ip_configuration[0].private_ip_address

}

# Associate the route with spoke subnet
resource "azurerm_subnet_route_table_association" "spoke_hub" {
  subnet_id      = module.spoke_network.private_subnet_id
  route_table_id =  azurerm_route_table.spoke_hub.id
}
