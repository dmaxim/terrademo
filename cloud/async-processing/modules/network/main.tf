# Create Virtual Network
resource "azurerm_virtual_network" "demo-network" {
  name                = join("-", ["vnet", var.namespace, var.environment])
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = [var.vnet_address_space]
}

# Create subnet
resource "azurerm_subnet" "demo-subnet" {
  name                 = join("-", ["snet", var.namespace, var.environment])
  resource_group_name  = var.resource_group_name
  address_prefixes     = [cidrsubnet(var.vnet_address_space, 8, 1)]
  virtual_network_name = azurerm_virtual_network.demo-network.name

  delegation {
    name = join("-", ["delegation", var.namespace, var.environment])

    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
  # Service endpoints would only be needed to allow communication from another subnet
  # service_endpoints = ["Microsoft.KeyVault", "Microsoft.Web", "Microsoft.Storage", "Microsoft.Sql"]
}
