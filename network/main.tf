terraform {
}

variable "cidr" {
  type = string
}

variable "labels" {
  type = map(string)
}

variable "region" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "extra" {
  type = string
}

variable "secret_env" {
  type      = string
  sensitive = true
}

resource "terraform_data" "network" {
  input = {
    cidr        = var.cidr
    labels      = var.labels
    region      = var.region
    password    = sha256(var.db_password)
    extra       = var.extra
    secret_env  = sha256(var.secret_env)
  }
}

output "cidr" {
  value = var.cidr
}

# migrated from Terraform Cloud
