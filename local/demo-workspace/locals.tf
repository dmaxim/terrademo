locals {
  variables = {
    azure-subscription-id = {
      value       = var.azure-subscription-id
      description = "Azure subscription id"
      sensitive   = false
    }
    azure-service-principal-id = {
      value       = var.azure-service-principal-id
      description = "Azure service principal id"
      sensitive   = false
    }
    azure-service-principal-secret = {
      value       = var.azure-service-principal-secret
      description = "Azure service principal secret"
      sensitive   = true
    }
    azure-tenant-id = {
      value       = var.azure-tenant-id
      description = "Azure Tenant Id"
      sensitive   = false
    }
    namespace = {
      value       = var.namespace
      description = "Namespace for all resources"
      sensitive   = false
    }
    location = {
      value       = var.location
      description = "Azure Region for resources"
      sensitive   = false
    }
    environment = {
      value       = var.environment
      description = "Environment tag and suffixe"
      sensitive   = false
    }
    database-name = {
      value       = var.database-name
      description = "Database to create for the application"
      sensitive   = false
    }
    sql-server-name = {
      value       = var.sql-server-name
      description = "SQL Server instance name"
      sensitive   = false
    }
    sql-server-resource-group = {
      value       = var.sql-server-resource-group
      description = "Azure resource group for the sql server instance"
      sensitive   = false
    }
    database-vnet-name = {
      value       = var.database-vnet-name
      description = "Database vnet"
      sensitive   = false
    }
    database-resource-group = {
      value       = var.database-resource-group
      description = "Resource group for the database"
      sensitive   = false
    }
    application-storage-account = {
      value       = var.application-storage-account
      description = "Azure Storage for use by the app service"
      sensitive   = false
    }
    authorized-ips = {
      value       = var.authorized-ips
      description = "IPs with permission to access resources"
      sensitive   = false
    }
    vnet-address-space = {
      value       = var.vnet-address-space
      description = "Vnet Address Space"
      sensitive   = false
    }
    subnet-address-prefix = {
      value       = var.subnet-address-prefix
      description = "Address prefix for the subnet"
      sensitive   = false
    }
    certificate_secret_id = {
      value       = var.certificate_secret_id
      description = "Key Vault Id for the certificate"
      sensitive   = true
    }
    azure_app_service_id = {
      value = var.azure_app_service_id
      description = "Microsoft Azure App Service App Id for access to the key vault"
      sensitive = false
    }
  }
}
