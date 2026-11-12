########################################
# Cloud provider access
########################################

variable "api_key" {
  description = "API key for the cloud provider (injected by InfraDots as an organizational variable)."
  type        = string
  sensitive   = true
}

########################################
# Naming / tagging
########################################

variable "app_name" {
  description = "Name of the web application. Used for resource labels, hostname and the container name."
  type        = string
  default     = "web-app"

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9-]{1,30}[a-z0-9]$", var.app_name))
    error_message = "app_name must be lowercase alphanumeric with dashes, 3-32 characters."
  }
}

variable "environment" {
  description = "Environment name used for tagging (e.g. dev, staging, prod)."
  type        = string
  default     = "prod"
}

variable "tags" {
  description = "Additional tags applied to the compute instance."
  type        = list(string)
  default     = []
}

########################################
# Placement / sizing
########################################

variable "region" {
  description = "Provider region slug for the European deployment (fra = Frankfurt, ams = Amsterdam, lhr = London, par = Paris)."
  type        = string
  default     = "fra"

  validation {
    condition     = contains(["ams", "fra", "lhr", "par", "mad", "sto", "waw"], var.region)
    error_message = "region must be one of the European region slugs: ams, fra, lhr, par, mad, sto, waw."
  }
}

variable "instance_plan" {
  description = "Compute plan (size) for the application host. Defaults to a small, budget friendly shared-CPU plan."
  type        = string
  default     = "vc2-1c-2gb"
}

variable "os_name" {
  description = "Operating system image name used for the application host."
  type        = string
  default     = "Ubuntu 24.04 LTS x64"
}

variable "enable_ipv6" {
  description = "Whether to attach a public IPv6 address to the instance."
  type        = bool
  default     = true
}

variable "enable_backups" {
  description = "Whether to enable daily provider-managed backups of the instance."
  type        = bool
  default     = true
}

########################################
# Application (Docker) configuration
########################################

variable "container_image" {
  description = "Docker image (including tag) that runs the web application."
  type        = string
  default     = "nginxinc/nginx-unprivileged:stable"
}

variable "container_port" {
  description = "Port the container listens on inside the host."
  type        = number
  default     = 8080
}

variable "http_port" {
  description = "Public HTTP port exposed on the instance."
  type        = number
  default     = 80
}

variable "container_env" {
  description = "Non-sensitive environment variables passed to the container. Never place secrets here - use InfraDots variables instead."
  type        = map(string)
  default     = {}
}

########################################
# Network access
########################################

variable "allowed_http_cidrs" {
  description = "IPv4 CIDR blocks allowed to reach the web application over HTTP/HTTPS."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "allowed_ssh_cidrs" {
  description = "IPv4 CIDR blocks allowed to reach SSH. Narrow this to your office/VPN ranges."
  type        = list(string)
  default     = []
}

variable "ssh_public_keys" {
  description = "Map of SSH key name => public key material granted access to the instance."
  type        = map(string)
  default     = {}
}

########################################
# Cost control
########################################

variable "monthly_budget" {
  description = "Monthly budget for this stack, in USD. Used by the cost guardrail check."
  type        = number
  default     = 1000
}

variable "budget_alert_email" {
  description = "Email address that receives budget/billing alerts for this stack."
  type        = string
  default     = "joshpollara@gmail.com"
}

variable "plan_monthly_price" {
  description = "Estimated monthly price (USD) per compute plan, used only for the local budget guardrail."
  type        = map(number)
  default = {
    "vc2-1c-1gb"  = 5
    "vc2-1c-2gb"  = 10
    "vc2-2c-4gb"  = 20
    "vc2-4c-8gb"  = 40
    "vc2-6c-16gb" = 80
  }
}
