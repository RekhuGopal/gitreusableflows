## RG creation
resource "azurerm_resource_group" "CloudQuickPOCAPIMRG" {
  name     = "CloudQuickPOCAPIMRG"
  location = "West Europe"
}

## API Management creation
resource "azurerm_api_management" "CloudQuickPOCAPIM" {
  name                = "CloudQuickPOCsPIM"
  location            = azurerm_resource_group.CloudQuickPOCAPIMRG.location
  resource_group_name = azurerm_resource_group.CloudQuickPOCAPIMRG.name
  publisher_name      = "CloudQucikPOCs"
  publisher_email     = "cloudquickpocs@nomail.com"

  sku_name = "Developer_1"
}

## An API within APIM
resource "azurerm_api_management_api" "CloudQuickPOCAPIMAPI" {
  name                = "cloudquickpocsapim-api"
  resource_group_name = azurerm_resource_group.CloudQuickPOCAPIMRG.name
  api_management_name = azurerm_api_management.CloudQuickPOCAPIM.name
  revision            = "1"
  display_name        = "Example API"
  path                = "example"
  protocols           = ["https"]

  import {
    content_format = "swagger-json"
    content_value  = file("APIJson/conference-api.json")
  }
}