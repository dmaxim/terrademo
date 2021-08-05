
resource "azurerm_resource_group" "funcs" {
  name     = join("-", ["rg", var.namespace, var.environment])
  location = var.location

}