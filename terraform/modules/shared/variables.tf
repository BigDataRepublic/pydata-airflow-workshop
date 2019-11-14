variable "user_name" {}

variable "airflow_port" {}

variable "jupyter_port" {}

variable "vpc_id" {}

variable "subnets" {}

variable "load_balancer_security_group_id" {}

variable "ecs_security_group_id" {}

variable "rds_security_group_id" {}

variable "iam_instance_profile_name" {}

variable "container_instance_security_group_id" {}

variable "aws_region" {}

variable "ecs_cluster" {}

variable "log_group_name" {}

variable "ecs_task_execution_role_arn" {}
