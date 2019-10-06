variable "aws_region" {
  description = "The AWS region things are created in"
  default = "eu-west-1"
}

variable "log_group" {
  default = "/ecs/pydata"
}

variable "ecs_task_execution_role_name" {
  description = "ECS task execution role name"
  default = "pydataECS"
}

variable "az_count" {
  description = "Number of AZs to cover in a given region"
  default = "2"
}

variable "airflow_image" {
  description = "airflow image"
  default = "puckel/docker-airflow:1.10.4"
}

variable "jupyter_image" {
  description = "jupyter image"
  default = "jupyter/scipy-notebook"
}

variable "airflow_port" {
  description = "Port exposed by the docker image to redirect traffic to"
  default = 8080
}

variable "jupyter_port" {
  default = 8888
}

variable "airflow_health_check_path" {
  default = "/health"
}

variable "jupyter_health_check_path" {
  default = "/login"
}

variable "airflow_webserver_container_name" {
  default = "airflow-webserver"
}

variable "jupyter_container_name" {
  default = "jupyter"
}
