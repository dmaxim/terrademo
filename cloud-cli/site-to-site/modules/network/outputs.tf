
output "gateway_subnet_id" {
  value = azurerm_subnet.gateway_subnet.id
}

output "private_subnet_id" {
  value = azurerm_subnet.private_subnet.id
}

output "virtual_network_name" {
  value = azurerm_virtual_network.wan.name
}