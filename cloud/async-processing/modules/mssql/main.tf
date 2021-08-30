# Create Azure Storage for Audit storage

resource "azurerm_storage_account" "demo_sql_server_storage" {
  name                     = join("", [var.audit_storage_account, var.environment])
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = var.audit_storage_account_tier
  account_replication_type = var.replication_type
}




# Create Azure SQL Server

resource "azurerm_sql_server" "demo_shared" {
  name                         = join("-", ["sql", var.namespace, var.environment])
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = var.sql_server_version
  administrator_login          = var.sql_admin
  administrator_login_password = var.sql_admin_password
  connection_policy            = "Default" # Options Default, Proxy and Redirect (for K8s access via Istio Egress may need to change this)

  tags = {
    environment = var.environment
  }
}


# Create the audit policy
resource "azurerm_mssql_server_extended_auditing_policy" "demo_sql_audit_policy" {
  server_id                               = azurerm_sql_server.demo_shared.id
  retention_in_days                       = 6
  storage_account_access_key              = azurerm_storage_account.demo_sql_server_storage.primary_access_key
  storage_account_access_key_is_secondary = false
  storage_endpoint                        = azurerm_storage_account.demo_sql_server_storage.primary_blob_endpoint
}


# Create the associated databases

resource "azurerm_sql_database" "demo-db-2" {
  for_each            = var.databases
  name                = each.value.name
  resource_group_name = var.resource_group_name
  server_name         = azurerm_sql_server.demo_shared.name
  location            = var.location
  collation           = "SQL_Latin1_General_CP1_CI_AS"

  requested_service_objective_name = each.value.service_objective
}