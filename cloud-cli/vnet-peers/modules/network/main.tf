
resource "azurerm_virtual_network" "test_peer" {
  name                = join("-", ["vnet", var.namespace, var.environment])
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = [var.vnet_address_space]

  tags = {
    environment = var.environment
  }
}


resource "azurerm_subnet" "private_subnet" {
  name                 = join("-", ["snet", var.namespace, var.environment, "01"])
  resource_group_name  = azurerm_virtual_network.test_peer.resource_group_name
  virtual_network_name = azurerm_virtual_network.test_peer.name
  address_prefixes     = [cidrsubnet(var.vnet_address_space, 8, 2)]

  # delegation {
  #   name = join("-", ["delegation", var.namespace, var.environment])

  #   service_delegation {
  #     name    = "Microsoft.Web/serverFarms"
  #     actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
  #   }
  #}

  # service_endpoints = [
  #   "Microsoft.KeyVault",
  #   "Microsoft.Sql"
  # ]
}
