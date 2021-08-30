# Create App Service Plan 

resource "azurerm_app_service_plan" "plan" {
  for_each            = var.app_service_plans
  name                = each.value.name
  resource_group_name = var.resource_group_name
  location            = var.location


  sku {
    tier = each.value.tier
    size = each.value.size

  }

  tags = {
    environment = var.environment
  }
}
