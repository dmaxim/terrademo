// create resource group
resource "azurerm_resource_group" "demo" {
  name     = "rg-mxinfo-move"
  location = "eastus"

  tags = {
    environment = "demo"
  }
}

resource "azurerm_resource_group" "demo_two" {
  name     = "rg-mxinfo-move-dest"
  location = "eastus"

  tags = {
    environment = "demo"
  }
}



# Create App Service Plan 

resource "azurerm_app_service_plan" "app-service-test" {
  name                = "mx-plan-one"
  resource_group_name = azurerm_resource_group.demo.name
  location            = azurerm_resource_group.demo.location


  sku {
    tier = "Standard"
    size = "S1"

  }

}


# Demo Azure App Service
resource "azurerm_app_service" "app-service-test" {
  name                = "mx-app-one"
   resource_group_name = azurerm_resource_group.demo.name
  location            = azurerm_resource_group.demo.location
  app_service_plan_id = azurerm_app_service_plan.app-service-two.id

  identity {
    type = "SystemAssigned"

  }

  app_settings = {
    "WEBSITE_HEALTHCHECK_MAXPINGFAILURES" = "10",
    "WEBSITE_NODE_DEFAULT_VERSION"        = "6.9.1",
    "WEBSITE_RUN_FROM_PACKAGE"            = "1",
    "NetworkTest:ApplicationVersion"      = "New plan version"
  
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




// Create app service two

resource "azurerm_app_service_plan" "app-service-two" {
  name                = "mx-plan-two"
  resource_group_name = azurerm_resource_group.demo.name
  location            = azurerm_resource_group.demo.location


  sku {
    tier = "Standard"
    size = "S1"

  }

}