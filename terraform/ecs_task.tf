variable "volume_name" {
  default = "shared-storage"
}

variable "airflow_home_folder" {
  default = "/usr/local/airflow"
}

data "template_file" "app" {
  template = file("./templates/ecs/app.json.tpl")

  vars = {
    airflow_image = var.airflow_image
    airflow_port = var.airflow_port
    aws_region = var.aws_region
    jupyter_image = var.jupyter_image
    jupyter_port = var.jupyter_port
    airflow_webserver_container_name = var.airflow_webserver_container_name
    jupyter_container_name = var.jupyter_container_name
    log_group = var.log_group
    volume_name = var.volume_name
    airflow_home_folder = var.airflow_home_folder
  }
}

resource "aws_ecs_task_definition" "app" {
  family = "pydata-app"
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  network_mode = "awsvpc"
  requires_compatibilities = ["EC2"]
  container_definitions = data.template_file.app.rendered

  volume {
    name = var.volume_name
    host_path = "/"
  }
}

resource "aws_ecs_service" "airflow" {
  name = "pydata-airflow"
  cluster = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count = 1

  network_configuration {
    security_groups = [aws_security_group.ecs.id]
    subnets = aws_subnet.public.*.id
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.airflow.id
    container_name = var.airflow_webserver_container_name
    container_port = var.airflow_port
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.jupyter.id
    container_name = var.jupyter_container_name
    container_port = var.jupyter_port
  }

  depends_on = [aws_alb_listener.airflow]
}
