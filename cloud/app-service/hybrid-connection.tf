# Relay Namespace
resource "azurerm_relay_namespace" "seti_ns" {
  name                = join("-", ["hr", var.namespace, var.environment])
  location            = azurerm_resource_group.demo-rg.location
  resource_group_name = azurerm_resource_group.demo-rg.name

  sku_name = "Standard"

  lifecycle {
    create_before_destroy = true
  }
}


# Hybrid Connection
resource "azurerm_relay_hybrid_connection" "seti_hc" {
  name                          = join("_", ["hc", var.namespace, var.environment])
  resource_group_name           = azurerm_resource_group.demo-rg.name
  relay_namespace_name          = azurerm_relay_namespace.seti_ns.name
  requires_client_authorization = true
  # user_metadata = jsonencode([{
  #   "key" : "${each.value.metadata.key}",
  #   "value" : "${each.value.metadata.value}"
  #   }
  # ])
  depends_on = [
    azurerm_relay_namespace.seti_ns
  ]
}

resource "azurerm_app_service_hybrid_connection" "seti_hc" {
  app_service_name    = azurerm_app_service.app-service-test.name
  resource_group_name = azurerm_resource_group.demo-rg.name
  relay_id            = azurerm_relay_hybrid_connection.seti_hc.id
  hostname            = var.relay_host_name
  port                = 1433
  //send_key_name = "examplesharedaccesskey"
}