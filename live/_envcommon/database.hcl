locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env              = local.environment_vars.locals.environment
  base_source      = "${dirname(find_in_parent_folders("root.hcl"))}/../modules//database"
}

dependency "network" {
  config_path = "../network"

  mock_outputs = {
    vpc_id             = "vpc-mock"
    private_subnet_ids = ["subnet-mock"]
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}

inputs = {
  name              = "mysql_${local.env}"
  vpc_id            = dependency.network.outputs.vpc_id
  subnet_ids        = dependency.network.outputs.private_subnet_ids
  instance_class    = "db.t3.micro"
  allocated_storage = 20
  storage_type      = "standard"
  master_username   = "admin"
}
