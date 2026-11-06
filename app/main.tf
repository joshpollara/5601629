terraform {
}

variable "tier" {
  type = string
}

variable "region" {
  type = string
}

resource "terraform_data" "app" {
  input = "${terraform.workspace}/${var.tier}/${var.region}"
}
