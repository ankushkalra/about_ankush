resource "azurerm_resource_group" "main" {
  name = "rg-learning-dev"

  location = "centralindia"

  tags = {
    env = "dev"
    project = "learning"
  }
}

module "network" {
  source = "../../modules/network"
  
  location = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  address_space = ["10.0.0.0/16"]
  app_snet_address_range = "10.0.1.0/24"
  data_snet_address_range = "10.0.2.0/24"
  name_suffix = "dev"
}

module "vm" {
  source = "../../modules/vm"

  location = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  app_subnet_id = module.network.app_subnet_id
  ssh_allowed_cidrs = var.ssh_allowed_cidrs
  name_suffix = "dev"
}

output "vm_public_ip" {
  value = module.vm.public_ip
}
