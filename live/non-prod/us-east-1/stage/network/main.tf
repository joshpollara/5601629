terraform {
  required_version = ">= 1.6"
}

variable "azs" {
  type = list(string)
}

module "network" {
  source = "./terragrunt-module"
  azs    = var.azs
  cidr   = "10.20.0.0/16"
  name   = "network-stage"
  tags   = {
    Environment = "stage"
    ManagedBy   = "terragrunt"
  }
}

output "az_count" {
  value = module.network.az_count
}

output "cidr" {
  value = module.network.cidr
}

output "private_subnet_ids" {
  value = module.network.private_subnet_ids
}

output "subnet_by_az" {
  value = module.network.subnet_by_az
}

output "vpc_id" {
  value = module.network.vpc_id
}
