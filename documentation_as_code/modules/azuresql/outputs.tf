output "sql_server_name" {
  value       = azurerm_mssql_server.main.name
  description = <<EOF
The name of the SQL server.
EOF
}
