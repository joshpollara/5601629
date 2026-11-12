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
