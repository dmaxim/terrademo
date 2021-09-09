resource "azurerm_user_assigned_identity" "demo_worker" {
    resource_group_name = var.resource_group_name
    location = var.location

    name = join("-", ["demo-worker", var.environment])
}