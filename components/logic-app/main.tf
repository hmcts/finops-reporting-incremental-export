resource "azurerm_resource_group" "finops_reporting_rg" {
  name     = "${var.product}-${var.environment}-rg"
  location = var.location

  tags = module.tags.common_tags
}

module "tags" {
  source       = "git::https://github.com/hmcts/terraform-module-common-tags.git?ref=DTSPO-13031/finops-reporting"
  environment  = var.env
  product      = var.product
  builtFrom    = var.builtFrom
  expiresAfter = var.expiresAfter
}