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