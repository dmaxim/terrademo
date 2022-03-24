
resource "azurerm_virtual_network" "devops" {
  name                = join("-", ["vnet", var.namespace, var.environment])
  location            = azurerm_resource_group.devops.location
  resource_group_name = azurerm_resource_group.devops.name
  address_space       = ["10.1.0.0/16"]
}

resource "azurerm_subnet" "devops" {
  name                 = join("-", ["sn", var.namespace, var.environment, "01"])
  resource_group_name  = azurerm_resource_group.devops.name
  address_prefixes     = ["10.1.1.0/24"]
  virtual_network_name = azurerm_virtual_network.devops.name

    service_endpoints = [
    "Microsoft.KeyVault"
  ]
  #route_table_id = azurerm_route_table.aks-cluster-route-table.id
}

