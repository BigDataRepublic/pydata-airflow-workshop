provider "aws" {
  shared_credentials_file = "$HOME/.aws/credentials"
  profile = "bdr"
  region = var.aws_region
}


provider "postgresql" {
  host = module.shared.aws_db_instance_db.address
  port = 5432
  database = "airflow"
  username = module.shared.aws_db_instance_db.username
  password = module.shared.aws_db_instance_db.password
  sslmode = "disable"
  superuser = false
  connect_timeout = 15
}


