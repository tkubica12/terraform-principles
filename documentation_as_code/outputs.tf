output "sql_server_names" {
  value       = [for instance in module.sql : instance.sql_server_name]
  description = <<EOF
List of SQL server names. Example:

    sql_server_names = [
        "sql-1",
        "sql-2",
    ]
EOF
}