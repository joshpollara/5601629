variable "tier" {
  type    = string
  default = "standard"
}

resource "terraform_data" "database" {
  input = "3"
}

output "tier" {
  value = var.tier
}
