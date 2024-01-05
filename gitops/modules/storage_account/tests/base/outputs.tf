output "rg_name" {
  value       = azurerm_resource_group.main.name
  description = <<EOF
Name of the resource group where testing environment is created.
EOF
}

output "location" {
  value       = azurerm_resource_group.main.location
  description = <<EOF
Azure region where the testing environment is created.
EOF
}

output "subnet_id" {
  value       = azurerm_subnet.main.id
  description = <<EOF
ID of the subnet to which the private endpoint will be attached.
EOF
}

output "private_dns_zone_id" {
  value       = azurerm_private_dns_zone.main.id
  description = <<EOF
ID of the private DNS zone to which the private endpoint will be attached.
EOF
}
