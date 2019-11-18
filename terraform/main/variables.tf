variable "airflow_port" {
  default = 8080
}

variable "jupyter_port" {
  default = 8888
}

variable "aws_region" {}

variable "vpc_id" {}

variable "rds_host" {}

variable "rds_port" {}

variable "rds_username" {}

variable "rds_password" {}

variable "rds_database" {}

variable "rds_security_group_id" {}
