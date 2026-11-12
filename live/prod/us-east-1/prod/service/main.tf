terraform {
  required_version = ">= 1.6"
}

variable "database_f48e75_state_id" {
  type = string
}

data "terraform_remote_state" "database_f48e75" {
  backend = "http"
  config  = {
    address = "https://stategraph/${var.database_f48e75_state_id}"
  }
}

variable "network_f48e75_state_id" {
  type = string
}

data "terraform_remote_state" "network_f48e75" {
  backend = "http"
  config  = {
    address = "https://stategraph/${var.network_f48e75_state_id}"
  }
}

variable "server_port" {
  type = number
}

variable "alb_port" {
  type = number
}

module "service" {
  source        = "./terragrunt-module"
  alb_port      = var.alb_port
  db_connection = data.terraform_remote_state.database_f48e75.outputs.connection
  db_endpoint   = data.terraform_remote_state.database_f48e75.outputs.endpoint
  db_port       = data.terraform_remote_state.database_f48e75.outputs.port
  environment   = "prod"
  instance_type = "t3.medium"
  max_size      = 3
  min_size      = 3
  name          = "webserver-prod"
  server_port   = var.server_port
  service_cidr  = cidrsubnet(data.terraform_remote_state.network_f48e75.outputs.cidr, 8, 10)
  subnet_by_az  = data.terraform_remote_state.network_f48e75.outputs.subnet_by_az
  subnet_ids    = data.terraform_remote_state.network_f48e75.outputs.private_subnet_ids
  vpc_id        = data.terraform_remote_state.network_f48e75.outputs.vpc_id
}

output "instance_ids" {
  value = module.service.instance_ids
}

output "url" {
  value = module.service.url
}
