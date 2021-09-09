# Resource Group

resource "azurerm_resource_group" "wan" {
  name = join("-", ["rg", var.namespace, var.environment])
  location = var.location

  tags = {
    environment = var.environment
  }
}


# Create VNet with subnets
module "network" {
  source = "./modules/network"
  resource_group_name = azurerm_resource_group.wan.name
  namespace = var.namespace
  environment = var.environment
  location = var.location
  vnet_address_space =  var.vnet_address_space
  gateway_subnet_address_prefix = var.gateway_subnet_address_prefix
  private_subnet_address_prefix = var.private_subnet_address_prefix
}


resource "azurerm_public_ip" "wan" {
  name = join("-", ["pip",var.namespace, var.environment])
  resource_group_name = azurerm_resource_group.wan.name
  location = azurerm_resource_group.wan.location

  allocation_method = "Dynamic"
}
# Create Virtual Network Gateway

resource "azurerm_virtual_network_gateway" "wan" {
  name = join("-", ["vng", var.namespace, var.environment])
  location =  azurerm_resource_group.wan.location
  resource_group_name = azurerm_resource_group.wan.name

  type = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp = false
  sku = "VpnGw2"
  generation = "Generation2"

  ip_configuration {
    name = "vnetGatewayConfig"
    public_ip_address_id = azurerm_public_ip.wan.id
    private_ip_address_allocation = "Dynamic"
    subnet_id = module.network.gateway_subnet_id
  }
}


# Create local network gateway