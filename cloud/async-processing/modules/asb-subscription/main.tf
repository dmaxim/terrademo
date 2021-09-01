
resource "azurerm_servicebus_queue" "demo" {
  for_each            = var.subscriptions
  name                = each.value.queue_name
  resource_group_name = var.resource_group_name
  namespace_name      = var.azure_service_bus_name
  enable_partitioning = false

}


resource "azurerm_servicebus_subscription" "demo" {
  for_each            = var.subscriptions
  name                = each.value.queue_name
  namespace_name      = var.azure_service_bus_name
  resource_group_name = var.resource_group_name
  topic_name          = each.value.topic_name
  max_delivery_count  = 1
  forward_to          = each.value.queue_name
  depends_on = [
    azurerm_servicebus_queue.demo
  ]
}