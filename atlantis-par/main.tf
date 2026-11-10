resource "terraform_data" "brand_a" {
  triggers_replace = "a-v2"
  provisioner "local-exec" {
    command = "sleep 30"
  }
}

resource "terraform_data" "brand_b" {
  triggers_replace = "b-v1"
  provisioner "local-exec" {
    command = "sleep 30"
  }
}
