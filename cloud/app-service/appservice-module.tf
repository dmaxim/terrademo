
module "app_service" {
  source = "../modules/app-service/"

  resource_group_name         = azurerm_resource_group.veritas-rg.name
  resource_location           = azurerm_resource_group.veritas-rg.location
  environment                 = var.environment
  application_storage_account = var.application-storage-account
  index                       = "002"
  namespace                   = var.namespace
  vnet_address_space          = "10.8.0.0/16"
  subnet_address_space        = "10.8.1.0/24"
  database_vnet_name          = var.database-vnet-name
  database_resource_group     = var.sql-server-resource-group
  sql_server_name             = var.sql-server-name
  database_name               = var.database-name
  app_service_plan_id         = azurerm_app_service_plan.app-service-test.id
  azure_tenant_id             = var.azure-tenant-id
}