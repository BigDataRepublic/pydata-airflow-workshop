module "shared" {
  source = "./shared"
  jupyter_port = var.jupyter_port
  airflow_port = var.airflow_port
  aws_region = var.aws_region
  vpc_id = aws_vpc.main.id
  rds_security_group_id = aws_security_group.rds.id
  number_of_load_balancers = var.number_of_load_balancers
}

