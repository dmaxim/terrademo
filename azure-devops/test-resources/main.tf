resource "azurerm_resource_group" "dev_ops" {
  name     = join("-", ["rg", var.namespace])
  location = var.location

  tags = {
    environment = var.ENVIRONMENT
  }
}
