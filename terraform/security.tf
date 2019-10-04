resource "aws_security_group" "lb" {
  name = "pydata-load-balancer-airflow-security-group"
  description = "controls access to the ALB"
  vpc_id = aws_vpc.main.id

  ingress {
    protocol = "tcp"
    from_port = var.airflow_port
    to_port = var.airflow_port
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol = "tcp"
    from_port = var.jupyter_port
    to_port = var.jupyter_port
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol = "-1"
    from_port = 0
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ecs" {
  name = "pydata-ecs-security-group"
  description = "allow inbound access from the ALB only"
  vpc_id = aws_vpc.main.id

  ingress {
    protocol = "tcp"
    from_port = var.airflow_port
    to_port = var.airflow_port
    security_groups = [aws_security_group.lb.id]
  }

  ingress {
    protocol = "tcp"
    from_port = var.jupyter_port
    to_port = var.jupyter_port
    security_groups = [aws_security_group.lb.id]
  }

  egress {
    protocol = "-1"
    from_port = 0
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
