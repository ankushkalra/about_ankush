resource "azurerm_network_interface" "this" {
  name = "nic-${var.name_suffix}"
  location = var.location
  resource_group_name = var.resource_group_name
  
  ip_configuration {
    name = "internal"
    subnet_id = var.app_subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.this.id
  }
}


resource "azurerm_linux_virtual_machine" "this" {
  name = "vm-${var.name_suffix}"
  resource_group_name =  var.resource_group_name
  location = var.location 
  size                            = "Standard_B2ats_v2"
  admin_username                  = "azureuser"
  disable_password_authentication = true
  network_interface_ids = [azurerm_network_interface.this.id]
  custom_data = base64encode(file("${path.module}/cloud-init.yaml"))

  admin_ssh_key {
    username = "azureuser"
    public_key = file("~/.ssh/id_ed25519-server.pub")
  }

  os_disk {
    caching = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
    disk_size_gb = 64
  }

  source_image_reference {
    publisher = "Canonical"
    offer = "ubuntu-24_04-lts"
    sku = "server"
    version = "latest"
  }
}

resource "azurerm_public_ip" "this" {
  name = "pip-${var.name_suffix}"
  location = var.location
  resource_group_name = var.resource_group_name
  allocation_method = "Static"
  sku = "Standard"
}

resource "azurerm_network_security_group" "this" {
  name = "nsg-${var.name_suffix}"
  location = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name = "allow-ssh"
    priority= 100
    direction = "Inbound"
    access = "Allow"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = "22"
    source_address_prefixes = var.ssh_allowed_cidrs
    destination_address_prefix = "*"
  }

  security_rule {
    name = "allow-web"
    priority = 110
    direction = "Inbound"
    access = "Allow"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_ranges = ["80", "443"]
    source_address_prefix = "Internet"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "this" {
  network_interface_id = azurerm_network_interface.this.id
  network_security_group_id = azurerm_network_security_group.this.id
}
