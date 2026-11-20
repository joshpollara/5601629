variable "stage" { type = string }
variable "name" { type = string }
variable "greeting" { type = string }

resource "terraform_data" "app" {
  input = "${var.stage} ${var.name}: ${var.greeting} (workspace ${terraform.workspace})"
}
