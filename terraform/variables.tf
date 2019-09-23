# variables.tf

variable "aws_region" {
  description = "The AWS region things are created in"
  default     = "eu-west-1"
}

variable "ecs_task_execution_role_name" {
  description = "ECS task execution role name"
  default = "ecsTaskExecutionRole"
}

variable "az_count" {
  description = "Number of AZs to cover in a given region"
  default = "2"
}


variable "app_image" {
  description = "Docker image to run in the ECS cluster"
  default     = "puckel/docker-airflow"
}

variable "app_port" {
  description = "Port exposed by the docker image to redirect traffic to"
  default     = 8080
}

variable "health_check_path" {
  default = "/health"
}

variable "fargate_cpu" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default     = "1024"
}

variable "fargate_memory" {
  description = "Fargate instance memory to provision (in MiB)"
  default     = "2048"
}

