module "shared" {
  source = "./modules/shared"
  jupyter_port = var.jupyter_port
  airflow_port = var.airflow_port
  aws_region = var.aws_region
//  subnets = var.subnets
}
