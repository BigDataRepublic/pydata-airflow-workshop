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

resource "aws_alb_listener" "airflow" {
  load_balancer_arn = var.aws_alb_main_arn
  port = var.airflow_visit_port
  protocol = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.airflow.id
    type = "forward"
  }
}

resource "aws_lb_listener_rule" "airflow" {
  listener_arn = var.aws_alb_listener_fixed_response_arn
  priority = var.airflow_visit_port

  action {
    type = "redirect"
    redirect {
      host = "#{host}"
      port = aws_alb_listener.airflow.port
      path = "/"
      protocol = "HTTP"
      status_code = "HTTP_302"
    }
  }

  condition {
    field = "path-pattern"
    values = ["/${var.user_name}/airflow"]
  }
}

resource "aws_alb_listener" "jupyter" {
  load_balancer_arn = var.aws_alb_main_arn
  port = var.jupyter_visit_port
  protocol = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.jupyter.id
    type = "forward"
  }
}

resource "aws_lb_listener_rule" "jupyter" {
  listener_arn = var.aws_alb_listener_fixed_response_arn
  priority = aws_alb_listener.jupyter.port

  action {
    type = "redirect"
    redirect {
      host = "#{host}"
      port = aws_alb_listener.jupyter.port
      path = "/"
      protocol = "HTTP"
      status_code = "HTTP_302"
    }
  }

  condition {
    field = "path-pattern"
    values = ["/${var.user_name}/jupyter"]
  }
}
