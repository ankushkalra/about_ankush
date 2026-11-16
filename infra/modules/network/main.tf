resource "azurerm_virtual_network" "this" {
  name = "vnet-${var.name_suffix}"
  location = var.location
  resource_group_name = var.resource_group_name
  address_space = var.address_space 
}

resource "azurerm_subnet" "app" {
  name = "snet-app"
  resource_group_name = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes = [var.app_snet_address_range]
}

resource "azurerm_subnet" "data" {
  name = "snet-data"
  resource_group_name = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes = [var.data_snet_address_range]
}

resource "azurerm_network_security_group" "data" {
  name = "nsg-data"
  location = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name = "allow-app-to-data"
    priority = 100
    direction = "Inbound"
    access = "Allow"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = "5432"
    source_address_prefix = azurerm_subnet.app.address_prefixes[0]
    destination_address_prefix = "*"
  }

  security_rule {
    name = "deny-all-other-inbound"
    priority = 4000
    direction = "Inbound"
    access = "Deny"
    protocol = "*"
    source_port_range = "*"
    destination_port_range = "*"
    source_address_prefix = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "data" {
  subnet_id = azurerm_subnet.data.id
  network_security_group_id = azurerm_network_security_group.data.id
}
