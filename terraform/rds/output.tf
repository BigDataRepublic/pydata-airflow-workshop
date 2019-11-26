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
  value = aws_iam_role.ecs_task_execution_role.arn
}

output "ecs_security_group_id" {
  value = aws_security_group.ecs.id
}

output "iam_instance_profile_name" {
  value = aws_iam_instance_profile.container_instance.name
}

output "container_instance_security_group_id" {
  value = aws_security_group.container_instance.id
}

output "ecs_cluster" {
  value = aws_ecs_cluster.main
}

output "log_group_name" {
  value = aws_cloudwatch_log_group.log_group.name
}

output "aws_alb_main_arns" {
  value = aws_alb.main.*.arn
}

output "aws_alb_listener_fixed_response_arns" {
  value = aws_alb_listener.fixed_response.*.arn
}

output "load_balancer_security_group_id" {
  value = aws_security_group.lb.id
}

output "subnet_ids" {
  value = aws_subnet.public.*.id
}

output "load_balancer_dnss" {
  value = aws_alb.main.*.dns_name
}