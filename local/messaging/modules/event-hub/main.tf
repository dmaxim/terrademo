resource "azurerm_eventhub_namespace" "demo_ns" {
  name                = join("-", ["eh", var.namespace, var.environment])
  location            = var.location
  resource_group_name = var.resource_group

  sku      = "Standard"
  capacity = 1

  tags = {
    environment = var.environment
  }
}

// resource "azurerm_eventhub" "demo_eh" {
//   for_each = var.event_hubs
//   name                = each.value.name
//   namespace_name      = azurerm_eventhub_namespace.demo_ns.name
//   resource_group_name = var.resource_group

//   partition_count   = each.value.partition_count
//   message_retention = each.value.message_retention
// }


// resource "azurerm_eventhub_authorization_rule" "aks-event-hub-sender" {
//   name                = "${azurerm_eventhub.aks-event-hub.name}-sender"
//   namespace_name      = azurerm_eventhub_namespace.event-hub-ns.name
//   eventhub_name       = azurerm_eventhub.aks-event-hub.name
//   resource_group_name = azurerm_resource_group.terraform-resource-group.name

//   listen = false
//   send   = true
//   manage = false
// }

// resource "azurerm_eventhub_authorization_rule" "aks-event-hub-listener" {
//   name                = "${azurerm_eventhub.aks-event-hub.name}-listener"
//   namespace_name      = azurerm_eventhub_namespace.event-hub-ns.name
//   eventhub_name       = azurerm_eventhub.aks-event-hub.name
//   resource_group_name = azurerm_resource_group.terraform-resource-group.name

//   listen = true
//   send   = false
//   manage = false
// }

// resource "azurerm_eventhub_consumer_group" "aks-event-hub-consumer" {
//   name                = "${azurerm_eventhub.aks-event-hub.name}-consumer"
//   namespace_name      = azurerm_eventhub_namespace.event-hub-ns.name
//   eventhub_name       = azurerm_eventhub.aks-event-hub.name
//   resource_group_name = azurerm_resource_group.terraform-resource-group.name
//   user_metadata       = "aks event hub consumer"
// }
