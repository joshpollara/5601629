variable "stage" { type = string }
variable "cidr_block" { type = string }

resource "terraform_data" "network" {
  input = "${var.stage} network ${var.cidr_block} in workspace ${terraform.workspace}"
}

output "cidr_block" { value = var.cidr_block }
