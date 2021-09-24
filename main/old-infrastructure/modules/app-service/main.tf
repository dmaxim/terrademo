# Create App Service Plan 

resource "azurerm_app_service_plan" "app-service-test" {
  name                = join("-", ["plan", var.namespace, var.environment])
  resource_group_name = var.resource_group_name
  location            = var.location


  sku {
    tier = "Standard"
    size = "S1"

  }

  tags = {
    environment = var.environment
  }
}

