

# Hub Gateway


resource "azurerm_public_ip" "hub_gateway" {
  name                = join("-", ["pip", "gw", var.namespace, var.hub_environment])
  location            = azurerm_resource_group.hub.location
  resource_group_name = azurerm_resource_group.hub.name

  allocation_method = "Dynamic"
}

resource "azurerm_virtual_network_gateway" "hub" {
  name                = join("-", ["vng", var.namespace, var.hub_environment])
  location            = azurerm_resource_group.hub.location
  resource_group_name = azurerm_resource_group.hub.name

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = false
  sku           = "VpnGw2"
  generation    = "Generation2"

  ip_configuration {
    name                          = "hubGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.hub_gateway.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.hub_gateway_subnet.id
  }
}


# On Prem Gateway (This simulates Express Route / Site to Site VPN appliance on prem)

resource "azurerm_public_ip" "onprem_gateway" {
  name                = join("-", ["pip", "gw", var.namespace, var.onprem_environment])
  location            = azurerm_resource_group.onprem.location
  resource_group_name = azurerm_resource_group.onprem.name

  allocation_method = "Dynamic"
}

resource "azurerm_virtual_network_gateway" "onprem" {
  name                = join("-", ["vng", var.namespace, var.onprem_environment])
  location            = azurerm_resource_group.onprem.location
  resource_group_name = azurerm_resource_group.onprem.name

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = false
  sku           = "VpnGw2"
  generation    = "Generation2"

  ip_configuration {
    name                          = "onpremGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.onprem_gateway.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.gateway_subnet.id
  }
}
