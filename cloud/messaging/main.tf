
# Create Resource Group

resource "azurerm_resource_group" "demo_rg" {
  name     = join("-", ["rg", var.namespace, var.environment])
  location = var.location

  tags = {
    environment = var.environment
  }
}

# Create ASB Namespace

# Create a topic?