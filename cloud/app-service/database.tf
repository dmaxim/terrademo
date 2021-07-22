# Create Veritas Database

resource "azurerm_sql_database" "demo-db" {
  name                = var.database-name
  resource_group_name = var.sql-server-resource-group
  server_name         = var.sql-server-name
  location            = var.location
  collation           = "SQL_Latin1_General_CP1_CI_AS"

  requested_service_objective_name = "S1"
  /*
  extended_auditing_policy {
    storage_endpoint                        = azurerm_storage_account.example.primary_blob_endpoint
    storage_account_access_key              = azurerm_storage_account.example.primary_access_key
    storage_account_access_key_is_secondary = true
    retention_in_days                       = 6
*/
}


