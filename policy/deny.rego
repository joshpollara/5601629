package main

import rego.v1

deny contains msg if {
  some rc in input.resource_changes
  rc.change.after.input == "forbidden"
  msg := sprintf("%s sets a forbidden input", [rc.address])
}
