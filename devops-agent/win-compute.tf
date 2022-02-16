

## Windows Build Agent VM

# Create public ip for the vm
resource "azurerm_public_ip" "devops_win" {
  name                = join("-", ["pip", var.namespace, var.environment, "win-01"])
  location            = azurerm_resource_group.devops.location
  resource_group_name = azurerm_resource_group.devops.name
  allocation_method   = "Static"

  tags = {
    environment = var.environment
  }
}

# Create NIC for Public subnet
resource "azurerm_network_interface" "devops_win" {
  name                = join("-", ["nic", var.namespace, var.environment, "win-01"])
  location            = azurerm_resource_group.devops.location
  resource_group_name = azurerm_resource_group.devops.name

  ip_configuration {
    name                          = join("-", ["nic", var.namespace, var.environment, "win-01"])
    subnet_id                     = azurerm_subnet.devops.id
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = azurerm_public_ip.devops_win.id
  }

  tags = {
    environment = var.environment
  }
}


resource "azurerm_network_interface_application_security_group_association" "devops_win" {
  network_interface_id          = azurerm_network_interface.devops_win.id
  application_security_group_id = azurerm_application_security_group.devops.id
}


# Create VM

resource "azurerm_windows_virtual_machine" "devops_win" {
  name                = join("-", ["vm", var.namespace, "win"])
  location            = azurerm_resource_group.devops.location
  resource_group_name = azurerm_resource_group.devops.name
  size                = "Standard_D2s_v3"
  admin_username      = data.azurerm_key_vault_secret.vm_admin_user.value
  admin_password      = data.azurerm_key_vault_secret.windows_admin_password.value

  network_interface_ids = [
    azurerm_network_interface.devops_win.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-datacenter-with-containers-smalldisk-g2"
    version   = "latest"
  }

  tags = {
    environment = var.environment
  }
}

## Add a data disk to the Virtual Machine

# resource "azurerm_managed_disk" "devops_win" {
#   name                 = join("-", ["disk", var.namespace, var.environment, "win-data", "01"])
#   location             = azurerm_resource_group.devops.location
#   resource_group_name  = azurerm_resource_group.devops.name
#   storage_account_type = "Standard_LRS"
#   create_option        = "Empty"
#   disk_size_gb         = 40
# }

# resource "azurerm_virtual_machine_data_disk_attachment" "devops_win_01" {
#   managed_disk_id    = azurerm_managed_disk.devops_win.id
#   virtual_machine_id = azurerm_virtual_machine.devops_win.id
#   lun                = "10"
#   caching            = "ReadWrite"
# }