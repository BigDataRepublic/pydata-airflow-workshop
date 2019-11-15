provider "aws" {
  shared_credentials_file = "$HOME/.aws/credentials"
  profile = "bdr"
  region = var.aws_region
}


provider "postgresql" {
  host = module.abacus.aws_db_instance_db.address
  port = 5432
  username = module.abacus.aws_db_instance_db.username
  password = module.abacus.aws_db_instance_db.password
  sslmode = "require"
  connect_timeout = 15
}


resource "postgresql_database" "test" {
  name = "blabl"
}