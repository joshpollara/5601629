resource "terraform_data" "subnet_group" {
  input = { vpc = var.vpc_id, subnets = var.subnet_ids }
}

resource "terraform_data" "db" {
  input = {
    name     = var.name
    class    = var.instance_class
    storage  = var.allocated_storage
    type     = var.storage_type
    username = var.master_username
    group    = terraform_data.subnet_group.id
  }
}

resource "terraform_data" "credentials" {
  input = sha256(var.master_password)
}
