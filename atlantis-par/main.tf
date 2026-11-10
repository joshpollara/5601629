resource "terraform_data" "brand_a" {
  triggers_replace = "a-v4"
  provisioner "local-exec" {
    command = "sleep 30"
  }
}

resource "terraform_data" "brand_b" {
  triggers_replace = "b-v2"
  provisioner "local-exec" {
    command = "sleep 30"
  }
}
