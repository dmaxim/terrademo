#--- cloud-cli/vnet-peers/peering.tf ----#

# Peer the Hub and Spoke virtual networks

# Peer Hub to Spoke
resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  name                      = "peer-hub-to-spoke"
  resource_group_name       = azurerm_resource_group.hub.name
  virtual_network_name      = module.hub_network.virtual_network_name
  remote_virtual_network_id = module.spoke_network.virtual_network_id
}


# Peer Spoke to Hub

resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  name                      = "peer-spoke-to-hub"
  resource_group_name       = azurerm_resource_group.spoke.name
  virtual_network_name      = module.spoke_network.virtual_network_name
  remote_virtual_network_id = module.hub_network.virtual_network_id
}
