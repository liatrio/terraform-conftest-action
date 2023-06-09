resource "azurerm_resource_group" "rg" {
  name = "example-rg"
  location = "northcentralus"

  tags = {
    CostCenter        = "Security Guild"
    Owner             = "someone@liatrio.com"
    AutomationEnabled = "true" # Should be "yes" or "no"
  }
}
