## RG creation
resource "azurerm_resource_group" "QuickPOCAPIMRG" {
  name     = "QuickPOCAPIM"
  location = "West Europe"
}

## API Management creation
resource "azurerm_api_management" "QuickPOCAPIM" {
  name                = var.apim_name
  location            = azurerm_resource_group.QuickPOCAPIMRG.location
  resource_group_name = azurerm_resource_group.QuickPOCAPIMRG.name
  publisher_name      = "CloudQucikPOCs"
  publisher_email     = "cloudquickpocs@nomail.com"

  sku_name = "Developer_1"
}

## An API within APIM
resource "azurerm_api_management_api" "QuickPOCAPIMAPI" {
  name                = "cloudquickpocsapim-api"
  resource_group_name = azurerm_resource_group.QuickPOCAPIMRG.name
  api_management_name = azurerm_api_management.QuickPOCAPIM.name
  revision            = "1"
  display_name        = "Example API"
  path                = "example"
  protocols           = ["https"]

  import {
    content_format = "swagger-json"
    content_value  = file("APIJson/conference-api.json")
  }
}