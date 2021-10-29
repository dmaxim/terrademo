# Service Principal Creation

A service principal is created via the devops-service-principal.tf configuration.  The password for the is generated and not output. To regenerate and access the password for the service principal run the following:

````
 az ad sp credential reset --name <Service Principal Name>
````

NOTE:  This credential should be cycled regularly.


## Granting Permissions to Manage Azure AD Resources


 https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/guides/service_principal_configuration

The required_resource_access map can be used to grant these permissions.  Provided the identifiers do not change.  The desired values can be determined by granting the permissions in the portal and running terraform apply to see which permissions would be removed.

 ### Graph API Permissions to grant:
* Application.Read.All
* Application.ReadWrite.All
* Domain.Read.All
* Group.Read.All
* Group.ReadWrite.All
* User.Read.All
* User.ReadWrite.All


## Grant Permissions On Key Vault
This is done in the main.tf