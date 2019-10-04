resource "aws_security_group" "lb_airflow" {
  name        = "pydata-load-balancer-airflow-security-group"
  description = "controls access to the ALB for airflow"
  vpc_id      = aws_vpc.main.id

  ingress {
    protocol    = "tcp"
    from_port   = var.airflow_port
    to_port     = var.airflow_port
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "lb_jupyter" {
  name        = "pydata-load-balancer-jupyter-security-group"
  description = "controls access to the ALB for jupyter"
  vpc_id      = aws_vpc.main.id

  ingress {
    protocol    = "tcp"
    from_port   = var.jupyter_port
    to_port     = var.jupyter_port
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "airflow" {
  name        = "pydata-ecs-airflow-security-group"
  description = "allow inbound access from the ALB only to airflow"
  vpc_id      = aws_vpc.main.id

  ingress {
    protocol        = "tcp"
    from_port       = var.airflow_port
    to_port         = var.airflow_port
    security_groups = [aws_security_group.lb_airflow.id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "jupyter" {
  name        = "pydata-ecs-jupyter-security-group"
  description = "allow inbound access from the ALB only to jupyter"
  vpc_id      = aws_vpc.main.id

  ingress {
    protocol        = "tcp"
    from_port       = var.jupyter_port
    to_port         = var.jupyter_port
    security_groups = [aws_security_group.lb_airflow.id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}