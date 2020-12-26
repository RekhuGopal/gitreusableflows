# ARM provider block
provider "azurerm" {
  version = "~>2.0"
  features {}
}

# Terraform configuration block
terraform {
  backend "azurerm" {
    resource_group_name  = "rg-cloudquickpocs"
    storage_account_name = "ccpsazuretf0001"
    container_name       = "ccpterraformstatefile"
    key                  = "ccpsterraform.tfstate"
  }
}

# RG creation
resource "azurerm_resource_group" "rg-hello-azure" {
  name     = "rg-cloudquickpocs"
  location = "northeurope"
}
