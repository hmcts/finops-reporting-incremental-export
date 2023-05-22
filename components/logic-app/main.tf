resource "azurerm_resource_group" "finops_reporting_rg" {
  name     = "${var.product}-${var.environment}-rg"
  location = var.location
}