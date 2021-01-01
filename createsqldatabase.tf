# Variable region
variable "regions" {
  default     = ["East US", "West US"]
}

# Variable  'locals'
locals {
  tags = {
    "managed"     = "By IaC"
    "owner"       = "quickCloudPocs"
    "environment" = "POC"
  }
}

# Creates RG dynamically
resource "azurerm_resource_group" "main" {
  count    = "${length(var.regions)}"
  name     = "MyDB-RG-${count.index}"
  location = "${element(var.regions, count.index)}"
  tags     = "${local.tags}"
}

# Creates SQL Server
resource "azurerm_sql_server" "main" {
  count                        = "${length(var.regions)}"
  name                         = "mytfqlserver-${count.index}"
  resource_group_name          = "${element(azurerm_resource_group.main.*.name, count.index)}"
  location                     = "${element(azurerm_resource_group.main.*.location, count.index)}"
  version                      = "12.0"
  administrator_login          = "4dm1n157r470r"
  administrator_login_password = "4-v3ry-53cr37-p455w0rd"
  tags                         = "${local.tags}"
}

# Creates SQL Server firewall
resource "azurerm_sql_firewall_rule" "main" {
  count               = "${length(var.regions)}"
  name                = "AllowAzureServices"
  resource_group_name = "${element(azurerm_resource_group.main.*.name, count.index)}"
  server_name         = "${element(azurerm_sql_server.main.*.name, count.index)}"
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

# Creates SQL DB
resource "azurerm_sql_database" "main" {
  name                             = "mysqldatabase"
  resource_group_name              = "${azurerm_resource_group.main.*.name[0]}"
  location                         = "${azurerm_resource_group.main.*.location[0]}"
  server_name                      = "${azurerm_sql_server.main.*.name[0]}"
  edition                          = "Standard"
  requested_service_objective_name = "S1"
  tags                             = "${local.tags}"
}

# Creates RG deployment from jason
resource "azurerm_template_deployment" "failovergroup" {
  name                = "failover"
  resource_group_name = "${azurerm_resource_group.main.*.name[0]}"
  template_body = "${file("Template/failover.json")}"
  deployment_mode = "Incremental"

  parameters = {
      "sqlServerPrimaryName"  = "${azurerm_sql_server.main.*.name[0]}"
      "sqlDatabaseName"       = "${azurerm_sql_database.main.name}"
      "sqlFailoverGroupName"  = "myfailover"
      "partnerServers"        = "${join(",", slice(azurerm_sql_server.main.*.name, 1, length(var.regions)))}"
      "partnerResourceGroups" = "${join(",", slice(azurerm_resource_group.main.*.name, 1, length(var.regions)))}"
  }
}