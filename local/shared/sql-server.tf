# Create Azure Storage for Audit storage

resource "azurerm_storage_account" "demo_sql_server_storage" {
  name                     = join("", [var.storage-account-prefix, var.environment])
  resource_group_name      = azurerm_resource_group.shared_rg.name
  location                 = azurerm_resource_group.shared_rg.location
  account_tier             = var.sql-server-storage-account-tier
  account_replication_type = var.sql-server-storage-replication-type
}




# Create Azure SQL Server

resource "azurerm_sql_server" "demo_shared" {
  name                         = join("-", ["sql", var.namespace, var.environment])
  resource_group_name          = azurerm_resource_group.shared_rg.name
  location                     = azurerm_resource_group.shared_rg.location
  version                      = var.sql-server-version
  administrator_login          = var.sql-admin
  administrator_login_password = var.sql-admin-password
  connection_policy            = "Default" # Options Default, Proxy and Redirect (for K8s access via Istio Egress may need to change this)

  tags = {
    environment = var.environment
  }
}



resource "azurerm_mssql_server_extended_auditing_policy" "demo_sql_audit_policy" {
  server_id                               = azurerm_sql_server.demo_shared.id
  retention_in_days                       = 6
  storage_account_access_key              = azurerm_storage_account.demo_sql_server_storage.primary_access_key
  storage_account_access_key_is_secondary = false
  storage_endpoint                        = azurerm_storage_account.demo_sql_server_storage.primary_blob_endpoint
}


# Virtual Network Access
resource "azurerm_sql_virtual_network_rule" "demo_shared_sql" {
  name                = join("-", ["vnet-rule", var.namespace, var.environment])
  resource_group_name = azurerm_resource_group.shared_rg.name
  server_name         = azurerm_sql_server.demo_shared.name
  subnet_id           = azurerm_subnet.demo_shared_subnet.id
}

# Firewall Rule for External Access

resource "azurerm_sql_firewall_rule" "demo_shared_sql_firewall" {
  name                = join("-", ["fwr", var.namespace, "dmaxim"])
  resource_group_name = azurerm_resource_group.shared_rg.name
  server_name         = azurerm_sql_server.demo_shared.name
  start_ip_address    = var.authorized-ip
  end_ip_address      = var.authorized-ip
}
