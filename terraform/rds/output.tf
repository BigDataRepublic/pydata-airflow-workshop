output "vpc_id" {
  value = aws_vpc.main.id
}

output "aws_region" {
  value = var.aws_region
}

output "rds_host" {
  value = aws_db_instance.db.address
}

output "rds_port" {
  value = aws_db_instance.db.port
}

output "rds_username" {
  value = aws_db_instance.db.username
}

output "rds_password" {
  value = aws_db_instance.db.password
}

output "rds_database" {
  value = aws_db_instance.db.name
}

output "rds_security_group_id" {
  value = aws_security_group.rds.id
}

output "ecs_task_execution_role_arn" {
  value = module.shared.ecs_task_execution_role_arn
}

output "log_group_name" {
  value = module.shared.log_group_name
}

output "ecs_security_group_id" {
  value = module.shared.ecs_security_group_id
}

output "iam_instance_profile_name" {
  value = module.shared.iam_instance_profile_name
}

output "container_instance_security_group_id" {
  value = module.shared.container_instance_security_group_id
}

output "ecs_cluster" {
  value = module.shared.ecs_cluster
}

output "aws_alb_main_arns" {
  value = module.shared.aws_alb_main_arns
}

output "subnet_ids" {
  value = module.shared.subnet_ids
}

output "load_balancer_security_group_id" {
  value = module.shared.load_balancer_security_group_id
}

output "aws_alb_listener_fixed_response_arns" {
  value = module.shared.aws_alb_listener_fixed_response_arns
}