# Storage Account Id
resource "random_id" "randomId" {
  keepers = {
    resource_group = azurerm_resource_group.shared_rg.name

  }

  byte_length = 8
}


# Storage Account
resource "azurerm_storage_account" "sql_vm_storage" {
  name                     = "diag${random_id.randomId.hex}"
  resource_group_name      = azurerm_resource_group.shared_rg.name
  location                 = azurerm_resource_group.shared_rg.location
  account_replication_type = "LRS"
  account_tier             = "Standard"


}

# Public IP
resource "azurerm_public_ip" "sql_vm_public_ip" {
  name                = join("-", ["pip", var.namespace, var.environment])
  resource_group_name = azurerm_resource_group.shared_rg.name
  location            = azurerm_resource_group.shared_rg.location
  allocation_method   = "Dynamic"

}

# NIC
resource "azurerm_network_interface" "sql_vm_nic" {
  name                = join("-", ["nic", var.namespace, var.environment])
  resource_group_name = azurerm_resource_group.shared_rg.name
  location            = azurerm_resource_group.shared_rg.location

  ip_configuration {
    name                          = join("-", ["nic", var.namespace, var.environment])
    subnet_id                     = azurerm_subnet.demo_shared_subnet.id
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = azurerm_public_ip.sql_vm_public_ip.id
  }

}

resource "azurerm_network_interface_security_group_association" "sql_nsg" {
  network_interface_id      = azurerm_network_interface.sql_vm_nic.id
  network_security_group_id = azurerm_network_security_group.demo_shared_sg.id
}


# Virtual Machine Definition

resource "azurerm_windows_virtual_machine" "sql_vm" {
  name                  = "mxinfosql01"
  resource_group_name   = azurerm_resource_group.shared_rg.name
  location              = azurerm_resource_group.shared_rg.location
  network_interface_ids = [azurerm_network_interface.sql_vm_nic.id]
  size               = "Standard_DS1_V2"
  admin_username       = var.sql-admin
  admin_password        = var.sql-admin-password

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "microsoftsqlserver"
    offer     = "sql2019-ws2019"
    sku       = "enterprise"
    version   = "latest"
  }

}