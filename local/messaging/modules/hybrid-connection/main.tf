# Relay Namespace
resource "azurerm_relay_namespace" "seti_ns" {
  for_each            = var.relay_namespaces
  name                = each.value.name
  location            = var.location
  resource_group_name = var.resource_group_name

  sku_name = "Standard"

  lifecycle  {
      create_before_destroy = true
  }
}


# Hybrid Connection
resource "azurerm_relay_hybrid_connection" "seti_hc" {
  for_each                      = var.relay_namespaces
  name                          = each.value.connection_name
  resource_group_name           = var.resource_group_name
  relay_namespace_name          = each.value.name
  requires_client_authorization = true
  user_metadata = jsonencode([{
    "key" : "${each.value.metadata.key}",
    "value" : "${each.value.metadata.value}"
    }
  ])
  depends_on  = [
      azurerm_relay_namespace.seti_ns
  ]
}