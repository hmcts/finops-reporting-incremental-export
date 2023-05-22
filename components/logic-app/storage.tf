module "finops_reporting_storage_account" {
  source                   = "git::https://github.com/hmcts/cnp-module-storage-account.git?ref=master"
  env                      = var.environment
  storage_account_name     = "${replace(var.product, "-", "")}incremental${var.environment}"
  resource_group_name      = azurerm_resource_group.finops_reporting_rg.name
  location                 = var.location
  account_kind             = var.account_kind
  account_replication_type = var.account_replication_type

  common_tags = module.tags.common_tags
}

resource "azurerm_storage_table" "finops_reporting_storage_table" {
  name                 = "${replace(var.product, "-", "")}incremental${var.environment}"
  storage_account_name = module.finops_reporting_storage_account.storageaccount_name
}