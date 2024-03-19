provider "azurerm" {
  features {}
}

# Crear una red virtual
resource "azurerm_virtual_network" "my_vnet" {
  name                = "my-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = "East US"
  resource_group_name = azurerm_resource_group.my_rg.name
}

# Crear la primera subred
resource "azurerm_subnet" "first_subnet" {
  name                 = "first-subnet"
  resource_group_name  = azurerm_resource_group.my_rg.name
  virtual_network_name = azurerm_virtual_network.my_vnet.name
  address_prefixes     = ["10.0.0.0/24"]
}

# Crear la segunda subred
resource "azurerm_subnet" "second_subnet" {
  name                 = "second-subnet"
  resource_group_name  = azurerm_resource_group.my_rg.name
  virtual_network_name = azurerm_virtual_network.my_vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}



resource "azurerm_virtual_machine" "my_vm" {
  name                  = var.name_vm
  location              = azurerm_resource_group.my_rg.location
  resource_group_name   = azurerm_resource_group.my_rg.name
  network_interface_ids = [azurerm_network_interface.my_nic.id]
  vm_size               = "Standard_DS1_v2"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "staging"
  }
}


# Crear la interfaz de red
resource "azurerm_network_interface" "my_nic" {
  name                = "my-nic"
  location            = azurerm_resource_group.my_rg.location
  resource_group_name = azurerm_resource_group.my_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.first_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.public_ip.id
  }
}

# Crear el grupo de recursos
resource "azurerm_resource_group" "my_rg" {
  name     = "my-resource-group"
  location = "East US"
}

resource "azurerm_network_security_group" "example" {
  name                = "acceptanceTestSecurityGroup1"
  location            = azurerm_resource_group.my_rg.location
  resource_group_name = azurerm_resource_group.my_rg.name

  security_rule {
    name                       = "test123"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
resource "azurerm_public_ip" "public_ip" {
  name                = "acceptanceTestPublicIp1"
  resource_group_name = azurerm_resource_group.my_rg.name
  location            = azurerm_resource_group.my_rg.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface_security_group_association" "my_sg_as" {
  network_interface_id      = azurerm_network_interface.my_nic.id
  network_security_group_id = azurerm_network_security_group.example.id
}
