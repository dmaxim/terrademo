
data "azurerm_subnet" "private_subnet" {
    name = "PrivateSubnet"
    virtual_network_name = "vnet-mxinfo-wan-poc"
    resource_group_name = "rg-mxinfo-wan-poc"

}

resource "azurerm_resource_group" "s2s_test" {
  name     = join("-", ["rg", var.namespace, var.environment])
  location = var.location

  tags = {
    environment = var.environment
  }
}


module "storage_queue" {
  source                = "./modules/storage-queue"
  storage_queue_account = "wanmessagingx"
  location              = azurerm_resource_group.s2s_test.location
  resource_group_name   = azurerm_resource_group.s2s_test.name
  storage_queue_name    = "demoeventx"
  private_subnet_id =   data.azurerm_subnet.private_subnet.id
  whitelisted_ip_address = var.whitelisted_ip_address
  // Type General Purpose V1 or V2?
}
