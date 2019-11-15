output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnets" {
  value = aws_subnet.public
}

output "load_balancer_security_group_id" {
  value = aws_security_group.lb.id
}

output "ecs_security_group_id" {
  value = aws_security_group.ecs.id
}

output "rds_security_group_id" {
  value = aws_security_group.rds.id
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

output "ecs_task_execution_role_arn" {
  value = aws_iam_role.ecs_task_execution_role.arn
}


output "aws_alb_main" {
  value = aws_alb.main
}

output "aws_alb_listener_fixed_response" {
  value = aws_alb_listener.fixed_response
}

output "aws_db_instance_db" {
  value = aws_db_instance.db
}