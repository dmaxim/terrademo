
resource "azurerm_resource_group" "demo-rg" {
  name     = join("-", ["rg", var.namespace])
  location = var.location

  tags = {
    environment = var.environment
  }
}