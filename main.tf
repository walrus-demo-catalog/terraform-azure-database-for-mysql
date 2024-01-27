locals {
  project_name     = coalesce(try(var.context["project"]["name"], null), "default")
  project_id       = coalesce(try(var.context["project"]["id"], null), "default_id")
  environment_name = coalesce(try(var.context["environment"]["name"], null), "test")
  environment_id   = coalesce(try(var.context["environment"]["id"], null), "test_id")
  resource_name    = coalesce(try(var.context["resource"]["name"], null), "example")
  resource_id      = coalesce(try(var.context["resource"]["id"], null), "example_id")

  namespace = join("-", [local.project_name, local.environment_name])

  tags = {
    "Name" = join("-", [local.namespace, local.resource_name])

    "walrus.seal.io-catalog-name"     = "terraform-azure-database-for-mysql"
    "walrus.seal.io-project-id"       = local.project_id
    "walrus.seal.io-environment-id"   = local.environment_id
    "walrus.seal.io-resource-id"      = local.resource_id
    "walrus.seal.io-project-name"     = local.project_name
    "walrus.seal.io-environment-name" = local.environment_name
    "walrus.seal.io-resource-name"    = local.resource_name
  }

  architecture = coalesce(var.architecture, "standalone")
}

#
# Ensure
#
data "azurerm_resource_group" "rg" {
  name = "azure-db-rg"
}

data "azurerm_virtual_network" "vn" {
  name                = "azure-db-vn"
  resource_group_name = data.azurerm_resource_group.rg.name

  lifecycle {
    postcondition {
      condition     = self.id != null
      error_message = "Virtual network is not avaiable"
    }
  }
}

data "azurerm_subnet" "sn" {
  name                 = "azure-db-sn"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = data.azurerm_virtual_network.vn.name

  lifecycle {
    postcondition {
      condition     = self.id != null
      error_message = "Subnet is not avaiable"
    }
  }
}

data "azurerm_private_dns_zone" "pdz" {
  count = var.infrastructure.domain_suffix == null ? 0 : 1

  name                = var.infrastructure.domain_suffix
  resource_group_name = data.azurerm_resource_group.rg.name

  lifecycle {
    postcondition {
      condition     = self.id != null
      error_message = "Failed to get available private dns zone"
    }
  }
}

#
# Random
#

# create a random password for blank password input.

resource "random_password" "password" {
  length      = 16
  special     = false
  lower       = true
  min_lower   = 3
  min_upper   = 3
  min_numeric = 3
}

# create the name with a random suffix.

resource "random_string" "name_suffix" {
  length  = 10
  special = false
  upper   = false
}

#
# Deployment
#

# create server.

locals {
  name     = join("-", [local.resource_name, random_string.name_suffix.result])
  fullname = join("-", [local.namespace, local.name])
  version  = coalesce(var.engine_version, "8.0.21")
  database = coalesce(var.database, "mydb")
  username = coalesce(var.username, "rdsuser")
  password = coalesce(var.password, random_password.password.result)
}

resource "azurerm_mysql_flexible_server" "fs" {
  name = local.fullname
  tags = local.tags

  resource_group_name    = data.azurerm_resource_group.rg.name
  location               = data.azurerm_resource_group.rg.location
  administrator_login    = local.username
  administrator_password = local.password
  backup_retention_days  = 7
  delegated_subnet_id    = data.azurerm_subnet.sn.id
  private_dns_zone_id    = var.infrastructure.domain_suffix == null ? null : element(data.azurerm_private_dns_zone.pdz, 0).id
  sku_name               = var.resources.class
  version                = var.engine_version

  dynamic "high_availability" {
    for_each = local.architecture == "replication" ? [1] : []
    content {
      mode = "ZoneRedundant"
    }
  }

  storage {
    size_gb = try(var.storage.size / 1024, 20)
  }

  lifecycle {
    ignore_changes = [
      administrator_login,
      administrator_password,
      zone,
      high_availability.0.standby_availability_zone
    ]
  }
}

# create database.

resource "azurerm_mysql_flexible_database" "database" {
  name                = local.database
  resource_group_name = data.azurerm_resource_group.rg.name
  server_name         = azurerm_mysql_flexible_server.fs.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"

  lifecycle {
    ignore_changes = [
      name,
      charset,
      collation
    ]
  }
}
