
data "azuread_service_principal" "terraform" {
  application_id = var.azure-service-principal-id
}
# Create KeyVault for Configuration and DAPI Encryption



resource "azurerm_key_vault" "app-service-test-vault" {
  name                        = join("-", ["kv", var.namespace, var.environment])
  resource_group_name         = azurerm_resource_group.demo-rg.name
  location                    = var.location
  enabled_for_disk_encryption = false
  tenant_id                   = var.azure-tenant-id

  sku_name = "standard"

  access_policy {
    tenant_id = var.azure-tenant-id
    object_id = azurerm_app_service.app-service-test.identity.0.principal_id

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

    certificate_permissions  = [
      "Get"
    ]

  }

  access_policy {
    tenant_id = var.azure-tenant-id
    object_id = data.azuread_service_principal.terraform.object_id

    certificate_permissions = [
      "Get",
      "List"
    ]
   }

    access_policy {
     tenant_id = var.azure-tenant-id
     object_id = "abfa0a7c-a6b6-4736-8310-5855508787cd"

     certificate_permissions = [
       "Get",
       "List"
     ]
  }

  # network_acls {
  #   bypass         = "None"
  #   default_action = "Deny"
  #   virtual_network_subnet_ids = [
  #     azurerm_subnet.demo-subnet.id
  #   ]
  # }

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