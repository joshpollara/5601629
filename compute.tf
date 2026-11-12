########################################
# Application host (Docker web application)
########################################

data "vultr_os" "app" {
  filter {
    name   = "name"
    values = [var.os_name]
  }
}

resource "vultr_ssh_key" "admin" {
  for_each = var.ssh_public_keys

  name    = each.key
  ssh_key = each.value
}

locals {
  env_flags = join(" ", [
    for key, value in var.container_env : "-e \"${key}=${value}\""
  ])

  user_data = templatefile("${path.module}/templates/cloud-init.yaml.tftpl", {
    app_name        = var.app_name
    container_image = var.container_image
    container_port  = var.container_port
    http_port       = var.http_port
    env_flags       = local.env_flags
  })

  instance_tags = concat(
    [var.app_name, var.environment, "managed-by-infradots"],
    var.tags
  )
}

resource "vultr_instance" "app" {
  region = var.region
  plan   = var.instance_plan
  os_id  = data.vultr_os.app.id

  label    = "${var.app_name}-${var.environment}"
  hostname = "${var.app_name}-${var.environment}"
  tags     = local.instance_tags

  firewall_group_id = vultr_firewall_group.web.id
  ssh_key_ids       = [for key in vultr_ssh_key.admin : key.id]

  enable_ipv6      = var.enable_ipv6
  activation_email = false
  backups          = var.enable_backups ? "enabled" : "disabled"

  dynamic "backups_schedule" {
    for_each = var.enable_backups ? [1] : []

    content {
      type = "daily"
      hour = 2
    }
  }

  user_data = local.user_data

  lifecycle {
    # Re-running cloud-init requires a rebuild; change the image via the
    # systemd unit or a redeploy pipeline instead of recreating the host.
    ignore_changes = [user_data]
  }
}
