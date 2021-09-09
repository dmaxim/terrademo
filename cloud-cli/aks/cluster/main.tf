resource "azurerm_resource_group" "cluster" {
  name     = join("-", ["rg", var.namespace, var.environment])
  location = var.location

  tags = {
    environment = var.environment
  }
}

module "cluster_network" {
  source                = "./modules/cluster-network"
  namespace             = var.namespace
  resource_group_name   = azurerm_resource_group.cluster.name
  location              = azurerm_resource_group.cluster.location
  environment           = var.environment
  vnet_address_space    = var.vnet_address_space
  subnet_address_prefix = var.subnet_address_prefix
}

module "aks_cluster" {
  source                    = "./modules/cluster"
  namespace                 = var.namespace
  resource_group_name       = azurerm_resource_group.cluster.name
  location                  = azurerm_resource_group.cluster.location
  environment               = var.environment
  cluster_subnet_id         = module.cluster_network.cluster_subnet_id
  k8s_version               = var.k8s_version
  authorized_ips            = var.authorized_ips
  default_node_pool_name    = var.default_node_pool_name
  default_node_count        = var.default_node_count
  default_node_pool_vm_size = var.default_node_pool_vm_size
  admin_user_name           = var.admin_user_name
  ssh_key                   = var.ssh_key

}