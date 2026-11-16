terraform {
  required_version = ">= 1.6"
  
  backend "azurerm" {
    resource_group_name = "rg-tfstate-learning"
    storage_account_name = "sttfstatepxcm"
    container_name = "tfstate"
    key = "prod.terraform.tfstate"
    use_azuread_auth = true
  }


  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}
