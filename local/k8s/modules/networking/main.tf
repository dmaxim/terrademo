resource "azurerm_virtual_network" "aks_cluster_network" {
    name = join("-", ["vnet", var.namespace, var.environment])
    location = var.location
    resource_group_name = var.resource_group_name
    address_space = [var.vnet_address_space]
}

resource "azurerm_subnet" "aks_cluster_subnet" {
    name = join("-", ["snet", var.namespace, var.environment])
    resource_group_name = var.resource_group_name
    address_prefixes = [var.subnet_address_prefix]
    virtual_network_name = azurerm_virtual_network.aks_cluster_network.name
    
}
