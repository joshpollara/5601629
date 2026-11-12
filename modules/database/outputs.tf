output "endpoint" { value = "${var.name}.${terraform_data.db.id}.db.internal" }
output "port" { value = var.port }
output "db_name" { value = var.name }
output "connection" {
  value     = "mysql://${var.master_username}:${var.master_password}@${var.name}.${terraform_data.db.id}.db.internal:${var.port}"
  sensitive = true
}
