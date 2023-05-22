resource "azurerm_role_assignment" "storage_table_contributor" {
  scope                = azurerm_storage_table.finops_reporting_storage_table.id
  role_definition_name = "Storage Table Data Contributor"
  principal_id         = azurerm_logic_app_workflow.logic_app_workflow.identity[0].principal_id
}