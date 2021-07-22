
# Create Storage Account

locals {
  resource_suffix = join("-", [var.namespace, var.environment, var.index])
  database_name   = join("_", [var.database_name, var.index])
  resource_group_name = var.resource_group_name
}

resource "azurerm_storage_account" "app-service" {
  name                     = join("", [var.application_storage_account, var.environment, var.index])
  resource_group_name      = local.resource_group_name
  location                 = var.resource_location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"
  /*
  network_rules {

    default_action             = "Allow"
    virtual_network_subnet_ids = [azurerm_subnet.veritas-subnet.id]
   # ip_rules                   = [var.authorized-ips]
  }
*/
  tags = {
    environment = var.environment
  }
}


# Create Virtual Network
resource "azurerm_virtual_network" "app-service-network" {
  name                = join("-", ["vnet", local.resource_suffix])
  location            = var.resource_location
  resource_group_name = local.resource_group_name
  address_space       = [var.vnet_address_space]
}


# Create Subnet
resource "azurerm_subnet" "app-service-subnet" {
  name                 = join("-", ["snet", local.resource_suffix])
  resource_group_name  = local.resource_group_name
  address_prefixes     = [var.subnet_address_space]
  virtual_network_name = azurerm_virtual_network.app-service-network.name

  delegation {
    name = join("-", ["delegation", local.resource_suffix])

    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
  service_endpoints = ["Microsoft.KeyVault", "Microsoft.Web", "Microsoft.Storage", "Microsoft.Sql"]
}



# Create VNET Peering to Shared Database VNET

data "azurerm_virtual_network" "shared-db-vnet" {
  name                = var.database_vnet_name
  resource_group_name = var.database_resource_group
}

resource "azurerm_virtual_network_peering" "app-service-shared-db-peer" {
  name                      = join("-", ["peer", local.resource_suffix])
  resource_group_name       = local.resource_group_name
  virtual_network_name      = azurerm_virtual_network.app-service-network.name
  remote_virtual_network_id = data.azurerm_virtual_network.shared-db-vnet.id
}


# Create VNET Peering to Shared Database VNET
resource "azurerm_virtual_network_peering" "app-service-shared-db-peer-from-db" {
  name                      = join("-", ["peer", local.resource_suffix])
  resource_group_name       = var.database_resource_group
  virtual_network_name      = data.azurerm_virtual_network.shared-db-vnet.name
  remote_virtual_network_id = azurerm_virtual_network.app-service-network.id
}


# Virtual Network Access enable access to sql server vnet
resource "azurerm_sql_virtual_network_rule" "mxinfo-shared-sql" {
  name                = join("-", ["vnet-rule", local.resource_suffix])
  resource_group_name = var.database_resource_group
  server_name         = var.sql_server_name
  subnet_id           = azurerm_subnet.app-service-subnet.id
}

# Create Database

resource "azurerm_sql_database" "app-service-db" {
  name                = local.database_name
  resource_group_name = var.database_resource_group
  server_name         = var.sql_server_name
  location            = var.resource_location
  collation           = "SQL_Latin1_General_CP1_CI_AS"

  requested_service_objective_name = "S1"

}

resource "azurerm_app_service" "app-service-instance" {
  name                = join("", [local.resource_suffix])
  resource_group_name = local.resource_group_name
  location            = var.resource_location
  app_service_plan_id = var.app_service_plan_id

  identity {
    type = "SystemAssigned"

  }

  app_settings = {
    "WEBSITE_HEALTHCHECK_MAXPINGFAILURES" = "10",
    "WEBSITE_NODE_DEFAULT_VERSION"        = "6.9.1",
    "WEBSITE_RUN_FROM_PACKAGE"            = "1"
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

# Add App Service to VNET
# This cannot be done more than once for an App Service plan
# Can have multiple app services in the same vnet, but would not be able to have the app services in different vnets
/*
resource "azurerm_app_service_virtual_network_swift_connection" "app-service-vnet-connection" {
  app_service_id = azurerm_app_service.app-service-instance.id
  subnet_id      = azurerm_subnet.app-service-subnet.id
}
*/


# Create KeyVault for Configuration and DAPI Encryption



resource "azurerm_key_vault" "app-service-test-vault" {
  # name                        = join("-", ["kv", local.resource_suffix])
  name                        = join("-", [var.namespace, var.environment, "02"])
  resource_group_name         = local.resource_group_name
  location                    = var.resource_location
  enabled_for_disk_encryption = false
  tenant_id                   = var.azure_tenant_id

  sku_name = "standard"

  access_policy {
    tenant_id = var.azure_tenant_id
    object_id = azurerm_app_service.app-service-instance.identity.0.principal_id

    secret_permissions = [
      "get",
      "list"
    ]

    key_permissions = [
      "Get",
      "List",
      "Create",
      "Import",
      "UnwrapKey",
      "WrapKey",
      "Verify",
      "Sign"
    ]

  }

  network_acls {
    bypass         = "None"
    default_action = "Deny"
    virtual_network_subnet_ids = [
      azurerm_subnet.app-service-subnet.id
    ]
  }

  tags = {
    environment = var.environment
  }
}

/*
# Create DAPI Key

resource "azurerm_key_vault_key" "veritas-dapi" {
  name = "veritas-dapi"
  key_vault_id = azurerm_key_vault.app-service-test-vault.id
  key_type = "RSA"
  key_size = 4096

  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey"
  ]
}



*/