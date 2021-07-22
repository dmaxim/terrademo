
resource "azurerm_resource_group" "waf-rg" {
  name     = join("-", ["rg", var.namespace])
  location = var.location

  tags = {
    environment = var.environment
  }
}