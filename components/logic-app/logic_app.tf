resource "azurerm_logic_app_workflow" "logic_app_workflow" {
  name                = var.product
  location            = azurerm_resource_group.finops_reporting_rg.location
  resource_group_name = azurerm_resource_group.finops_reporting_rg.name

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_resource_group_template_deployment" "logic_app_deployment" {
  resource_group_name = azurerm_resource_group.finops_reporting_rg.name
  deployment_mode     = "Incremental"
  name                = "logic-app-deployment"

  template_content = data.local_file.logic_app.content

  parameters_content = jsonencode({
    "logic_app_name" = { value = azurerm_logic_app_workflow.logic_app_workflow.name }
    "location"       = { value = azurerm_resource_group.finops_reporting_rg.location }
  })
}

