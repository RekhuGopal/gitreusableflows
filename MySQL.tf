# Create RG
resource "azurerm_resource_group" "mysql" {
  name     = "cloudquickpocsmysql001"
  location = "West US"
}

# My SQL Server
resource "azurerm_mysql_server" "mysql" {
  name                = "cloudquickpocs-mysqlsvr"
  location            = "${azurerm_resource_group.mysql.location}"
  resource_group_name = "${azurerm_resource_group.mysql.name}"

  sku {
    name     = "B_Gen5_2"
    capacity = "2"
    tier     = "Basic"
    family   = "Gen5"
  }

  storage_profile {
    storage_mb            = "5120"
    backup_retention_days = "7"
    geo_redundant_backup  = "Disabled"
  }

  administrator_login          = "mysqladminun"
  administrator_login_password = "@1fhdj245fBBBafs"
  version                      = "5.7"
  ssl_enforcement              = "Enabled"
}

# mysql DB
resource "azurerm_mysql_database" "mysql" {
  name                = "mysqldb001"
  resource_group_name = "${azurerm_resource_group.mysql.name}"
  server_name         = "${azurerm_mysql_server.mysql.name}"
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}

# my sql firewall
resource "azurerm_mysql_firewall_rule" "mysql" {
  name                = "cloudquickpocmysql-fwrules"
  resource_group_name = "${azurerm_resource_group.mysql.name}"
  server_name         = "${azurerm_mysql_server.mysql.name}"
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}