data "azurerm_resource_group" "main_resource_group" {
  name = "x-xxxxxxxx-playground-sandbox"
}

resource "azurerm_virtual_network" "main_network" {
  name                = "virtual-network-main"
  resource_group_name = data.azurerm_resource_group.main_resource_group.name
  location            = data.azurerm_resource_group.main_resource_group.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "primary_subnet" {
  name                 = "primary-subnet"
  resource_group_name  = data.azurerm_resource_group.main_resource_group.name
  virtual_network_name = azurerm_virtual_network.main_network.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "vm_1" {
  name                = "vm-1"
  resource_group_name = data.azurerm_resource_group.main_resource_group.name
  location            = data.azurerm_resource_group.main_resource_group.location
  allocation_method   = "Static"

  tags = {
    environment = "Development"
  }
}

resource "azurerm_network_interface" "main_nic" {
  name                = "main-nic"
  resource_group_name = data.azurerm_resource_group.main_resource_group.name
  location            = data.azurerm_resource_group.main_resource_group.location

  ip_configuration {
    name                          = "Internal"
    subnet_id                     = azurerm_subnet.primary_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm_1.id
  }
}

resource "azurerm_linux_virtual_machine" "vm_1" {
  name                = "vm-1"
  resource_group_name = data.azurerm_resource_group.main_resource_group.name
  location            = data.azurerm_resource_group.main_resource_group.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  custom_data         = filebase64("azure-user-data.sh")

  network_interface_ids = [
    azurerm_network_interface.main_nic.id,
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

resource "azurerm_network_security_group" "access_allow_all" {
  name                = "allow-all-access-sg"
  resource_group_name = data.azurerm_resource_group.main_resource_group.name
  location            = data.azurerm_resource_group.main_resource_group.location

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
