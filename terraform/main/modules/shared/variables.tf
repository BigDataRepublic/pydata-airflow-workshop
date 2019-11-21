variable "airflow_port" {}

variable "jupyter_port" {}

variable "aws_region" {}

variable "vpc_id" {}

variable "rds_security_group_id" {}

variable "number_of_loadbalancers" {
  default = 6
}