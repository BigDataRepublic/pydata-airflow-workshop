variable "aws_region" {
  default = "eu-west-1"
}

variable "rds_instance_class" {
  default =  "db.t3.2xlarge"
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