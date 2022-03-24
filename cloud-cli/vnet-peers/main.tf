
#--- cloud-cli/vnet-peers/main.tf ---

# *************** 
# Hub
# ***************


# Hub Resource Group
resource "azurerm_resource_group" "hub" {
  name     = join("-", ["rg", var.namespace, var.hub_environment])
  location = var.location

  tags = {
    environment = var.hub_environment
  }
}

# Create "Hub" vnet with subnet

module "hub_network" {
  source              = "./modules/network"
  namespace           = var.namespace
  location            = azurerm_resource_group.hub.location
  resource_group_name = azurerm_resource_group.hub.name
  environment         = var.hub_environment
  vnet_address_space  = var.hub_vnet_address_space
}


## Add firewall subnet to the hub

resource "azurerm_subnet" "firewall_subnet" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.hub.name
  virtual_network_name = module.hub_network.virtual_network_name
  address_prefixes     = [cidrsubnet(var.hub_vnet_address_space, 10, 0)]

}

resource "azurerm_subnet" "hub_gateway_subnet" {
    name = "GatewaySubnet"
    resource_group_name  = azurerm_resource_group.hub.name
    virtual_network_name = module.hub_network.virtual_network_name
    address_prefixes     = [cidrsubnet(var.hub_vnet_address_space, 8, 1)]
}

# Azure Firewall
resource "azurerm_public_ip" "firewall" {
  name                = join("-", ["pip", var.namespace, var.hub_environment])
  location            = azurerm_resource_group.hub.location
  resource_group_name = azurerm_resource_group.hub.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_firewall_policy" "hub" {
  name                = join("-", ["pol", var.namespace, var.hub_environment])
  location            = azurerm_resource_group.hub.location
  resource_group_name = azurerm_resource_group.hub.name
}

resource "azurerm_firewall" "firewall" {
  name                = join("-", ["fw", var.namespace, var.hub_environment])
  location            = azurerm_resource_group.hub.location
  resource_group_name = azurerm_resource_group.hub.name

  firewall_policy_id = azurerm_firewall_policy.hub.id
  sku_name           = "AZFW_VNet"
  sku_tier           = "Standard"

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.firewall_subnet.id
    public_ip_address_id = azurerm_public_ip.firewall.id
  }
}

# *****************
# Spoke
# *****************

# Remote resource group
resource "azurerm_resource_group" "spoke" {
  name     = join("-", ["rg", var.namespace, var.spoke_environment])
  location = var.location

  tags = {
    environment = var.spoke_environment
  }
}

# Create "Spoke vnet with subnet"

module "spoke_network" {
  source              = "./modules/network"
  namespace           = var.namespace
  location            = azurerm_resource_group.spoke.location
  resource_group_name = azurerm_resource_group.spoke.name
  environment         = var.spoke_environment
  vnet_address_space  = var.spoke_vnet_address_space
}

#***************
# On Prem
#***************

# Remote resource group
resource "azurerm_resource_group" "onprem" {
  name     = join("-", ["rg", var.namespace, var.onprem_environment])
  location = var.location

  tags = {
    environment = var.onprem_environment
  }
}

# Create "Spoke vnet with subnet"

module "onprem_network" {
  source              = "./modules/network"
  namespace           = var.namespace
  location            = azurerm_resource_group.onprem.location
  resource_group_name = azurerm_resource_group.onprem.name
  environment         = var.onprem_environment
  vnet_address_space  = var.onprem_vnet_address_space
}


# Gateway subnet
resource "azurerm_subnet" "gateway_subnet" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.onprem.name
  virtual_network_name = module.onprem_network.virtual_network_name
  address_prefixes     = [cidrsubnet(var.onprem_vnet_address_space, 8, 1)]

}


