provider "aws" {
  shared_credentials_file = "$HOME/.aws/credentials"
  profile = "bdr"
  region = "eu-west-1"
}


resource "aws_s3_bucket" "terraform_state" {
  bucket = "pydata-terraform-state"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_dynamodb_table" "terraform_state_lock" {
  name = "terraform-state-lock"
  read_capacity = 1
  write_capacity = 1
  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

resource "aws_s3_bucket" "terraform_state_rds" {
  bucket = "pydata-terraform-state-rds"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_dynamodb_table" "terraform_state_lock_rds" {
  name = "terraform-state-lock-rds"
  read_capacity = 1
  write_capacity = 1
  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
