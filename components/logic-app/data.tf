data "azurerm_client_config" "current" {
}

data "local_file" "logic_app" {
  filename = "./workflow.json"
}

data "azurerm_subnet" "cft-ptl-00" {
  name                 = "aks-00"
  virtual_network_name = "cft-ptl-vnet"
  resource_group_name  = "cft-ptl-network-rg"
}

data "azurerm_subnet" "cft-ptlsbox-00" {
  name                 = "aks-00"
  virtual_network_name = "cft-ptlsbox-vnet"
  resource_group_name  = "cft-ptlsbox-network-rg"
}