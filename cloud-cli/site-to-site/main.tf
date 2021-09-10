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
resource "azurerm_local_network_gateway" "home" {
  name = join("-", ["lng", var.namespace, var.environment])
  location =  azurerm_resource_group.wan.location
  resource_group_name = azurerm_resource_group.wan.name
  gateway_address = var.local_vpn_address
  address_space = [var.local_address_space]
}

# Create the connection

resource "azurerm_virtual_network_gateway_connection" "home" {
  name = join("-", ["con", var.namespace, var.environment])
  location =  azurerm_resource_group.wan.location
  resource_group_name = azurerm_resource_group.wan.name

  type = "IPSec"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.wan.id
  local_network_gateway_id = azurerm_local_network_gateway.home.id

  shared_key = var.vpn_shared_key
}

# # Create VM On Private Subnet

# Storage Account Id
resource "random_id" "randomId" {
  keepers = {
    resource_group = azurerm_resource_group.wan.name

  }

  byte_length = 8
}


# Storage Account
# resource "azurerm_storage_account" "jump_box_storage" {
#   name                     = "diag${random_id.randomId.hex}"
#   resource_group_name      = azurerm_resource_group.wan.name
#   location                 = azurerm_resource_group.wan.location
#   account_replication_type = "LRS"
#   account_tier             = "Standard"

# }


resource "azurerm_network_interface" "jumpbox" {
  name = join("-", ["nic", "jumpbox", var.namespace, var.environment])
  resource_group_name      = azurerm_resource_group.wan.name
  location                 = azurerm_resource_group.wan.location

  ip_configuration {
    name = "private"
    subnet_id = module.network.private_subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "jumpbox" {
  name = "mxjump"
  resource_group_name      = azurerm_resource_group.wan.name
  location                 = azurerm_resource_group.wan.location
  size = "Standard_B1ls"
  admin_username = "dmax"

  network_interface_ids = [
    azurerm_network_interface.jumpbox.id,
  ]

  admin_ssh_key  {
    username = "dmax"
    public_key = var.public_ssh_key
  }

  os_disk {
    caching = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer = "UbuntuServer"
    sku = "18.04-LTS"
    version = "latest"
  }
  
}