
#--- cloud-cli/vnet-peers/firewall-rules.tf

resource "azurerm_firewall_policy_rule_collection_group" "allow_onprem" {
    name = join("-", ["fp", var.namespace, var.onprem_environment])
    firewall_policy_id = azurerm_firewall_policy.hub.id
    priority = 100

    network_rule_collection {
        name = join("-", ["nrc", var.namespace, var.onprem_environment])
        priority = 100
        action = "Allow"

        rule {
            name = "RCNet1"
            protocols = ["TCP", "UDP"]
            source_addresses = [cidrsubnet(var.onprem_vnet_address_space, 8, 2)]
            destination_addresses = [cidrsubnet(var.spoke_vnet_address_space, 8, 2)]
            destination_ports = ["53", "80"]
        }
        rule {
            name = "AllowRDP"
            protocols = ["TCP"]
            source_addresses = [cidrsubnet(var.onprem_vnet_address_space, 8, 2)]
            destination_addresses = [cidrsubnet(var.spoke_vnet_address_space, 8, 2)]
            destination_ports = ["3389"]
        }
    }
    
}