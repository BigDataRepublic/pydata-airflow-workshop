variable "aws_region" {
  default = "eu-west-1"
}

variable "rds_instance_class" {
  default = var.rds_instance
}

variable "number_of_load_balancers" {
  default = 5
}

variable "airflow_port" {
  default = 8080
}

variable "jupyter_port" {
  default = 8888
}

variable aws_user {

}