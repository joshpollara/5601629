# migrated from env0
variable "region" {
  type = string
}

variable "tier" {
  type = string
}

resource "terraform_data" "app" {
  input = {
    region = var.region
    tier   = var.tier
  }
}

output "settings" {
  value = "${var.region}/${var.tier}"
}
