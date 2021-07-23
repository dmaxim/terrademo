
resource "azurerm_resource_group" "k8s_rg" {
  name     = join("-", ["rg", var.namespace])
  location = var.location

  tags = {
    environment = var.environment
  }
}

# Create Network
module "networking" {
  source                = "./modules/networking"
  location              = var.location
  resource_group_name   = azurerm_resource_group.k8s_rg.name
  environment           = var.environment
  vnet_address_space    = var.vnet_address_space
  subnet_address_prefix = var.subnet_address_prefix
  namespace             = var.namespace
}


# Create Cluster

module "cluster" {
  source              = "./modules/cluster"
  location            = var.location
  resource_group_name = azurerm_resource_group.k8s_rg.name
  environment         = var.environment
  namespace           = var.namespace
  cluster_subnet_id   = module.networking.subnet_id
  k8s_version         = var.k8s_version
  authorized_ips      = var.authorized_ips
  ssh_key             = var.ssh_key
}