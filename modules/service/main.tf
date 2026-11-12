resource "terraform_data" "alb" {
  input = { name = var.name, vpc = var.vpc_id, subnets = var.subnet_ids, port = var.alb_port, cidr = var.service_cidr }
}

resource "terraform_data" "instance" {
  count = var.max_size
  input = {
    type   = var.instance_type
    subnet = var.subnet_ids[count.index % length(var.subnet_ids)]
    port   = var.server_port
    db     = "${var.db_endpoint}:${var.db_port}"
    env    = var.environment
    zones  = var.subnet_by_az
  }
}

resource "terraform_data" "db_secret" {
  input      = sha256(var.db_connection)
  depends_on = [terraform_data.instance]
}
