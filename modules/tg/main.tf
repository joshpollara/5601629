variable "v" {
  type = string
}

resource "terraform_data" "x" {
  input = var.v
}
