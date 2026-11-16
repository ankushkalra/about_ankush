variable "location"  {
  type = string
  description = "Azure region"
}

variable "resource_group_name" {
  type = string
  description = "Azure resource group name"
}

variable "address_space" {
  type = list(string)
  description = "address space for vnet"
}

variable "app_snet_address_range" {
  type = string
  description = "app snet address range"
}

variable "data_snet_address_range" {
  type = string
  description = "db snet address range"
}

variable "name_suffix" {
  type = string
  description = "name suffix"
}
