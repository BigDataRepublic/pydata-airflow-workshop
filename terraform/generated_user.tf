module "abacus" {
  source = "./modules/user"
  
  user_name = "abacus"
  airflow_port = var.airflow_port
  jupyter_port = var.jupyter_port

  jupyter_visit_port = 8000
  airflow_visit_port = 9000
  aws_alb_main = module.shared.aws_alb_main
  aws_alb_listener_fixed_response = module.shared.aws_alb_listener_fixed_response
  vpc_id = module.shared.vpc_id
  subnets = module.shared.subnets
  load_balancer_security_group_id = module.shared.load_balancer_security_group_id
  ecs_security_group_id = module.shared.ecs_security_group_id
  rds_security_group_id = module.shared.rds_security_group_id
  iam_instance_profile_name = module.shared.iam_instance_profile_name
  container_instance_security_group_id = module.shared.container_instance_security_group_id
  aws_region = var.aws_region
  ecs_cluster = module.shared.ecs_cluster
  log_group_name = module.shared.log_group_name
  ecs_task_execution_role_arn = module.shared.ecs_task_execution_role_arn
    aws_db_instance_db = module.shared.aws_db_instance_db

    }

module "abdomen" {
  source = "./modules/user"
  
  user_name = "abdomen"
  airflow_port = var.airflow_port
  jupyter_port = var.jupyter_port

  jupyter_visit_port = 8001
  airflow_visit_port = 9001
  aws_alb_main = module.shared.aws_alb_main
  aws_alb_listener_fixed_response = module.shared.aws_alb_listener_fixed_response
  vpc_id = module.shared.vpc_id
  subnets = module.shared.subnets
  load_balancer_security_group_id = module.shared.load_balancer_security_group_id
  ecs_security_group_id = module.shared.ecs_security_group_id
  rds_security_group_id = module.shared.rds_security_group_id
  iam_instance_profile_name = module.shared.iam_instance_profile_name
  container_instance_security_group_id = module.shared.container_instance_security_group_id
  aws_region = var.aws_region
  ecs_cluster = module.shared.ecs_cluster
  log_group_name = module.shared.log_group_name
  ecs_task_execution_role_arn = module.shared.ecs_task_execution_role_arn
    aws_db_instance_db = module.shared.aws_db_instance_db

    }