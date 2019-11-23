module "shared" {
  source = "./modules/shared"
  jupyter_port = var.jupyter_port
  airflow_port = var.airflow_port
  aws_region = data.terraform_remote_state.rds.outputs.aws_region
  vpc_id = data.terraform_remote_state.rds.outputs.vpc_id
  rds_security_group_id = data.terraform_remote_state.rds.outputs.rds_security_group_id
  number_of_load_balancers = var.number_of_load_balancers
}
