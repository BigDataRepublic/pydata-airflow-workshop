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
    path = "/tree"
    unhealthy_threshold = "2"
  }
}

resource "aws_alb_listener" "jupyter" {
  load_balancer_arn = var.aws_alb_main_id
  port = var.jupyter_visit_port
  protocol = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.jupyter.id
    type = "forward"
  }
}


resource "aws_alb_listener" "airflow" {
  load_balancer_arn = var.aws_alb_main_id
  port = var.airflow_visit_port
  protocol = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.airflow.id
    type = "forward"
  }
}


//resource "aws_alb_listener" "jupyter_redirect" {
//  load_balancer_arn = var.aws_alb_main_id
//  port = 8888
//  protocol = "HTTP"
//
//  default_action {
//    target_group_arn = aws_alb_target_group.jupyter.id
//    type = "forward"
//  }
//}

//
//
//resource "aws_lb_listener_rule" "jupyter" {
//  listener_arn = "${aws_alb_listener.jupyter_redirect.arn}"
//  priority     = 100
//
//  action {
//    type             = "forward"
//    target_group_arn = aws_alb_target_group.jupyter.id
//  }
//
//  condition {
//    field  = "path-pattern"
//    values = ["/${var.user_name}/*"]
//  }
//}
//
