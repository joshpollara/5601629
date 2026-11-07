# migrated from Spacelift
variable "region" {
  type = string
}

variable "tier" {
  type = string
}

variable "owner" {
  type = string
}

variable "spacelift_stack_id" {
  type = string
}

resource "terraform_data" "app" {
  input = {
    region = var.region
    tier   = var.tier
    owner  = var.owner
    stack  = var.spacelift_stack_id
  }
}

output "settings" {
  value = "${var.spacelift_stack_id}/${var.region}/${var.tier}/${var.owner}"
}
