resource "azurerm_resource_group" "main-resource-group" {
  name     = "main-resource-group"
  location = var.location
}



resource "azurerm_virtual_network" "main-network" {
  name                = "virtual-network-main"
  location            = azurerm_resource_group.main-resource-group.location
  resource_group_name = azurerm_resource_group.main-resource-group.name
  address_space       = ["10.0.0.0/16"]

}

resource "azurerm_subnet" "primary-subnet" {
  name                 = "primary-subnet"
  resource_group_name  = azurerm_resource_group.main-resource-group.name
  virtual_network_name = azurerm_virtual_network.main-network.name
  address_prefixes     = ["10.0.1.0/24"]

  
}

resource "azurerm_network_interface" "main-nic" {
  name                = "main-nic"
  location            = azurerm_resource_group.main-resource-group.location
  resource_group_name = azurerm_resource_group.main-resource-group.name

  ip_configuration {
    name                          = "Internal"
    subnet_id                     = azurerm_subnet.primary-subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "vm-1" {
  name                = "vm-1"
  resource_group_name = azurerm_resource_group.main-resource-group.name
  location            = azurerm_resource_group.main-resource-group.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.main-nic.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}

resource "azurerm_network_security_group" "access-allow-all" {
  name                = "allow-all-access-sg"
  location            = azurerm_resource_group.main-resource-group.location
  resource_group_name = azurerm_resource_group.main-resource-group.name

  security_rule {
    name                       = "allow-all-access-sg"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Development"
  }
}