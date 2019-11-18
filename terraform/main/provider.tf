provider "aws" {
  shared_credentials_file = "$HOME/.aws/credentials"
  profile = "bdr"
  region = var.aws_region
}


provider "postgresql" {
  host = var.rds_host
  port = var.rds_port
  database = "airflow"
  username = var.rds_username
  password = var.rds_database
  sslmode = "disable"
  superuser = false
  connect_timeout = 15
}


