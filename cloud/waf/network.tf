# Create VNET
# Create Virtual Network
resource "azurerm_virtual_network" "waf-network" {
  name                = join("-", ["vnet", var.namespace, var.environment])
  location            = azurerm_resource_group.waf-rg.location
  resource_group_name = azurerm_resource_group.waf-rg.name
  address_space       = ["10.7.0.0/16"]
}

# Create Front end Sub Net
resource "azurerm_subnet" "frontend" {
  name                 = join("-", ["snet", var.namespace, "frontend", var.environment])
  resource_group_name  = azurerm_resource_group.waf-rg.name
  virtual_network_name = azurerm_virtual_network.waf-network.name
  address_prefixes     = ["10.7.0.0/24"]
  // service_endpoints    = ["Microsoft.Web"]
}


resource "azurerm_public_ip" "gateway-ip" {
  name                = join("-", ["ip", var.namespace, var.environment])
  resource_group_name = azurerm_resource_group.waf-rg.name
  location            = azurerm_resource_group.waf-rg.location
  allocation_method   = "Static"
  sku                 = "Standard"
}


/*
data "azurerm_virtual_network" "app-service-vnet" {
  name                = var.app-service-vnet-name
  resource_group_name = var.app-service-resource-group
}



# Create VNET Peering to App Service SubNet
resource "azurerm_virtual_network_peering" "peer-to-app-service" {
  name                      = join("-", ["peer", var.namespace, var.environment])
  resource_group_name       = azurerm_resource_group.waf-rg.name
  virtual_network_name      = azurerm_virtual_network.waf-network.name
  remote_virtual_network_id = data.azurerm_virtual_network.app-service-vnet.id
}


# Create VNET Peering from App Service Subnet
resource "azurerm_virtual_network_peering" "peer-from-app-service" {
  name                      = join("-", ["peer", var.namespace, var.environment, "001"])
  resource_group_name       = var.app-service-resource-group
  virtual_network_name      = data.azurerm_virtual_network.app-service-vnet.name
  remote_virtual_network_id = azurerm_virtual_network.waf-network.id
}


*/