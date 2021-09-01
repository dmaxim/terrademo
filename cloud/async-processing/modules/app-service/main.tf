# locals {
#   app_services = { for plan in var.app_service_plans} 
# }

# Create App Service Plan 

resource "azurerm_app_service_plan" "demo" {
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

# # Add An App Service for the webjobs
# resource "azurerm_app_service" "demo" {
#   name                = join("", [var.namespace, var.environment])
#   resource_group_name = var.resource_group_name
#   location            = azurerm_resource_group.demo-rg.location
#   app_service_plan_id = azurerm_app_service_plan.app-service-test.id

#   identity {
#     type = "SystemAssigned"

#   }

#   app_settings = {
#     "WEBSITE_HEALTHCHECK_MAXPINGFAILURES" = "10",
#     "WEBSITE_NODE_DEFAULT_VERSION"        = "6.9.1",
#     "WEBSITE_RUN_FROM_PACKAGE"            = "1"
#   }

#   site_config {
#     health_check_path = "/home"
#     default_documents = [
#       "Default.htm",
#       "Default.html",
#       "index.htm",
#       "index.html",
#       "iisstart.htm"
#     ]
#     php_version               = "5.6"
#     use_32_bit_worker_process = true
#   }
# }

# Add App Service to VNET
# resource "azurerm_app_service_virtual_network_swift_connection" "app-service-vnet-connection" {
#   app_service_id = azurerm_app_service.app-service-test.id
#   subnet_id      = azurerm_subnet.demo-subnet.id
# }