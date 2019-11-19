provider "aws" {
  shared_credentials_file = "$HOME/.aws/credentials"
  profile = "bdr"
  region = data.terraform_remote_state.rds.outputs.aws_region
}

provider "postgresql" {
  host = data.terraform_remote_state.rds.outputs.rds_host
  port = data.terraform_remote_state.rds.outputs.rds_port
  database = data.terraform_remote_state.rds.outputs.rds_database
  username = data.terraform_remote_state.rds.outputs.rds_username
  password = data.terraform_remote_state.rds.outputs.rds_password
  sslmode = "disable"
  superuser = false
  connect_timeout = 15
}
