variable "tier" {
  type    = string
  default = "standard"
}

resource "terraform_data" "base" {
  input = "2"
}

resource "terraform_data" "extra" {
  input = "2"
}

output "tier" {
  value = var.tier
}
