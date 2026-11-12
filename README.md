# Dockerized web application (European region)

This workspace provisions a small, self-contained environment for a container-packaged
web application in a European region. It is intentionally minimal: no database,
no object storage, no load balancer and no managed monitoring were requested, so the
stack is a single hardened application host that runs the application container.

## What gets created

| File | Component | Resources |
|------|-----------|-----------|
| `providers.tf` | Provider setup | `required_providers` pin + provider configuration (reads `api_key`) |
| `network.tf` | Network / edge security | `vultr_firewall_group`, `vultr_firewall_rule` (HTTP, HTTPS, optional SSH) |
| `compute.tf` | Compute / application | `vultr_instance`, `vultr_ssh_key`, `data.vultr_os` |
| `cost.tf` | Cost guardrail | local cost estimate + `check` block against the monthly budget |
| `variables.tf` | Inputs | all tunables with sane defaults |
| `outputs.tf` | Outputs | instance ID, public IPv4/IPv6, application URL, cost estimate |
| `templates/cloud-init.yaml.tftpl` | Bootstrap | cloud-init that installs Docker and runs the app as a systemd-managed container |

### Design notes

* **Region** – defaults to `fra` (Frankfurt). Any European slug (`ams`, `lhr`, `par`,
  `mad`, `sto`, `waw`) is accepted and validated.
* **Packaging** – the application is a Docker image. cloud-init installs Docker,
  writes a systemd unit (`${app_name}.service`) with `Restart=always`, and starts the
  container with the configured port mapping and environment variables.
* **Security** – the instance sits behind a firewall group. HTTP/HTTPS are open to
  `allowed_http_cidrs`; **SSH is closed by default** and only opened if you set
  `allowed_ssh_cidrs`. No secrets are stored in this repository — use InfraDots
  variables for anything sensitive.
* **Resilience** – daily provider-managed backups are enabled by default
  (`enable_backups`).
* **Budget** – the provider exposes no Terraform resource for billing budgets or
  billing alert recipients. The budget is therefore enforced as a plan-time `check`
  (estimated monthly cost vs `monthly_budget`, default USD 1000) and the alert
  recipient (`budget_alert_email`) is surfaced as an output. Configure that address
  once as the billing alert contact in the provider's billing console.

## Variables to define in InfraDots

Set these in the InfraDots workspace/organization (no `.tfvars` files are kept in this repo):

| Variable | Scope | Required | Notes |
|----------|-------|----------|-------|
| `api_key` | Organization (sensitive) | yes | Cloud provider API key; already defined organization-wide |
| `app_name` | Workspace | no | Defaults to `web-app` |
| `environment` | Workspace | no | Defaults to `prod` |
| `region` | Workspace | no | Defaults to `fra` |
| `instance_plan` | Workspace | no | Defaults to `vc2-1c-2gb` |
| `container_image` | Workspace | yes in practice | Image + tag of your web application |
| `container_port` / `http_port` | Workspace | no | Defaults `8080` → `80` |
| `container_env` | Workspace | no | Non-sensitive env vars only |
| `allowed_http_cidrs` | Workspace | no | Defaults to the public internet |
| `allowed_ssh_cidrs` | Workspace | no | Empty = SSH closed |
| `ssh_public_keys` | Workspace | no | Map of key name → public key |
| `enable_ipv6`, `enable_backups` | Workspace | no | Booleans, default `true` |
| `monthly_budget` | Workspace | no | Defaults to `1000` |
| `budget_alert_email` | Workspace | no | Defaults to the address from the intake form |

## Plan and apply

Do **not** run `tofu plan` / `tofu apply` locally. All planning and applying for this
repository is performed by InfraDots: open a pull request, review the generated plan on
the PR, and apply from there.

InfraDots → https://app.infradots.com/
