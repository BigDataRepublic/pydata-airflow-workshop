module "wrecking" {
  source = "./modules/user"
  
  user_name = "wrecking"
  airflow_port = var.airflow_port
  jupyter_port = var.jupyter_port
  vpc_id = module.shared.vpc_id
  subnets= module.shared.subnets
  load_balancer_security_group_id = module.shared.load_balancer_security_group_id
  ecs_security_group_id = module.shared.ecs_security_group_id
  efs_id = module.shared.efs_id
  iam_instance_profile_name = module.shared.iam_instance_profile_name
  container_instance_security_group_id = module.shared.container_instance_security_group_id
  aws_region = var.aws_region
  ecs_cluster = module.shared.ecs_cluster
  log_group_name = module.shared.log_group_name
  ecs_task_execution_role_arn = module.shared.ecs_task_execution_role_arn
}

module "cadet" {
  source = "./modules/user"
  
  user_name = "cadet"
  airflow_port = var.airflow_port
  jupyter_port = var.jupyter_port
  vpc_id = module.shared.vpc_id
  subnets= module.shared.subnets
  load_balancer_security_group_id = module.shared.load_balancer_security_group_id
  ecs_security_group_id = module.shared.ecs_security_group_id
  efs_id = module.shared.efs_id
  iam_instance_profile_name = module.shared.iam_instance_profile_name
  container_instance_security_group_id = module.shared.container_instance_security_group_id
  aws_region = var.aws_region
  ecs_cluster = module.shared.ecs_cluster
  log_group_name = module.shared.log_group_name
  ecs_task_execution_role_arn = module.shared.ecs_task_execution_role_arn
}