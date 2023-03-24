resource "azurerm_resource_group" "rg" {
  name = "rg-dev-northcentralus-project-description"
  location = "northcentralus"

  tags = var.tags
}

resource "azurerm_managed_disk" "disk" {
  name                 = "disk-dev-northcentralus-project-description"
  location             = azurerm_resource_group.rg.location
  resource_group_name  = azurerm_resource_group.rg.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "1"

  tags = var.tags
}

resource "azurerm_virtual_network" "example" {
  name                = "vnet-dev-northcentralus-project-description"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  tags = var.tags
}

resource "azurerm_subnet" "example" {
  name                = "snet-dev-northcentralus-project-description"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.2.0/24"]
}


resource "azurerm_network_interface" "example" {
  name                = "example-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = var.tags
}

resource "azurerm_linux_virtual_machine" "example" {
  name                = "vm-dev-northcentralus-project-description"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.example.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = <<-EOF
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC/zDzi+Dz+HFena/JARjUOOBQX+EDvYY4UdjmHXFPbOyfJ/AQynBiKx9MESNJ0waZ1IHbXIZyf83DTU8UBfgTAMvH4r02HreSRKiM1bJdcw3l8x4/OPht525GjtzT0K0pWyycdfjMCz+ulJ3oVXWakP02VIuJe/vJfG8v5byi1lBNXFHCoDDUguoFxAtoo3XGd/prCYZKGBx0zVRcRhzNz0UJ6yJwecNH0SbRh5jl/IJknLAXIi+Wt5mvnY1ebWF3uHnXdSP71XnmzKgPnCm6zOwtRQdPEfnruLMiEjQeFZfU2bedy83x1hBijgizgx2Duwh0wiCGe2J4zVUItiRPtsjtOEAEW3ANZzr8KQDMQ27RZ5k/oTR4spjgTRYk1GBgXHc6CHZSKXYqHEecOmSgzqgsVLVCK7jzkhF0A7L0X7Gex4k7lcKouDksmjvrXVJQW/FdYxfx7qnvTqyb/oIVpk81k5wxks3M1WCbmIEMma+WR4LxC0LCLaIsdsu75DK8= blair@Blairs-MacBook-Pro.local
EOF
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

  tags = var.tags
}

resource "azurerm_network_security_group" "example" {
  name                = "nsg-dev-northcentralus-project-description"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

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

  tags = var.tags
}

resource "azurerm_storage_account" "example" {
  name                     = "stodevnorthcentralusxy"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = var.tags
}
