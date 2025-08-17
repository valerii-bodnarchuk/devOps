variable "vpc_id" {}
variable "subnets" { type = list(string) }
variable "db_name" {}
variable "env" { default = "staging" }