include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "envcommon" {
  path   = "${dirname(find_in_parent_folders("root.hcl"))}/_envcommon/network.hcl"
  expose = true
}

terraform {
  source = include.envcommon.locals.base_source
}

inputs = {
  cidr = "10.10.0.0/16"
}
