terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.93.1"
    }
  }
  required_version = ">= 1.0.0"
}


provider "azurerm" {
  features {}
  skip_provider_registration = true
}
