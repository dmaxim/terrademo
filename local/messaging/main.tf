
# Create Resource Group

# Create Event Hub Namespace and associated event hubs
module "eventhub" {
    source = "./modules/event-hub"
    environment = var.environment
    location = var.location
    resource_group_name = join("-", ["rg", var.namespace, var.environment])
    event_hubs = local.event_hubs

}

