output "app_instance_id" {
  description = "ID of the application host."
  value       = vultr_instance.app.id
}

output "app_public_ipv4" {
  description = "Public IPv4 address of the application host."
  value       = vultr_instance.app.main_ip
}

output "app_public_ipv6" {
  description = "Public IPv6 address of the application host (empty when IPv6 is disabled)."
  value       = vultr_instance.app.v6_main_ip
}

output "app_url" {
  description = "URL on which the web application is reachable."
  value       = "http://${vultr_instance.app.main_ip}:${var.http_port}"
}

output "firewall_group_id" {
  description = "ID of the firewall group protecting the web tier."
  value       = vultr_firewall_group.web.id
}

output "region" {
  description = "Region the workload is deployed in."
  value       = var.region
}

output "estimated_monthly_cost_usd" {
  description = "Rough estimated monthly cost of this stack, in USD."
  value       = local.estimated_monthly_cost
}

output "budget_alert_email" {
  description = "Email address that should be configured as the billing alert recipient."
  value       = var.budget_alert_email
}
