variable "tier" {
  type    = string
  default = "standard"
}

resource "terraform_data" "base" {
  input = "3"
}

resource "terraform_data" "extra" {
  input = "3"
}

output "tier" {
  value = var.tier
}
