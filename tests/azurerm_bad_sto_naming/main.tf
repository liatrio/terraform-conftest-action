resource "azurerm_resource_group" "rg" {
  name = "rg-dev-northcentralus-project-description"
  location = "northcentralus"

  tags = var.tags
}

# No "sto"
resource "azurerm_storage_account" "example1" {
  name                     = "stdevnorthcentralusxy"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = var.tags
}

# Bad env (typo)
resource "azurerm_storage_account" "example2" {
  name                     = "stodvnorthcentralusxy"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = var.tags
}

# Bad region (typo)
resource "azurerm_storage_account" "example3" {
  name                     = "stodevnorhcentralusxy"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = var.tags
}

