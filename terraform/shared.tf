module "shared" {
  source = "./modules/shared"
  jupyter_port = var.jupyter_port
  airflow_port = var.airflow_port
}
