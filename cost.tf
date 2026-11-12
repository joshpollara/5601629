########################################
# Cost guardrail
#
# The cloud provider has no Terraform/OpenTofu resource for billing budgets or
# billing alert recipients, so the monthly budget is enforced locally as a
# plan-time check. The alert itself must be configured once in the provider
# billing console for `var.budget_alert_email` (see README.md).
########################################

locals {
  compute_monthly_cost = lookup(var.plan_monthly_price, var.instance_plan, 0)

  # Provider-managed automatic backups are billed at ~20% of the plan price.
  backup_monthly_cost = var.enable_backups ? local.compute_monthly_cost * 0.2 : 0

  estimated_monthly_cost = local.compute_monthly_cost + local.backup_monthly_cost
}

check "within_monthly_budget" {
  assert {
    condition     = local.estimated_monthly_cost <= var.monthly_budget
    error_message = "Estimated monthly cost (USD ${local.estimated_monthly_cost}) exceeds the monthly budget (USD ${var.monthly_budget}). Pick a smaller plan or raise monthly_budget."
  }
}
