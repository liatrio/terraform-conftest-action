resource "azurerm_resource_group" "rg" {
  name = "example-rg"
  location = "northcentralus"

  tags = {
    CostCenter        = "Security Guil" # typo
    Owner             = "someone@liatrio.com"
    AutomationEnabled = "yes"
  }
}
