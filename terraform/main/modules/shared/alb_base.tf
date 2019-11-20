resource "aws_alb" "main" {
  name = "pydata-bigdatarepublic"
  subnets = data.aws_subnet_ids.subnets.ids
  security_groups = [
    aws_security_group.lb.id]
}


resource "aws_alb_listener" "fixed_response" {
  load_balancer_arn = aws_alb.main.arn
  port = 80
  protocol = "HTTP"

    default_action {
    type             = "fixed-response"

    fixed_response {
        content_type = "text/plain"
        message_body = "HTTP Error 404: Please provide username"
        status_code  = 404
    }
  }
}
