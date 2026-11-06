variable "tier" {
  type = string
}

variable "note" {
  type = string
}

resource "terraform_data" "database" {
  input = "3"
}

output "settings" {
  value = "${var.tier}/${var.note}"
}
