
# Create App Service Plan 

resource "azurerm_app_service_plan" "demo" {
  name                = var.app_service_plan_name
  resource_group_name = var.resource_group_name
  location            = var.location


  sku {
    tier = var.tier
    size = var.size

  }

  tags = {
    environment = var.environment
  }
}

# Add An App Service for the webjobs
resource "azurerm_app_service" "demo" {
  for_each            = var.app_services
  name                = join("-", [each.value.name, var.environment])
  resource_group_name = var.resource_group_name
  location            = var.location
  app_service_plan_id = azurerm_app_service_plan.demo.id

  identity {
    type = "SystemAssigned"

  }

  app_settings = {
    "WEBSITE_HEALTHCHECK_MAXPINGFAILURES" = "10",
    "WEBSITE_NODE_DEFAULT_VERSION"        = "6.9.1",
    "WEBSITE_RUN_FROM_PACKAGE"            = "1"
  }

  site_config {
    health_check_path = "/home"
    default_documents = [
      "Default.htm",
      "Default.html",
      "index.htm",
      "index.html",
      "iisstart.htm"
    ]
    php_version               = "5.6"
    use_32_bit_worker_process = true
  }
}

# Add App Service to VNET
# resource "azurerm_app_service_virtual_network_swift_connection" "app-service-vnet-connection" {
#   app_service_id = azurerm_app_service.app-service-test.id
#   subnet_id      = azurerm_subnet.demo-subnet.id
# }