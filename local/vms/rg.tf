
resource "azurerm_resource_group" "shared_rg" {
  name     = join("-", ["rg", var.namespace])
  location = var.location

  tags = {
    environment = var.environment
  }
}