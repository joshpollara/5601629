include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "envcommon" {
  path   = "${dirname(find_in_parent_folders("root.hcl"))}/_envcommon/service.hcl"
  expose = true
}

terraform {
  source = include.envcommon.locals.base_source
}

inputs = {
  instance_type = "t3.medium"
  min_size      = 3
  max_size      = 3
}
