
locals {
  backend_address_pool_name      = join("-", ["beap", azurerm_virtual_network.waf-network.name])
  frontend_port_name             = join("-", ["feport", azurerm_virtual_network.waf-network.name])
  frontend_ip_configuration_name = join("-", ["feip", azurerm_virtual_network.waf-network.name])
  http_setting_name              = join("-", ["be-htst", azurerm_virtual_network.waf-network.name])
  listener_name                  = join("-", ["httplstn", azurerm_virtual_network.waf-network.name])
  request_routing_rule_name      = join("-", ["rqrt", azurerm_virtual_network.waf-network.name])
  redirect_configuration_name    = join("-", ["rdcfg", azurerm_virtual_network.waf-network.name])
}



resource "azurerm_application_gateway" "mxinfo-gateway" {
  name                = join("-", ["waf", var.namespace, var.environment])
  resource_group_name = azurerm_resource_group.waf-rg.name
  location            = azurerm_resource_group.waf-rg.location
  enable_http2        = true

  sku {
    name = "WAF_V2"
    tier = "WAF_V2"
    //capacity = 2

  }

  autoscale_configuration {
    min_capacity = 2
    max_capacity = 3

  }

  waf_configuration {
    enabled          = true
    firewall_mode    = "Detection"
    rule_set_type    = "OWASP"
    rule_set_version = "3.1"

  }
  gateway_ip_configuration {
    name      = join("-", ["gip", var.namespace, var.environment])
    subnet_id = azurerm_subnet.frontend.id
  }

  frontend_port {
    name = local.frontend_port_name
    port = 80
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.gateway-ip.id
  }

  backend_address_pool {
    name = local.backend_address_pool_name
    fqdns = [
      "mxinfo-veritasdev.azurewebsites.net" # This value should be retrieved from a data source
    ]
  }

  backend_http_settings {
    name                                = local.http_setting_name
    cookie_based_affinity               = "Disabled"
    path                                = ""
    port                                = 80
    protocol                            = "Http"
    request_timeout                     = 60
    pick_host_name_from_backend_address = true
  }

  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
  }


}

