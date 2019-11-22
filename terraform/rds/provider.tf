provider "aws" {
  profile = "bdr"
  region = var.aws_region
}


terraform {
  required_version = ">= 0.12"
  backend "s3" {
    bucket = "pydata-terraform-state-rds"
    key = "main/state"
    region = "eu-west-1"
    dynamodb_table = "terraform-state-lock-rds"
  }
}
