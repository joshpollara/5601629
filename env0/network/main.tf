variable "cidr" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "api_token" {
  type      = string
  sensitive = true
}

variable "labels" {
  type = map(string)
}

variable "note" {
  type = string
}

variable "region" {
  type = string
}

resource "terraform_data" "network" {
  input = {
    cidr     = var.cidr
    password = sha256(var.db_password)
    token    = sha256(var.api_token)
    labels   = var.labels
    note     = var.note
    region   = var.region
    version  = "2"
  }
}

output "network_id" {
  value = "net-${var.cidr}"
}
