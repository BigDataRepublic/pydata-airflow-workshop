provider "aws" {
  shared_credentials_file = "$HOME/.aws/credentials"
  profile = "bdr"
  region = var.aws_region
}
