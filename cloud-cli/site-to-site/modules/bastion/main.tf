
# Add a bastion host to a vnet

resource "azurerm_subnet" "bastion" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  address_prefixes     = [var.bastion_subnet_address_prefix]
}

resource "azurerm_public_ip" "bastion" {
  name                = join("-", ["pip", "bastion", var.namespace, var.environment])
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "bastion" {
  name                = join("-", ["vm", "bastion", var.namespace, var.environment])
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                 = "bastion-ip-config"
    subnet_id            = azurerm_subnet.bastion.id
    public_ip_address_id = azurerm_public_ip.bastion.id
  }
}


# Create a network security group on the subnet and allow SSH from My IP
resource "azurerm_network_security_group" "bastion" {
  name                = join("-", ["nsg", "bastion", var.namespace, var.environment])
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = {
    environment = var.environment
  }
}

# resource "azurerm_network_security_rule" "bastion-ssh" {
#   name                        = "SSH"
#   resource_group_name         = var.resource_group_name
#   network_security_group_name = azurerm_network_security_group.bastion.name
#   priority                    = 300
#   direction                   = "Inbound"
#   access                      = "Allow"
#   protocol                    = "TCP"
#   source_port_range           = "*"
#   destination_port_range      = "22"
#   source_address_prefix       = var.inbound_ip_address
#   destination_address_prefix  = "*"


# }

resource "azurerm_network_security_rule" "bastion_https_inbound" {
  name                        = "AllowHttpsInBound"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.bastion.name
  priority                    = 120
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "TCP"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "Internet"
  destination_address_prefix  = "*"


}


resource "azurerm_network_security_rule" "bastion_gateway_manager_inbound" {
  name                        = "AllowGatwayManagerInbound"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.bastion.name
  priority                    = 130
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "TCP"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "GatewayManager"
  destination_address_prefix  = "*"


}


resource "azurerm_network_security_rule" "bastion_loadbalancer_inbound" {
  name                        = "AllowAzureLoadBalancerInbound"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.bastion.name
  priority                    = 140
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "TCP"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "AzureLoadBalancer"
  destination_address_prefix  = "*"


}

resource "azurerm_network_security_rule" "bastion_host_inbound" {
  name                        = "AllowBastionHostCommunication"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.bastion.name
  priority                    = 150
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_ranges     = [8080, 5071]
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "VirtualNetwork"
}

# Egress Rules

resource "azurerm_network_security_rule" "bastion_ssh_rdp_outbound" {
  name                        = "AllowSshRdpOutbound"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.bastion.name
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_ranges     = [22, 3389]
  source_address_prefix       = "*"
  destination_address_prefix  = "VirtualNetwork"
}


resource "azurerm_network_security_rule" "bastion_azure_cloud_outbound" {
  name                        = "AllowAzureCloudOutbound"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.bastion.name
  priority                    = 110
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "TCP"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = "AzureCloud"
}

resource "azurerm_network_security_rule" "bastion_communcation_outbound" {
  name                        = "AllowBastionCommunication"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.bastion.name
  priority                    = 120
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_ranges     = [8080, 5701]
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "VirtualNetwork"
}


resource "azurerm_network_security_rule" "bastion_session_outbound" {
  name                        = "AllowGetSessionInformation"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.bastion.name
  priority                    = 130
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "Internet"
}



resource "azurerm_subnet_network_security_group_association" "bastion" {
  subnet_id                 = azurerm_subnet.bastion.id
  network_security_group_id = azurerm_network_security_group.bastion.id
}

