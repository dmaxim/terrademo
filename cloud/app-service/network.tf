# Create Virtual Network
resource "azurerm_virtual_network" "veritas-network" {
  name                = join("-", ["vnet", var.namespace, var.environment])
  location            = azurerm_resource_group.veritas-rg.location
  resource_group_name = azurerm_resource_group.veritas-rg.name
  address_space       = ["10.5.0.0/16"]
}

# Create subnet
resource "azurerm_subnet" "veritas-subnet" {
  name                 = join("-", ["snet", var.namespace, var.environment])
  resource_group_name  = azurerm_resource_group.veritas-rg.name
  address_prefixes     = ["10.5.1.0/24"]
  virtual_network_name = azurerm_virtual_network.veritas-network.name

  delegation {
    name = join("-", ["delegation", var.namespace, var.environment])

    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
  service_endpoints = ["Microsoft.KeyVault", "Microsoft.Web", "Microsoft.Storage", "Microsoft.Sql"]
}

data "azurerm_virtual_network" "shared-db-vnet" {
  name                = var.database-vnet-name
  resource_group_name = var.sql-server-resource-group
}

# Create VNET Peering to Shared Database VNET
resource "azurerm_virtual_network_peering" "shared-db-peer" {
  name                      = join("-", ["peer", var.namespace, var.environment])
  resource_group_name       = azurerm_resource_group.veritas-rg.name
  virtual_network_name      = azurerm_virtual_network.veritas-network.name
  remote_virtual_network_id = data.azurerm_virtual_network.shared-db-vnet.id
}


# Create VNET Peering to Shared Database VNET
resource "azurerm_virtual_network_peering" "shared-db-peer-from-db" {
  name                      = join("-", ["peer", var.namespace, var.environment, "001"])
  resource_group_name       = var.sql-server-resource-group
  virtual_network_name      = data.azurerm_virtual_network.shared-db-vnet.name
  remote_virtual_network_id = azurerm_virtual_network.veritas-network.id
}


# Virtual Network Access enable access to sql server vnet
resource "azurerm_sql_virtual_network_rule" "mxinfo-shared-sql" {
  name                = join("-", ["vnet-rule", var.namespace, var.environment])
  resource_group_name = var.sql-server-resource-group
  server_name         = var.sql-server-name
  subnet_id           = azurerm_subnet.veritas-subnet.id
}
