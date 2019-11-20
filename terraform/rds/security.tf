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
