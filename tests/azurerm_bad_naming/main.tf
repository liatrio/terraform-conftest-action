# Not using the right prefix
resource "azurerm_resource_group" "rg" {
  name = "r-dev-northcentralus-project-description"
  location = "northcentralus"

  tags = var.tags
}

# Nonexistent env
resource "azurerm_managed_disk" "disk" {
  name                 = "disk-dv-northcentralus-project-description"
  location             = azurerm_resource_group.rg.location
  resource_group_name  = azurerm_resource_group.rg.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "1"

  tags = var.tags
}

# Nonexistent region (typo)
resource "azurerm_virtual_network" "example" {
  name                = "vnet-dev-nothcentralus-project-description"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  tags = var.tags
}

# Bad format (no description)
resource "azurerm_subnet" "example" {
  name                = "snet-dev-northcentralus-project"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.2.0/24"]
}


