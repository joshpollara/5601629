variable "name" { type = string }
variable "vpc_id" { type = string }
variable "subnet_ids" { type = list(string) }
variable "subnet_by_az" { type = map(string) }
variable "service_cidr" { type = string }
variable "db_endpoint" { type = string }
variable "db_port" { type = number }
variable "db_connection" {
  type      = string
  sensitive = true
}
variable "instance_type" { type = string }
variable "min_size" { type = number }
variable "max_size" { type = number }
variable "server_port" { type = number }
variable "alb_port" { type = number }
variable "environment" { type = string }
