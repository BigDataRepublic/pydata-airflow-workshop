module "shared" {
  source = "./modules/shared"
  jupyter_port = var.jupyter_port
  airflow_port = var.airflow_port
  aws_region = var.aws_region
  vpc_id = var.vpc_id
  rds_security_group_id = var.rds_security_group_id
}
