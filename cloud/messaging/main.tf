
# Create Resource Group

resource "azurerm_resource_group" "demo_rg" {
  name     = join("-", ["rg", var.namespace, var.environment])
  location = var.location

  tags = {
    environment = var.environment
  }
}

# Create ASB Namespace

module "asb" {
  source              = "./modules/asb"
  namespace           = var.namespace
  location            = azurerm_resource_group.demo_rg.location
  resource_group_name = azurerm_resource_group.demo_rg.name
  environment         = var.environment
  asb_sku             = var.asb_sku
  topics              = local.asb_topics
}
