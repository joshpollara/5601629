output "vpc_id" { value = "vpc-${terraform_data.vpc.id}" }
output "cidr" { value = var.cidr }
output "private_subnet_ids" { value = [for az in var.azs : "subnet-${terraform_data.subnet[az].id}"] }
output "subnet_by_az" { value = { for az in var.azs : az => "subnet-${terraform_data.subnet[az].id}" } }
output "az_count" { value = length(var.azs) }
