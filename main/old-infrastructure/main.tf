# Create Resource Group

resource "azurerm_resource_group" "demo" {
  name     = join("-", ["rg", var.namespace, var.environment])
  location = var.location

  tags = {
    environment = var.environment
  }
}
# Create App Service Plan with app services

module "app_service" {
  source                       = "./modules//app-service"
  resource_group_name          = azurerm_resource_group.demo.name
  location                     = azurerm_resource_group.demo.location
  namespace                    = var.namespace
  environment                  = var.environment
}

# Create Azure Storage

 module "storage" {
   source                = "./modules//storage"
   storage_queue_account = "moveold"
   location              = azurerm_resource_group.demo.location
   resource_group_name   = azurerm_resource_group.demo.name
   storage_queue_name    = "demoevent"
   
 }

 # App Insights
resource "azurerm_application_insights" "demo" {
  name = join("-", ["appi", var.namespace, var.environment])
  resource_group_name          = azurerm_resource_group.demo.name
  location                     = azurerm_resource_group.demo.location
  application_type = "web"
}


# Create second app service plan with App Service

module "app_service_two" {
  source                       = "./modules/app-service"
  resource_group_name          = azurerm_resource_group.demo.name
  location                     = azurerm_resource_group.demo.location
  namespace                    = join("-", [var.namespace, "02"])
  environment                  = var.environment
}
