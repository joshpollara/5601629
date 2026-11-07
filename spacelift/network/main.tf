variable "cidr" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "note" {
  type = string
}

variable "config_path" {
  type = string
}

variable "spacelift_stack_id" {
  type = string
}

resource "terraform_data" "network" {
  input = {
    cidr     = var.cidr
    password = sha256(var.db_password)
    note     = var.note
    zone     = jsondecode(file(var.config_path)).zone
    secret   = sha256(file("${dirname(var.config_path)}/secret.txt"))
    stack    = var.spacelift_stack_id
  }
}

output "network_id" {
  value = "net-${var.cidr}"
}
