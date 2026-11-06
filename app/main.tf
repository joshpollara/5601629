variable "ws" {
  type = string
}

resource "terraform_data" "app" {
  input = "1"
}

output "ws" {
  value = var.ws
}
