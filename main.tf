# Provider requirements and provider configuration live in providers.tf.

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
