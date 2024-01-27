locals {
  fqdn                          = azurerm_mysql_flexible_server.fs.fqdn
  public_network_access_enabled = azurerm_mysql_flexible_server.fs.public_network_access_enabled
}

output "context" {
  description = "The input context, a map, which is used for orchestration."
  value       = var.context
}

output "public_network_access_enabled" {
  description = "The public network access enabled or not."
  value       = local.public_network_access_enabled
}

output "connection" {
  description = "The connection, also the fully qualified domain name of the MySQL Flexible Server."
  value       = local.fqdn
}

output "database" {
  description = "The name of MySQL database to access."
  value       = local.database
}

output "username" {
  description = "The username of the account to access the database."
  value       = local.username
}

output "password" {
  description = "The password of the account to access the database."
  value       = local.password
  sensitive   = true
}
