# Resource Group

resource "azurerm_resource_group" "peer" {
  name     = join("-", ["rg", var.namespace, var.environment])
  location = var.location

  tags = {
    environment = var.environment
  }
}

module "network" {
  source              = "./modules/network"
  namespace           = var.namespace
  location            = azurerm_resource_group.peer.location
  resource_group_name = azurerm_resource_group.peer.name
  environment         = var.environment
  vnet_address_space  = "10.130.0.0/16"
}

module "app_service" {
  source                       = "./modules/app-service"
  namespace                    = var.namespace
  environment                  = var.environment
  location                     = azurerm_resource_group.peer.location
  resource_group_name          = azurerm_resource_group.peer.name
  app_service_subnet_id        = module.network.private_subnet_id
  entity_context               = var.entity_context
  azure_service_bus_connection = var.azure_service_bus_connection
  azure_storage_connection     = var.azure_storage_connection
  application_version          = var.application_version
}


# Create route table and routes
# resource "azurerm_route_table" "peer" {
#   name = join("-", ["rt", var.namespace, var.environment])
#   location                     = azurerm_resource_group.peer.location
#   resource_group_name          = azurerm_resource_group.peer.name
#   //disable_bgp_route_propagation = false

#   tags = {
#     environment = var.environment
#   }

# }

# Create zero route
# resource "azurerm_route" "zero" {
#   name = "default-override"
#   resource_group_name          = azurerm_resource_group.peer.name
#   route_table_name = azurerm_route_table.peer.name
#   address_prefix = "0.0.0.0/0"
#   next_hop_type = "VirtualAppliance"
#   next_hop_in_ip_address = var.firewall_ip_address
# }

# # Create route to on prem
# resource "azurerm_route" "on_Prem" {
#   name = "route_to_on_Prem"
#   resource_group_name          = azurerm_resource_group.peer.name
#   route_table_name = azurerm_route_table.peer.name
#   address_prefix = "192.168.128.0/24"
#   next_hop_type = "VirtualAppliance"
#   next_hop_in_ip_address = var.firewall_ip_address
# }

# # Create Route table subnet associations
# resource "azurerm_subnet_route_table_association" "app_subnet" {
#   subnet_id = module.network.private_subnet_id
#   route_table_id = azurerm_route_table.peer.id
# }
