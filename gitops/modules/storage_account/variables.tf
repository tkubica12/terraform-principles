variable "name_prefix" {
  type        = string
  description = <<EOF
Prefix for the name of the storage account.
EOF
}

variable "resource_group_name" {
  type        = string
  description = <<EOF
Name of the resource group where to create the storage account.
EOF
}

variable "location" {
  type        = string
  description = <<EOF
Azure region where the storage account will be created.
EOF
}

variable "enable_private_endpoint" {
  type        = bool
  default     = false
  description = <<EOF
Whether to enable private endpoint for the SQL Server.
EOF
}

variable "subnet_id" {
  type        = string
  default     = ""
  description = <<EOF
ID of the subnet to which the private endpoint will be attached.
EOF
}

variable "private_dns_zone_id" {
  type        = string
  default     = ""
  description = <<EOF
ID of the private DNS zone to which the private endpoint will be attached.
EOF
}
