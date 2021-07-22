# Create Virtual Network
resource "azurerm_virtual_network" "demo-network" {
  name                = join("-", ["vnet", var.namespace, var.environment])
  location            = azurerm_resource_group.demo-rg.location
  resource_group_name = azurerm_resource_group.demo-rg.name
  address_space       = [var.vnet-address-space]
}

# Create subnet
resource "azurerm_subnet" "demo-subnet" {
  name                 = join("-", ["snet", var.namespace, var.environment])
  resource_group_name  = azurerm_resource_group.demo-rg.name
  address_prefixes     = [var.subnet-address-prefix]
  virtual_network_name = azurerm_virtual_network.demo-network.name

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
resource "azurerm_virtual_network_peering" "demo-db-peer" {
  name                      = join("-", ["peer", var.namespace, var.environment])
  resource_group_name       = azurerm_resource_group.demo-rg.name
  virtual_network_name      = azurerm_virtual_network.demo-network.name
  remote_virtual_network_id = data.azurerm_virtual_network.shared-db-vnet.id
}


# Create VNET Peering to Shared Database VNET
resource "azurerm_virtual_network_peering" "demo-db-peer-from-db" {
  name                      = join("-", ["peer", var.namespace, var.environment, "001"])
  resource_group_name       = var.sql-server-resource-group
  virtual_network_name      = data.azurerm_virtual_network.shared-db-vnet.name
  remote_virtual_network_id = azurerm_virtual_network.demo-network.id
}


# Virtual Network Access enable access to sql server vnet
resource "azurerm_sql_virtual_network_rule" "demo-shared-sql" {
  name                = join("-", ["vnet-rule", var.namespace, var.environment])
  resource_group_name = var.sql-server-resource-group
  server_name         = var.sql-server-name
  subnet_id           = azurerm_subnet.demo-subnet.id
}
