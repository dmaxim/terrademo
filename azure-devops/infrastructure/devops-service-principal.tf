# Create a Service Principal For Dev Ops Pipelines

# These steps mimic the logic encapsulated in the "az ad sp create-for-rbac" command

data "azurerm_subscription" "dev_ops" {}

resource "azuread_application" "dev_ops" {
    display_name = var.dev_ops_principal_name

    required_resource_access {
        resource_app_id = "00000003-0000-0000-c000-000000000000"

        resource_access {
            id = "a154be20-db9c-4678-8ab7-66f6cc099a59"
            type = "Scope"
        }

        resource_access {
            id = "204e0828-b5ca-4ad8-b9f3-f32a958e7cc4"
            type = "Scope"
        }

        resource_access {
            id = "5f8c59db-677d-491f-a6b8-5f174b11ec1d"
            type = "Scope"
        }


        resource_access {
            id = "4e46008b-f24c-477d-8fff-7bb4ec7aafe0"
            type = "Scope"
        }

        resource_access {
            id = "c79f8feb-a9db-4090-85f9-90d820caa0eb"
            type = "Scope"
        }

        resource_access {
            id = "bdfbf15f-ee85-4955-8675-146e8e5296b5"
            type = "Scope"
        }

        resource_access {
            id = "2f9ee017-59c1-4f1d-9472-bd5529a7b311"
            type = "Scope"
        }
    }
}


resource "azuread_service_principal" "dev_ops" {
    application_id = azuread_application.dev_ops.application_id
}


resource "azuread_service_principal_password" "dev_ops" {
    service_principal_id = azuread_service_principal.dev_ops.id
}

resource "azurerm_role_assignment" "dev_ops" {
    scope = data.azurerm_subscription.dev_ops.id
    role_definition_name = "Contributor"
    principal_id = azuread_service_principal.dev_ops.id
}


output "display_name" {
    value = azuread_service_principal.dev_ops.display_name
}


output "client_id" {
    value = azuread_application.dev_ops.application_id
}

output "object_id" {
 value = azuread_service_principal.dev_ops.id
}

