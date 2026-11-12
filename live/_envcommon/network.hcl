locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env              = local.environment_vars.locals.environment
  base_source      = "${dirname(find_in_parent_folders("root.hcl"))}/../modules//network"
}

inputs = {
  name = "network-${local.env}"
  azs  = ["a", "b"]
  tags = { Environment = local.env, ManagedBy = "terragrunt" }
}
