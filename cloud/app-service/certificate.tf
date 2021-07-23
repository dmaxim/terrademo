
resource "azurerm_app_service_certificate" "app-service-test" {
  name                = join("", [var.namespace, var.environment])
  resource_group_name = azurerm_resource_group.demo-rg.name
  location            = azurerm_resource_group.demo-rg.location
  key_vault_secret_id = var.certificate_secret_id
}