
resource "azurerm_kubernetes_cluster" "aks-cluster" {
    name = join("-", ["aks", var.namespace, var.environment])
    location = var.location
    resource_group_name = var.resource_group_name
    dns_prefix = var.namespace
    kubernetes_version = var.k8s_version
    api_server_authorized_ip_ranges = [var.authorized_ips]

    linux_profile {
        admin_username = "mxinfoadmin"

        ssh_key {
            key_data = var.ssh_key
        }
    }

    default_node_pool {
        name = "mx1"
        node_count = 2
        vm_size = "Standard_D4s_v3"
        os_disk_size_gb = 50
        max_pods = 70
        type = "VirtualMachineScaleSets"
        vnet_subnet_id = var.cluster_subnet_id
    }

    identity {
        type = "SystemAssigned"
    }

    network_profile {
        network_plugin = "azure"
        load_balancer_sku = "standard"
    }

    role_based_access_control {
        enabled = true

        azure_active_directory {
            managed = true

        }
    }

    tags = {
        environment = var.environment
    }
}