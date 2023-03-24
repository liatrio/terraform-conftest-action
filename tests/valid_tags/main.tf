resource "azurerm_resource_group" "rg" {
  name = "rg-dev-northcentralus-project-description"
  location = "northcentralus"

  tags = {
    CostCenter        = "Security Guild"
    Owner             = "someone@liatrio.com"
    AutomationEnabled = "yes"
  }
}
