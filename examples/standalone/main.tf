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

# create mysql service.

module "this" {
  source = "../.."

  infrastructure = {
    domain_suffix = null
  }

  architecture   = "standalone"
  engine_version = "8.0.21"
  database       = "mydb"
  username       = "rdsuser"
  resources = {
    class = "B_Standard_B1s"
  }
  storage = {
    size = 20 * 1024
  }
}

output "context" {
  description = "The input context, a map, which is used for orchestration."
  value       = module.this.context
}

output "public_network_access_enabled" {
  description = "The public network access enabled or not."
  value       = module.this.public_network_access_enabled
}

output "connection" {
  description = "The connection, also the fully qualified domain name of the MySQL Flexible Server."
  value       = module.this.connection
}

output "database" {
  description = "The name of MySQL database to access."
  value       = module.this.database
}

output "username" {
  description = "The username of the account to access the database."
  value       = module.this.username
}

output "password" {
  description = "The password of the account to access the database."
  value       = module.this.password
  sensitive   = true
}
