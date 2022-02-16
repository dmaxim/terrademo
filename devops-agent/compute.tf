# Create a network security group
resource "azurerm_network_security_group" "devops" {
  name                = join("-", ["nsg", var.namespace, var.environment])
  location            = azurerm_resource_group.devops.location
  resource_group_name = azurerm_resource_group.devops.name

  tags = {
    environment = var.environment
  }
}


# Associate Network security group with the devops subnet
resource "azurerm_subnet_network_security_group_association" "devops" {
  subnet_id                 = azurerm_subnet.devops.id
  network_security_group_id = azurerm_network_security_group.devops.id
}

# Create random id for storage account for diagnostics data
resource "random_id" "randomId" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = azurerm_resource_group.devops.name
  }

  byte_length = 8
}


# Create storage account
resource "azurerm_storage_account" "devops" {
  name                     = "diag${random_id.randomId.hex}"
  resource_group_name      = azurerm_resource_group.devops.name
  location                 = azurerm_resource_group.devops.location
  account_replication_type = "LRS"
  account_tier             = "Standard"

  tags = {
    environment = var.environment
  }
}

## Vault VM

# Create public ip for the vm
resource "azurerm_public_ip" "devops" {
  name                = join("-", ["pip", var.namespace, var.environment, "01"])
  location            = azurerm_resource_group.devops.location
  resource_group_name = azurerm_resource_group.devops.name
  allocation_method   = "Static"

  tags = {
    environment = var.environment
  }
}

# Create NIC for Public subnet
resource "azurerm_network_interface" "devops" {
  name                = join("-", ["nic", var.namespace, var.environment, "01"])
  location            = azurerm_resource_group.devops.location
  resource_group_name = azurerm_resource_group.devops.name

  ip_configuration {
    name                          = join("-", ["nic", var.namespace, var.environment, "01"])
    subnet_id                     = azurerm_subnet.devops.id
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = azurerm_public_ip.devops.id
  }

  tags = {
    environment = var.environment
  }
}

resource "azurerm_application_security_group" "devops" {
  name                = join("-", ["asg", var.namespace, var.environment])
  location            = azurerm_resource_group.devops.location
  resource_group_name = azurerm_resource_group.devops.name

}
resource "azurerm_network_interface_application_security_group_association" "devops" {
  network_interface_id          = azurerm_network_interface.devops.id
  application_security_group_id = azurerm_application_security_group.devops.id
}


# Create VM

resource "azurerm_virtual_machine" "devops" {
  name                  = join("-", ["vm", var.namespace, var.environment, "01"])
  location              = azurerm_resource_group.devops.location
  resource_group_name   = azurerm_resource_group.devops.name
  network_interface_ids = [azurerm_network_interface.devops.id]
  vm_size               = var.vm_size

  storage_os_disk {
    name              = "disk-${var.namespace}-${var.environment}-vm-01"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }

  os_profile {
    computer_name  = join("-", ["vm", var.namespace, var.environment, "01"])
    admin_username = data.azurerm_key_vault_secret.vm_admin_user.value
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path     = data.azurerm_key_vault_secret.vm_admin_ssh_key_path.value
      key_data = data.azurerm_key_vault_secret.vm_admin_ssh_key.value
    }
  }

  boot_diagnostics {
    enabled     = "true"
    storage_uri = azurerm_storage_account.devops.primary_blob_endpoint
  }

  tags = {
    environment = var.environment
  }
}

## Add a data disk to the Virtual Machine

resource "azurerm_managed_disk" "devops" {
  name                 = join("-", ["disk", var.namespace, var.environment, "data", "01"])
  location             = azurerm_resource_group.devops.location
  resource_group_name  = azurerm_resource_group.devops.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 40
}

resource "azurerm_virtual_machine_data_disk_attachment" "devops_vm_01" {
  managed_disk_id    = azurerm_managed_disk.devops.id
  virtual_machine_id = azurerm_virtual_machine.devops.id
  lun                = "10"
  caching            = "ReadWrite"
}