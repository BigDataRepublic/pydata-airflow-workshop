data "aws_s3_bucket" "remote_state" {
  bucket = "pydata-terraform-state"
}


terraform {
  required_version = ">= 0.12"
  backend "s3" {
    bucket = "pydata-terraform-state"
//    key = "main/state"
    region = "eu-west-1"
//    dynamodb_table = "terraform-state-lock"
  }
}

provider "aws" {
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
