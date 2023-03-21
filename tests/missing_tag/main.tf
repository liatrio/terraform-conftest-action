resource "azurerm_resource_group" "rg" {
  name = "example-rg"
  location = "northcentralus"

  tags = {
    CostCenter        = "Security Guild"
    # Omit the Owner tag
    # Owner             = "someone@liatrio.com"
    AutomationEnabled = "yes"
  }
}
