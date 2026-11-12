########################################
# Edge firewall for the web application
########################################

resource "vultr_firewall_group" "web" {
  description = "${var.app_name}-${var.environment} web tier"
}

locals {
  # Split "x.x.x.x/nn" into the subnet and the prefix length expected by the API.
  http_cidrs = {
    for cidr in var.allowed_http_cidrs : cidr => {
      subnet      = cidrhost(cidr, 0)
      subnet_size = tonumber(split("/", cidr)[1])
    }
  }

  ssh_cidrs = {
    for cidr in var.allowed_ssh_cidrs : cidr => {
      subnet      = cidrhost(cidr, 0)
      subnet_size = tonumber(split("/", cidr)[1])
    }
  }
}

resource "vultr_firewall_rule" "http_v4" {
  for_each = local.http_cidrs

  firewall_group_id = vultr_firewall_group.web.id
  protocol          = "tcp"
  ip_type           = "v4"
  subnet            = each.value.subnet
  subnet_size       = each.value.subnet_size
  port              = tostring(var.http_port)
  notes             = "HTTP to ${var.app_name}"
}

resource "vultr_firewall_rule" "https_v4" {
  for_each = local.http_cidrs

  firewall_group_id = vultr_firewall_group.web.id
  protocol          = "tcp"
  ip_type           = "v4"
  subnet            = each.value.subnet
  subnet_size       = each.value.subnet_size
  port              = "443"
  notes             = "HTTPS to ${var.app_name}"
}

resource "vultr_firewall_rule" "http_v6" {
  count = var.enable_ipv6 ? 1 : 0

  firewall_group_id = vultr_firewall_group.web.id
  protocol          = "tcp"
  ip_type           = "v6"
  subnet            = "::"
  subnet_size       = 0
  port              = tostring(var.http_port)
  notes             = "HTTP (IPv6) to ${var.app_name}"
}

resource "vultr_firewall_rule" "https_v6" {
  count = var.enable_ipv6 ? 1 : 0

  firewall_group_id = vultr_firewall_group.web.id
  protocol          = "tcp"
  ip_type           = "v6"
  subnet            = "::"
  subnet_size       = 0
  port              = "443"
  notes             = "HTTPS (IPv6) to ${var.app_name}"
}

# SSH is closed by default: no rule is created unless allowed_ssh_cidrs is set.
resource "vultr_firewall_rule" "ssh" {
  for_each = local.ssh_cidrs

  firewall_group_id = vultr_firewall_group.web.id
  protocol          = "tcp"
  ip_type           = "v4"
  subnet            = each.value.subnet
  subnet_size       = each.value.subnet_size
  port              = "22"
  notes             = "Administrative SSH access"
}
