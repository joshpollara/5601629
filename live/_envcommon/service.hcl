locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env              = local.environment_vars.locals.environment
  base_source      = "${dirname(find_in_parent_folders("root.hcl"))}/../modules//service"
}

dependency "network" {
  config_path = "../network"
}

dependency "database" {
  config_path = "../database"
}

inputs = {
  name          = "webserver-${local.env}"
  vpc_id        = dependency.network.outputs.vpc_id
  subnet_ids    = dependency.network.outputs.private_subnet_ids
  subnet_by_az  = dependency.network.outputs.subnet_by_az
  service_cidr  = cidrsubnet(dependency.network.outputs.cidr, 8, 10)
  db_endpoint   = dependency.database.outputs.endpoint
  db_port       = dependency.database.outputs.port
  db_connection = dependency.database.outputs.connection
  instance_type = "t3.micro"
  min_size      = 2
  max_size      = 2
  server_port   = 8080
  alb_port      = 80
}
