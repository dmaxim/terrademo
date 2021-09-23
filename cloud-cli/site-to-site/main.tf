# Resource Group

resource "azurerm_resource_group" "wan" {
  name     = join("-", ["rg", var.namespace, var.environment])
  location = var.location

  tags = {
    environment = var.environment
  }
}


# Create VNet with subnets
module "network" {
  source                        = "./modules/network"
  resource_group_name           = azurerm_resource_group.wan.name
  namespace                     = var.namespace
  environment                   = var.environment
  location                      = var.location
  vnet_address_space            = var.vnet_address_space
  gateway_subnet_address_prefix = var.gateway_subnet_address_prefix
  private_subnet_address_prefix = var.private_subnet_address_prefix
  public_subnet_address_prefix  = var.public_subnet_address_prefix
}


resource "azurerm_public_ip" "wan" {
  name                = join("-", ["pip", var.namespace, var.environment])
  resource_group_name = azurerm_resource_group.wan.name
  location            = azurerm_resource_group.wan.location

  allocation_method = "Dynamic"
}
# Create Virtual Network Gateway

resource "azurerm_virtual_network_gateway" "wan" {
  name                = join("-", ["vng", var.namespace, var.environment])
  location            = azurerm_resource_group.wan.location
  resource_group_name = azurerm_resource_group.wan.name

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = false
  sku           = "VpnGw2"
  generation    = "Generation2"

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.wan.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = module.network.gateway_subnet_id
  }
}

#Create local network gateway - this should be deleted
# resource "azurerm_local_network_gateway" "home" {
#   name                = join("-", ["lng", var.namespace, var.environment])
#   location            = azurerm_resource_group.wan.location
#   resource_group_name = azurerm_resource_group.wan.name
#   gateway_address     = var.local_vpn_address
#   address_space       = [var.local_address_space]
# }

# Create the meraki gateway
resource "azurerm_local_network_gateway" "meraki" {
  name                = "mxinfo-meraki"
  location            = azurerm_resource_group.wan.location
  resource_group_name = azurerm_resource_group.wan.name
  gateway_address     = var.local_vpn_address
  address_space       = [var.local_address_space]
}

# Create the connection
# Commented out to prevent changing
# resource "azurerm_virtual_network_gateway_connection" "home" {
#   name                = join("-", ["con", var.namespace, var.environment])
#   location            = azurerm_resource_group.wan.location
#   resource_group_name = azurerm_resource_group.wan.name

#   type                       = "IPSec"
#   virtual_network_gateway_id = azurerm_virtual_network_gateway.wan.id
#   local_network_gateway_id   = azurerm_local_network_gateway.meraki.id

#   shared_key = var.vpn_shared_key
# }

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
  name                = join("-", ["nic", "jumpbox", var.namespace, var.environment])
  resource_group_name = azurerm_resource_group.wan.name
  location            = azurerm_resource_group.wan.location

  ip_configuration {
    name                          = "private"
    subnet_id                     = module.network.private_subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "jumpbox" {
  name                = "mxjump"
  resource_group_name = azurerm_resource_group.wan.name
  location            = azurerm_resource_group.wan.location
  size                = "Standard_B1ls"
  admin_username      = "dmax"

  network_interface_ids = [
    azurerm_network_interface.jumpbox.id,
  ]

  admin_ssh_key {
    username   = "dmax"
    public_key = var.public_ssh_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

}

# resource "azurerm_network_interface" "jumpbox_02" {
#   name                = join("-", ["nic", "jumpbox02", var.namespace, var.environment])
#   resource_group_name = azurerm_resource_group.wan.name
#   location            = azurerm_resource_group.wan.location

#   ip_configuration {
#     name                          = "private"
#     subnet_id                     = module.network.public_subnet_id
#     private_ip_address_allocation = "Dynamic"
#   }
# }


# resource "azurerm_linux_virtual_machine" "jumpbox_02" {
#   name                = "mxjump-02"
#   resource_group_name = azurerm_resource_group.wan.name
#   location            = azurerm_resource_group.wan.location
#   size                = "Standard_B1ls"
#   admin_username      = "dmax"

#   network_interface_ids = [
#     azurerm_network_interface.jumpbox_02.id,
#   ]

#   admin_ssh_key {
#     username   = "dmax"
#     public_key = var.public_ssh_key
#   }

#   os_disk {
#     caching              = "ReadWrite"
#     storage_account_type = "Standard_LRS"
#   }

#   source_image_reference {
#     publisher = "Canonical"
#     offer     = "0001-com-ubuntu-server-focal"
#     sku       = "20_04-lts"
#     version   = "latest"
#   }

# }


# Add A Bastion Host

module "bastion_host" {
  source                        = "./modules/bastion"
  resource_group_name           = azurerm_resource_group.wan.name
  location                      = azurerm_resource_group.wan.location
  namespace                     = var.namespace
  environment                   = var.environment
  bastion_subnet_address_prefix = var.bastion_subnet_address_prefix
  virtual_network_name          = module.network.virtual_network_name
  inbound_ip_address            = var.whitelisted_ip_address
}


# Create an App Service in a public subnet

module "app_service" {
  source                       = "./modules/app-service"
  resource_group_name          = azurerm_resource_group.wan.name
  location                     = azurerm_resource_group.wan.location
  namespace                    = var.namespace
  environment                  = var.environment
  app_service_subnet_id        = module.network.public_subnet_id
  entity_context               = var.entity_context
  azure_storage_connection     = var.azure_storage_connection
  azure_service_bus_connection = var.azure_service_bus_connection
}

# Create an Azure SQL Instance in the private subnet

module "mssql" {
  source                     = "./modules/mssql"
  namespace                  = var.namespace
  environment                = var.environment
  resource_group_name        = azurerm_resource_group.wan.name
  location                   = azurerm_resource_group.wan.location
  audit_storage_account      = var.audit_storage_account
  audit_storage_account_tier = var.audit_storage_account_tier
  replication_type           = var.replication_type
  sql_server_version         = "12.0"
  sql_admin                  = var.sql_admin
  sql_admin_password         = var.sql_admin_password
  private_subnet_id          = module.network.private_subnet_id
  whitelisted_ip_address     = var.whitelisted_ip_address
  databases                  = local.sql_databases
}


# Create Azure Service Bus in another resource group


resource "azurerm_resource_group" "asb" {
  name     = join("-", ["rg", "asb", var.namespace, var.environment])
  location = var.location

  tags = {
    environment = var.environment
  }
}



// ASB

module "asb" {
  source              = "./modules/asb"
  namespace           = var.namespace
  location            = azurerm_resource_group.asb.location
  resource_group_name = azurerm_resource_group.asb.name
  environment         = var.environment
  asb_sku             = var.asb_sku
  topics              = local.asb_topics
}


module "asb_subscription" {
  source                 = "./modules/asb-subscription"
  subscriptions          = local.topic_subscriptions
  azure_service_bus_name = module.asb.azure_service_bus_name
  resource_group_name    = azurerm_resource_group.asb.name
}


// Storage queue

# module "storage_queue" {
#   source                = "./modules/storage-queue"
#   storage_queue_account = "wanmessaging"
#   location              = azurerm_resource_group.asb.location
#   resource_group_name   = azurerm_resource_group.asb.name
#   storage_queue_name    = "demoevent"
#   private_subnet_id = module.network.private_subnet_id
#   // Type General Purpose V1 or V2?
# }


 module "storage_queue" {
   source                = "./modules/storage-queue"
   storage_queue_account = "wanmessaging2"
   location              = azurerm_resource_group.asb.location
   resource_group_name   = azurerm_resource_group.asb.name
   storage_queue_name    = "demoevent"
   private_subnet_id = module.network.private_subnet_id
   whitelisted_ip_address = var.whitelisted_ip_address
   // Type General Purpose V1 or V2?
 }