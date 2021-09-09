output "managed_identity_client_id" {
    value = azurerm_user_assigned_identity.demo_worker.client_id
}

output "managed_identity_id" {
    value = azurerm_user_assigned_identity.demo_worker.id
}

output "managed_identity_principal_id" {
    value = azurerm_user_assigned_identity.demo_worker.principal_id
}