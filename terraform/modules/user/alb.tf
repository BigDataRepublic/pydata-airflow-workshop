resource "aws_alb" "main" {
  name = "pydata-${var.user_name}"
  subnets = var.subnets.*.id
  security_groups = [var.load_balancer_security_group_id]
}

resource "aws_alb_target_group" "airflow" {
  name = "airflow-${var.user_name}"
  port = 80
  protocol = "HTTP"
  vpc_id = var.vpc_id
  target_type = "ip"

  health_check {
    healthy_threshold = "2"
    interval = "30"
    protocol = "HTTP"
    matcher = "200"
    timeout = "3"
    path = "/health"
    unhealthy_threshold = "2"
  }
}

resource "aws_alb_listener" "airflow" {
  load_balancer_arn = aws_alb.main.id
  port = var.airflow_port
  protocol = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.airflow.id
    type = "forward"
  }
}

resource "aws_alb_target_group" "jupyter" {
  name = "jupyter-${var.user_name}"
  port = 80
  protocol = "HTTP"
  vpc_id = var.vpc_id
  target_type = "ip"

  health_check {
    healthy_threshold = "2"
    interval = "30"
    protocol = "HTTP"
    matcher = "200"
    timeout = "3"
    path = "/login"
    unhealthy_threshold = "2"
  }
}

resource "aws_alb_listener" "jupyter" {
  load_balancer_arn = aws_alb.main.id
  port = var.jupyter_port
  protocol = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.jupyter.id
    type = "forward"
  }
}
