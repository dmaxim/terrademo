
````
export SUBSCRIPTION_ID="/subscriptions/<subscriptionid>"
export SP_NAME="http://<Service Principal Name>"
````
# Create the Service Principal with contributor role on a subscription

````
az ad sp create-for-rbac -n ${SP_NAME} --role Contributor --scopes ${SUBSCRIPTION_ID}
````

NOTE: If the service principal needs to create role assignments (which is required for AKS), the principal must have the Owner role

````
az ad sp create-for-rbac -n ${SP_NAME} --role Owner --scopes ${SUBSCRIPTION_ID}
````

Or Add a role

````
az role assignment create --assignee <Service Principal Id> --scope /subscriptions/<subscriptionid> --role Owner
````
Owner
Removing a role

````
az role assignment delete --assignee <Service Principal Id> --scope /subscriptions/<subscriptionid> --role Owner
````

# Store the Client Id and Secret from the output in an encrypted secret store

# Grant the Required permissions to Azure AD Resources This is easier to do via the portal
Find the application under Azure AD -> App Registrations
Go to API permissions and add application permissions
Add the permissions
Grant Admin consent

## Required Permissions

### Application 
* Application.Read.All
* Application.ReadWrite.All

### Directory (This may be necessary)
* Directory.Read.All
* Directory.ReadWrite.All

### Domain
* Domain.Read.All

### Group
* Group.Create
* Group.Read.All
* Group.ReadWrite.All

### GroupMember
* GroupMember.ReadAll
* GroupMember.ReadWrite.All


### User
* User.Read.All
* User.ReadWrite.All