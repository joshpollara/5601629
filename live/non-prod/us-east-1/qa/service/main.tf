terraform {
  required_version = ">= 1.6"
}

variable "database_7420cb_state_id" {
  type = string
}

data "terraform_remote_state" "database_7420cb" {
  backend = "http"
  config  = {
    address = "https://stategraph/${var.database_7420cb_state_id}"
  }
}

variable "network_7420cb_state_id" {
  type = string
}

data "terraform_remote_state" "network_7420cb" {
  backend = "http"
  config  = {
    address = "https://stategraph/${var.network_7420cb_state_id}"
  }
}

variable "server_port" {
  type = number
}

variable "alb_port" {
  type = number
}

variable "min_size" {
  type = number
}

variable "max_size" {
  type = number
}

variable "instance_type" {
  type = string
}

module "service" {
  source        = "./terragrunt-module"
  alb_port      = var.alb_port
  db_connection = data.terraform_remote_state.database_7420cb.outputs.connection
  db_endpoint   = data.terraform_remote_state.database_7420cb.outputs.endpoint
  db_port       = data.terraform_remote_state.database_7420cb.outputs.port
  environment   = "qa"
  instance_type = var.instance_type
  max_size      = var.max_size
  min_size      = var.min_size
  name          = "webserver-qa"
  server_port   = var.server_port
  service_cidr  = cidrsubnet(data.terraform_remote_state.network_7420cb.outputs.cidr, 8, 10)
  subnet_by_az  = data.terraform_remote_state.network_7420cb.outputs.subnet_by_az
  subnet_ids    = data.terraform_remote_state.network_7420cb.outputs.private_subnet_ids
  vpc_id        = data.terraform_remote_state.network_7420cb.outputs.vpc_id
}

output "instance_ids" {
  value = module.service.instance_ids
}

output "url" {
  value = module.service.url
}
