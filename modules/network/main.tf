terraform {
  required_version = ">= 1.5"
}

resource "terraform_data" "vpc" {
  input = { name = var.name, cidr = var.cidr, tags = var.tags }
}

resource "terraform_data" "subnet" {
  for_each = toset(var.azs)
  input    = { vpc = terraform_data.vpc.id, az = each.key, cidr = cidrsubnet(var.cidr, 8, index(var.azs, each.key)) }
}
