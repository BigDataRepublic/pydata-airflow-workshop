variable "airflow_volume_name" {
  default = "airflow"
}

variable "dags_volume_name" {
  default = "dags"
}

variable "airflow_home_folder" {
  default = "/usr/local/airflow/efs"
}

variable "jupyter_container_name" {
  default = "jupyter"
}

variable "airflow_webserver_container_name" {
  default = "airflow-webserver"
}

data "template_file" "app" {
  template = file("./modules/user/templates/ecs/app.json.tpl")

  vars = {
    airflow_image = "bdrci/pydata-2019-airflow"
    airflow_port = var.airflow_port
    aws_region = var.aws_region
    jupyter_port = var.jupyter_port
    airflow_webserver_container_name = "airflow-webserver"
    jupyter_container_name = "jupyter"
    log_group = var.log_group_name
    airflow_volume_name = var.airflow_volume_name
    airflow_home_folder = var.airflow_home_folder
    dags_volume_name = var.dags_volume_name
    user_name = var.user_name
    db_connection_string = "postgresql+psycopg2://${postgresql_role.user.name}:${postgresql_role.user.password}@${var.aws_db_instance_db.endpoint}/${postgresql_database.user_database.name}"
  }
}


resource "aws_ecs_task_definition" "app" {
  family = "pydata-${var.user_name}"
  execution_role_arn = var.ecs_task_execution_role_arn
  network_mode = "awsvpc"
  requires_compatibilities = [
    "EC2"]
  container_definitions = data.template_file.app.rendered
  task_role_arn = aws_iam_role.ecs_task.arn


  volume {
    name = var.airflow_volume_name
    host_path = "/efs/${var.user_name}"
  }

  volume {
    name = var.dags_volume_name
    host_path = "/efs/${var.user_name}/dags"
  }

  placement_constraints {
    type = "memberOf"
    expression = "ec2InstanceId == '${aws_instance.ecs.id}'"
  }
}

resource "aws_ecs_service" "airflow" {
  name = "pydata-airflow-${var.user_name}"
  cluster = var.ecs_cluster.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count = 1

  network_configuration {
    security_groups = [
      var.ecs_security_group_id]
    subnets = var.subnets.*.id
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

  depends_on = [
    aws_alb_listener.airflow]
}
