#---cloud-cli/vnet-peers/variables.tf ----


variable "namespace" {
  type    = string
  default = "mxinfo-peer"

}
variable "location" {
  type    = string
  default = "westus"
}


## Hub
variable "hub_environment" {
  type    = string
  default = "hub"
}

variable "hub_vnet_address_space" {
  type    = string
  default = "10.140.0.0/16"
}

## Spoke
variable "spoke_environment" {
  type    = string
  default = "spoke"
}

variable "spoke_vnet_address_space" {
  type    = string
  default = "10.142.0.0/16"
}

# On Prem
variable "onprem_environment" {
  type    = string
  default = "onprem"
}

variable "onprem_vnet_address_space" {
  type    = string
  default = "10.144.0.0/16"
}



