resource "aws_security_group" "rds" {
  name = "pydata-rds"
  description = "limits RDS access to ECS tasks only"
  vpc_id = aws_vpc.main.id
  ingress {
    protocol = "-1"
    from_port = 0
    to_port = 0
    cidr_blocks = [
      "0.0.0.0/0"]
  }
}

resource "aws_security_group" "lb" {
  name = "pydata-airflow"
  description = "controls access to the ALB"
  vpc_id = aws_vpc.main.id

  ingress {
    protocol = "-1"
    from_port = 0
    to_port = 0
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  egress {
    protocol = "-1"
    from_port = 0
    to_port = 0
    cidr_blocks = [
      "0.0.0.0/0"]
  }
}

resource "aws_security_group" "ecs" {
  name = "pydata-ecs-task"
  description = "allow inbound access from the ALB only"
  vpc_id = aws_vpc.main.id

  ingress {
    protocol = "tcp"
    from_port = var.airflow_port
    to_port = var.airflow_port
    security_groups = [
      aws_security_group.lb.id]
  }

  ingress {
    protocol = "tcp"
    from_port = var.jupyter_port
    to_port = var.jupyter_port
    security_groups = [
      aws_security_group.lb.id]
  }

  egress {
    protocol = "-1"
    from_port = 0
    to_port = 0
    cidr_blocks = [
      "0.0.0.0/0"]
  }
}

resource "aws_security_group" "container_instance" {
  name = "pydata-container-instance"
  description = "only allow egress for EC2 instances"
  vpc_id = aws_vpc.main.id

  egress {
    protocol = "-1"
    from_port = 0
    to_port = 0
    cidr_blocks = [
      "0.0.0.0/0"]
  }
}
