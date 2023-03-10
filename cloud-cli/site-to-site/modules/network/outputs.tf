
output "gateway_subnet_id" {
  value = azurerm_subnet.gateway_subnet.id
}

output "private_subnet_id" {
  value = azurerm_subnet.private_subnet.id
}

output "public_subnet_id" {
  value = azurerm_subnet.public_subnet.id
}

output "virtual_network_name" {
  value = azurerm_virtual_network.wan.name
}

# output "firewall_subnet_id" {
#   value = azurerm_subnet.firewall.id
# }

# output "firewall_management_subnet_id" {
#   value = azurerm_subnet.firewall_management.id
# }