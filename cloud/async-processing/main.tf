// Resource Group

resource "azurerm_resource_group" "messaging" {
  name     = var.resource_group_name
  location = var.location

}


// Create VNET with Private Subnet
module "network" {
  source              = "./modules/network"
  namespace           = var.namespace
  environment         = var.environment
  location            = var.location
  resource_group_name = var.resource_group_name
  vnet_address_space  = var.vnet_address_space
}

// ASB

module "asb" {
  source              = "./modules/asb"
  namespace           = var.namespace
  location            = azurerm_resource_group.messaging.location
  resource_group_name = azurerm_resource_group.messaging.name
  environment         = var.environment
  asb_sku             = var.asb_sku
  topics              = local.asb_topics
}

// Create additional Topic Subscriptions (NOTE the topics were created by Rebus)
# module "asb_subscription" {
#   source                   = "./modules/asb-subscription"
#   resource_group_name      = azurerm_resource_group.messaging.name
#   azure_service_bus_name = join("-", ["asb", var.namespace, var.environment])
#   subscriptions            = local.topic_subscriptions
# }

# // Create SQL Server and demo database
# module "sql_server" {
#   source                     = "./modules/mssql"
#   namespace                  = var.namespace
#   location                   = azurerm_resource_group.messaging.location
#   resource_group_name        = azurerm_resource_group.messaging.name
#   environment                = var.environment
#   audit_storage_account      = var.audit_storage_account
#   audit_storage_account_tier = var.audit_storage_account_tier
#   replication_type           = var.replication_type
#   sql_server_version         = var.sql_server_version
#   sql_admin                  = var.sql_admin
#   sql_admin_password         = var.sql_admin_password
#   databases                  = local.sql_databases
#   private_subnet_id          = module.network.private_subnet_id
#   sql_job_agent_user_name    = var.sql_job_agent_user_name
#   sql_job_agent_password     = var.sql_job_agent_password
#   whitelist_ip_address      = var.whitelist_ip_address
# }


# // Create the App Service Plans for the WebJobs

# module "app_service_plan" {
#   source                = "./modules/app-service"
#   location              = azurerm_resource_group.messaging.location
#   resource_group_name   = azurerm_resource_group.messaging.name
#   environment           = var.environment
#   app_service_plan_name = local.app_service_plans.webjobs.name
#   tier                  = local.app_service_plans.webjobs.tier
#   size                  = local.app_service_plans.webjobs.size
#   app_services          = local.app_service_plans.webjobs.app_services
# }


# // Create the Function App for Event Processing

# module "function_app" {
#   source                           = "./modules/func"
#   location                         = azurerm_resource_group.messaging.location
#   resource_group_name              = azurerm_resource_group.messaging.name
#   environment                      = var.environment
#   namespace                        = var.namespace
#   storage_account_name             = var.function_app_storage_account
#   storage_account_tier             = "Standard"
#   storage_account_replication_type = "LRS"
#   storage_account_kind             = "StorageV2"
#   function_apps                    = local.function_apps

# }