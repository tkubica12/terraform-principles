output "storage_account_name" {
  value = azurerm_storage_account.main.name
  description = <<EOF
Name of the storage account.
EOF
}