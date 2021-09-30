# Create Resource Group

resource "azurerm_resource_group" "demo" {
  name     = join("-", ["rg", var.namespace, var.environment])
  location = var.location

  tags = {
    environment = var.environment
  }
}
# Create App Service Plan with app services

// module "app_service" {
//   source                       = "./modules/app-service"
//   resource_group_name          = azurerm_resource_group.demo.name
//   location                     = azurerm_resource_group.demo.location
//   namespace                    = var.namespace
//   environment                  = var.environment
// }

// # App Insights
// resource "azurerm_application_insights" "demo" {
//   name = join("-", ["appi", var.namespace, var.environment])
//   resource_group_name          = azurerm_resource_group.demo.name
//   location                     = azurerm_resource_group.demo.location
//   application_type = "web"
// }

