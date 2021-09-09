# Get the resource group id for the cluster nodes
````
export CLUSTER_RESOURCE_GROUP=rg-mxtest-demo
export CLUSTER_NAME=aks-mxtest-demo
export NODE_GROUP=$(az aks show -g ${CLUSTER_RESOURCE_GROUP} -n ${CLUSTER_NAME} --query nodeResourceGroup -o tsv)
export NODES_RESOURCE_ID=$(az group show -n $NODE_GROUP -o tsv --query "id")
echo $NODES_RESOURCE_ID
````
## NODES_RESOURCE_ID is the value for the virtual_machine_scope


# Get the Service Principal ID

````
export IDENTITY_NAME=aks-mxtest-demo-agentpool
export IDENTITY_PRINCIPAL_ID=$(az identity show -n ${IDENTITY_NAME} -g ${NODE_GROUP} --query principalId -o tsv)
echo $IDENTITY_PRINCIPAL_ID
````

## IDENTITY_PRINCIPAL_ID is the value for the agent_pool_service_principal_id variable

````
az identity show -n ${IDENTITY_NAME} -g ${NODE_GROUP} --query id -o tsv
````

# Get The Resource Group Scope

````
export RESOURCE_GROUP_ID=$(az group show -n ${CLUSTER_RESOURCE_GROUP} --query id -o tsv)
echo $RESOURCE_GROUP_ID
````