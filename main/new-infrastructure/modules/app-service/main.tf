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

# Demo Azure App Service
resource "azurerm_app_service" "app-service-test" {
  name                = join("", [var.namespace, var.environment])
  resource_group_name = var.resource_group_name
  location            = var.location
  app_service_plan_id = azurerm_app_service_plan.app-service-test.id

  identity {
    type = "SystemAssigned"

  }

  app_settings = {
    "WEBSITE_HEALTHCHECK_MAXPINGFAILURES" = "10",
    "WEBSITE_NODE_DEFAULT_VERSION"        = "6.9.1",
    "WEBSITE_RUN_FROM_PACKAGE"            = "1",
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

