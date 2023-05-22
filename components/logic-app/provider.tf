terraform {
  backend "azurerm" {}
  required_providers {
    azurerm = "3.57.0"
  }
}


provider "azurerm" {
  features {
    template_deployment {
      delete_nested_items_during_deletion = false
    }
  }
}

provider "azurerm" {
  features {}
  alias           = "cft-ptl"
  subscription_id = "1baf5470-1c3e-40d3-a6f7-74bfbce4b348"
}

provider "azurerm" {
  features {}
  alias           = "cft-ptlsbox"
  subscription_id = "1497c3d7-ab6d-4bb7-8a10-b51d03189ee3"
}