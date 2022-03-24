
output "private_subnet_id" {
  value = azurerm_subnet.private_subnet.id
}

output "virtual_network_name" {
  value = azurerm_virtual_network.test_peer.name
}