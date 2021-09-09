# Grant the agent pool managed identity permision to create resources in the VNet
resource azurerm_role_assignment "virtual_machine_contributor" {
    scope = var.virtual_machine_scope
    role_definition_name = "Virtual Machine Contributor"
    principal_id = var.agent_pool_service_principal_id
}
# Grant the agent pool managed identity the managed identity operator role

resource "azurerm_role_assignment" "managed_identity_operator" {
    scope = var.resource_group_scope
    role_definition_name = "Managed Identity Operator"
    principal_id = var.agent_pool_service_principal_id
}