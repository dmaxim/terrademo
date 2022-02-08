
# Create public IP Address

# resource "azurerm_public_ip" "firewall" {
#   name                = join("-", ["pip", "fw", var.namespace, var.environment])
#   resource_group_name = azurerm_resource_group.wan.name
#   location            = azurerm_resource_group.wan.location

#   allocation_method = "Static"
#   sku = "Standard"
# }

# resource "azurerm_public_ip" "firewall_management" {
#   name                = join("-", ["pip", "fw", "mgmt", var.namespace, var.environment])
#   resource_group_name = azurerm_resource_group.wan.name
#   location            = azurerm_resource_group.wan.location

#   allocation_method = "Static"
#   sku = "Standard"
# }

# resource "azurerm_firewall" "mxinfo" {
#   name                = join("-", ["fw", var.namespace, var.environment])
#   resource_group_name = azurerm_resource_group.wan.name
#   location            = azurerm_resource_group.wan.location
#   sku_tier = "Standard"
  

#   ip_configuration {
#     name                 = join("-", ["ip", "fw", var.namespace, var.environment])
#     subnet_id            = module.network.firewall_subnet_id
#     public_ip_address_id = azurerm_public_ip.firewall.id
#   }

#   management_ip_configuration {
#     name                 = join("-", ["mgmt", "ip", "fw", var.namespace, var.environment])
#     subnet_id            = module.network.firewall_management_subnet_id
#     public_ip_address_id = azurerm_public_ip.firewall_management.id
#   }
# }


# Add allow all rule for testing

# resource "azurerm_firewall_network_rule_collection" "allow_all" {
#     name = "allow-all"
#     azure_firewall_name = azurerm_firewall.mxinfo.name
#     resource_group_name = azurerm_resource_group.wan.name
#     priority = 100
#     action = "Allow"

#     rule {
#         name = "defaultallow"

#         source_addresses = [ 
#             "*",
#         ]

#         destination_ports = [ 
#             "*",
#          ]

#         protocols = [
#             "TCP",
#             "UDP"
#         ] 
#     }
# }
