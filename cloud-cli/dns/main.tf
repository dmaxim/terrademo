#--- cloud-cli/dns/main.tf ---#

# Create Resource Group
resource "azurerm_resource_group" "dns" {
  name     = join("-", ["rg", var.namespace])
  location = var.location
}


resource "azurerm_dns_zone" "mxinfo" {
  name                = "mxcmg.com"
  resource_group_name = azurerm_resource_group.dns.name
}


## Add nameservers from the zone to the zone file in the DNS provider

output "name_servers" {
    value = azurerm_dns_zone.mxinfo.name_servers
}

