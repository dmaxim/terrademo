
resource "azurerm_servicebus_namespace" "demo" {
  name                = join("-", ["asb", var.namespace, var.environment])
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.asb_sku

  tags = {
    environment = var.environment
  }
}

resource "azurerm_servicebus_topic" "demo" {
  for_each            = var.topics
  name                = join("-", [each.value.name, "topic"])
  resource_group_name = var.resource_group_name
  namespace_name      = azurerm_servicebus_namespace.demo.name

  enable_partitioning = false
}

resource "azurerm_servicebus_queue" "demo" {
  for_each            = var.topics
  name                = each.value.name
  resource_group_name = var.resource_group_name
  namespace_name      = azurerm_servicebus_namespace.demo.name
  enable_partitioning = false
}

resource "azurerm_servicebus_subscription" "demo" {
  for_each            = var.topics
  name                = each.value.name
  namespace_name      = azurerm_servicebus_namespace.demo.name
  resource_group_name = var.resource_group_name
  topic_name          = join("-", [each.value.name, "topic"])
  max_delivery_count  = 1
  forward_to          = each.value.name
}

# Add Network Rule to only allow access via the private subnet - Only available in premium

# resource "azurerm_servicebus_namespace_network_rule_set" "demo" {
#   namespace_name = azurerm_servicebus_namespace.demo.name
#   resource_group_name = var.resource_group_name
#   default_action = "Deny"

#   network_rules {
#     subnet_id = var.private_subnet_id
#     ignore_missing_vnet_service_endpoint = false
#   }
# }

# resource "azurerm_servicebus_topic_authorization_rule" "demo_listener" {
#     for_each = var.topics
#     name = join("-", [each.value.name, "listener"])
#     namespace_name = azurerm_servicebus_namespace.demo.name
#     topic_name = each.value.name
#     resource_group_name = var.resource_group_name
#     listen = true
#     send = false
#     manage = false
# }

# resource "azurerm_servicebus_topic_authorization_rule" "demo_sender" {
#     for_each = var.topics
#     name = join("-", [each.value.name, "sender"])
#     namespace_name = azurerm_servicebus_namespace.demo.name
#     topic_name = each.value.name
#     resource_group_name = var.resource_group_name
#     listen = false
#     send = true
#     manage = false
# }