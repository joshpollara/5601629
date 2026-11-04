terraform {
  required_version = ">= 1.5"

  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2"
    }
  }
}

variable "revision" {
  type    = string
  default = "7"
}

resource "null_resource" "marker" {
  triggers = {
    revision = var.revision
  }
}

output "revision" {
  value = null_resource.marker.triggers.revision
}
