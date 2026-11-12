terraform {
  required_version = ">= 1.6"
}

variable "network_f5a9fb_state_id" {
  type = string
}

data "terraform_remote_state" "network_f5a9fb" {
  backend = "http"
  config  = {
    address = "https://stategraph/${var.network_f5a9fb_state_id}"
  }
}

variable "storage_type" {
  type = string
}

variable "master_username" {
  type = string
}

variable "instance_class" {
  type = string
}

variable "allocated_storage" {
  type = number
}

variable "master_password" {
  type      = string
  sensitive = true
}

module "database" {
  source            = "./terragrunt-module"
  allocated_storage = var.allocated_storage
  instance_class    = var.instance_class
  master_username   = var.master_username
  name              = "mysql_qa"
  storage_type      = var.storage_type
  subnet_ids        = data.terraform_remote_state.network_f5a9fb.outputs.private_subnet_ids
  vpc_id            = data.terraform_remote_state.network_f5a9fb.outputs.vpc_id
  master_password   = var.master_password
}

output "connection" {
  value     = module.database.connection
  sensitive = true
}

output "db_name" {
  value = module.database.db_name
}

output "endpoint" {
  value = module.database.endpoint
}

output "port" {
  value = module.database.port
}
