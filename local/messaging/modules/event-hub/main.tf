resource "azurerm_eventhub_namespace" "demo_ns" {
  name                = join("-", ["eh", var.namespace, var.environment])
  location            = var.location
  resource_group_name = var.resource_group_name

  sku      = "Standard"
  capacity = 1

  tags = {
    environment = var.environment
  }
}

resource "azurerm_eventhub" "demo_eh" {
  for_each            = var.event_hubs
  name                = each.value.name
  namespace_name      = azurerm_eventhub_namespace.demo_ns.name
  resource_group_name = var.resource_group_name
  partition_count     = each.value.partition_count
  message_retention   = each.value.message_retention
}

# Add Senders

resource "azurerm_eventhub_authorization_rule" "demo_eh_sender" {
  for_each            = var.event_hubs
  name                = join("-", [each.value.name, "sender"])
  namespace_name      = azurerm_eventhub_namespace.demo_ns.name
  eventhub_name       = each.value.name
  resource_group_name = var.resource_group_name

  listen = false
  send   = true
  manage = false
}

# Add Listener
resource "azurerm_eventhub_authorization_rule" "demo_eh_listener" {
  for_each            = var.event_hubs
  name                = join("-", [each.value.name, "listener"])
  namespace_name      = azurerm_eventhub_namespace.demo_ns.name
  eventhub_name       = each.value.name
  resource_group_name = var.resource_group_name

  listen = true
  send   = false
  manage = false
}

resource "azurerm_eventhub_consumer_group" "demo_eh_consumer" {
  for_each = var.event_hubs

  name                = join("-", [each.value.name, "consumer"])
  namespace_name      = azurerm_eventhub_namespace.demo_ns.name
  eventhub_name       = each.value.name
  resource_group_name = var.resource_group_name
  user_metadata       = "Event hub consumer"
}
