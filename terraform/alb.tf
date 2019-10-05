resource "aws_alb" "main" {
  name = "pydata-load-balancer"
  subnets = aws_subnet.public.*.id
  security_groups = [aws_security_group.lb.id]
}

resource "aws_alb_target_group" "airflow" {
  name = "airflow-target-group"
  port = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.main.id
  target_type = "ip"

  health_check {
    healthy_threshold = "3"
    interval = "30"
    protocol = "HTTP"
    matcher = "200"
    timeout = "3"
    path = var.airflow_health_check_path
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
  name = "jupyter-target-group"
  port = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.main.id
  target_type = "ip"

  health_check {
    healthy_threshold = "3"
    interval = "30"
    protocol = "HTTP"
    matcher = "200"
    timeout = "3"
    path = var.jupyter_health_check_path
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
