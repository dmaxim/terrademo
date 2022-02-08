

# # Create route table and routes
# resource "azurerm_route_table" "local" {
#   name = join("-", ["rt", var.namespace, var.environment])
#   location                     = azurerm_resource_group.wan.location
#   resource_group_name          = azurerm_resource_group.wan.name
#   //disable_bgp_route_propagation = false

#   tags = {
#     environment = var.environment
#   }

# }

# # # Create zero route
# resource "azurerm_route" "zero" {
#   name = "default-override"
#   resource_group_name          = azurerm_resource_group.wan.name
#   route_table_name = azurerm_route_table.local.name
#   address_prefix = "0.0.0.0/0"
#   next_hop_type = "VirtualAppliance"
#   next_hop_in_ip_address = var.firewall_ip_address
# }

# # # Create route to on prem
# resource "azurerm_route" "on_prem" {
#   name = "route_to_on_Prem"
#   resource_group_name          = azurerm_resource_group.wan.name
#   route_table_name = azurerm_route_table.local.name
#   address_prefix = "192.168.128.0/24"
#   next_hop_type = "VirtualAppliance"
#   next_hop_in_ip_address = var.firewall_ip_address
# }

# # # Create Route table subnet associations
# resource "azurerm_subnet_route_table_association" "app_subnet" {
#   subnet_id = module.network.private_subnet_id
#   route_table_id = azurerm_route_table.local.id
# }
