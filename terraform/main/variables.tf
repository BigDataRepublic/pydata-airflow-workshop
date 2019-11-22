variable "airflow_port" {
  default = 8080
}

variable "jupyter_port" {
  default = 8888
}

data "terraform_remote_state" "rds" {
  backend = "s3"
  config = {
    bucket = "pydata-terraform-state-rds"
    key = "main/state"
    region = "eu-west-1"
  }
}



variable "aws_region" {
  default = "eu-west-1"
}

