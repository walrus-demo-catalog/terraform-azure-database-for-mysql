terraform {
  required_version = ">= 1.0"

  required_providers {
    random = {
      source  = "hashicorp/random"
      version = ">= 3.5.1"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.88.0"
    }
  }
}

provider "azurerm" {
  skip_provider_registration = true
  features {}
}

# create resource group.
resource "azurerm_resource_group" "rg" {
  name     = "azure-db-rg"
  location = "eastus"
}

# create virtual network.

resource "azurerm_virtual_network" "vn" {
  name                = "azure-db-vn"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "sn" {
  name                 = "azure-db-sn"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vn.name
  address_prefixes     = ["10.0.1.0/24"]
  service_endpoints    = ["Microsoft.Storage"]
  delegation {
    name = "fs"
    service_delegation {
      name = "Microsoft.DBforMySQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
}

# create private dns.

resource "azurerm_private_dns_zone" "pdz" {
  name                = "sealio.mysql.database.azure.com"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "vnl" {
  name                  = join("-", ["vnl", azurerm_virtual_network.vn.name])
  private_dns_zone_name = azurerm_private_dns_zone.pdz.name
  virtual_network_id    = azurerm_virtual_network.vn.id
  resource_group_name   = azurerm_resource_group.rg.name
}