terraform {
  required_version = ">= 1.5"

  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2"
    }

    vultr = {
      source  = "vultr/vultr"
      version = "~> 2.33"
    }
  }
}

# The cloud provider credential is supplied by InfraDots as the organizational
# variable `api_key` (mapped to the OpenTofu variable of the same name).
provider "vultr" {
  api_key     = var.api_key
  rate_limit  = 500
  retry_limit = 3
}
