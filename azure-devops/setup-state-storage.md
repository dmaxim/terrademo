# Running Terraform In an Azure DevOps pipeline

## Setup for storing Terraform state in Azure blob storage

The initial infrastructure can be provisioned using individual credentials via the Azure CLI login.  This will be transitioned to use an access key that can be stored as an environment variable.


In order to run the apply and plan you should have an active login to Azure with the appropriate default subscription.

This can be accomplished via the Azure CLI:

````
az login

az account show
````

If the desired subscription is not selected, change the subscription via:

````
az account list # This will display the available subscriptions

az account set --subscription "<Subscription name>"
````

## Initial Run
For the initial apply local Terraform state was used to allow creating the infrastructure.  After the infrastructure was created the Terraform state was migrated to the Azure Storage container.


## Get the Access Key for the storage account via the Azure CLI
````
az storage account keys list --resource-group <resource-group-name> --account-name <storage-account-name> --query '[0].value -o tsv
````

## Store the Access Key as an environment variable if needing to run locally

````
ACCOUNT_KEY=$(az storage account keys list --resource-group $RESOURCE_GROUP_NAME --account-name $STORAGE_ACCOUNT_NAME --query '[0].value' -o tsv)
export ARM_ACCESS_KEY=$ACCOUNT_KEY
````


