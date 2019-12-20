variable "aws_region" {}

variable "rds_instance_class" {}

variable "number_of_load_balancers" {}

variable "airflow_port" {
  default = 8080
}

variable "jupyter_port" {
  default = 8888
}

variable aws_user {}