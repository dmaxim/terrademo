
# Create Resource Group

resource "azurerm_resource_group" "demo_rg" {
  name     = join("-", ["rg", var.namespace, var.environment])
  location = var.location

  tags = {
    environment = var.environment
  }
}

# # Create Event Hub Namespace and associated event hubs
# module "eventhub" {
#     source = "./modules/event-hub"
#     environment = var.environment
#     location = var.location
#     namespace = var.namespace
#     resource_group_name = azurerm_resource_group.demo_rg.name
#     event_hubs = local.event_hubs

# }

# Create Hybrid Connection

module "hybrid-connection" {
  source              = "./modules/hybrid-connection"
  location            = var.location
  resource_group_name = azurerm_resource_group.demo_rg.name
  relay_namespaces    = local.relay_namespaces
}

