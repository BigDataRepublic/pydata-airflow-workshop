resource "aws_ecs_cluster" "main" {
  name = "cb-cluster"
}

data "template_file" "cb_app" {
  template = file("./templates/ecs/cb_app.json.tpl")

  vars = {
    airflow_image      = var.airflow_image
    airflow_port       = var.airflow_port
    aws_region     = var.aws_region
    jupyter_image = var.jupyter_image
    jupyter_port = var.jupyter_port
    airflow_webserver_container_name = var.airflow_webserver_container_name
    jupyter_container_name = var.jupyter_container_name
  }
}

resource "aws_ecs_task_definition" "app" {
  family                   = "cb-app-task"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "4096"
  memory                   = "8192"
  container_definitions    = data.template_file.cb_app.rendered
}

resource "aws_ecs_service" "airflow" {
  name            = "airflow-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.ecs_tasks.id]
    subnets          = aws_subnet.private.*.id
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.airflow.id
    container_name   = var.airflow_webserver_container_name
    container_port   = var.airflow_port
  }

  depends_on = [aws_alb_listener.airflow]
}

resource "aws_ecs_service" "jupyter" {
  name            = "jupyter-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.ecs_tasks.id]
    subnets          = aws_subnet.private.*.id
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.jupyter.id
    container_name   = var.jupyter_container_name
    container_port   = var.jupyter_port
  }

  depends_on = [aws_alb_listener.jupyter]
}

