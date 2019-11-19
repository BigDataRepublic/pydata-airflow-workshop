variable "airflow_port" {
  default = 8080
}

variable "jupyter_port" {
  default = 8888
}

data "terraform_remote_state" "rds" {
  backend = "local"

  config = {
    path = "${path.module}/../rds/terraform.tfstate"
  }
}
