variable "ws" {
  type = string
}

resource "terraform_data" "app" {
  input = "2"
}

output "ws" {
  value = var.ws
}
