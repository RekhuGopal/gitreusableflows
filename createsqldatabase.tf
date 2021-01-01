
# variable "local"
variable "regions" {
  type        = "list"
  default     = ["East US"]
}

# variable "locals"
locals {
  tags = {
    "managed"     = "via IaC"
    "owner"       = "quickcloudpocs"
    "environment" = "pocs"
  }
}

# create a RG
resource "azurerm_resource_group" "main" {
  count    = "${length(var.regions)}"
  name     = "MyDB-RG-${count.index}"
  location = "${element(var.regions, count.index)}"
  tags     = "${local.tags}"
}


# Create a SQL server for DB
resource "azurerm_sql_server" "main" {
  count                        = "${length(var.regions)}"
  name                         = "mytfqlserver-${count.index}"
  resource_group_name          = "${element(azurerm_resource_group.main.*.name, count.index)}"
  location                     = "${element(azurerm_resource_group.main.*.location, count.index)}"
  version                      = "12.0"
  administrator_login          = "xyz0001"
  administrator_login_password = "mysupersecretepaass001"
  tags                         = "${local.tags}"
}

# create firewall rules
resource "azurerm_sql_firewall_rule" "main" {
  count               = "${length(var.regions)}"
  name                = "AllowAzureServices"
  resource_group_name = "${element(azurerm_resource_group.main.*.name, count.index)}"
  server_name         = "${element(azurerm_sql_server.main.*.name, count.index)}"
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

# Create SQL DB
resource "azurerm_sql_database" "main" {
  name                             = "mysqldatabase"
  resource_group_name              = "${azurerm_resource_group.main.*.name[0]}"
  location                         = "${azurerm_resource_group.main.*.location[0]}"
  server_name                      = "${azurerm_sql_server.main.*.name[0]}"
  edition                          = "Standard"
  requested_service_objective_name = "S1"
  tags                             = "${local.tags}"
}

# Azure Resource Group deployment -  SQL server failover group
resource "azurerm_template_deployment" "failovergroup" {
  name                = "failover"
  resource_group_name = "${azurerm_resource_group.main.*.name[0]}"

  template_body = "${file("Template/failover.json")}"

  parameters {
    sqlServerPrimaryName  = "${azurerm_sql_server.main.*.name[0]}"
    sqlDatabaseName       = "${azurerm_sql_database.main.name}"
    sqlFailoverGroupName  = "myfailover"
    partnerServers        = "${join(",", slice(azurerm_sql_server.main.*.name, 1, length(var.regions)))}"
    partnerResourceGroups = "${join(",", slice(azurerm_resource_group.main.*.name, 1, length(var.regions)))}"
  }

  deployment_mode = "Incremental"
}