resource "aws_db_instance" "db" {
  allocated_storage = 20
  engine = "postgres"
  instance_class = "db.t2.micro"
  name = "airflow"
  port = 5432
  password = "airflow1234"
  username = "airflow"
  db_subnet_group_name = aws_db_subnet_group.vpc.name
  skip_final_snapshot = true
  vpc_security_group_ids = [var.rds_security_group_id]
}

resource "aws_db_subnet_group" "vpc" {
  name = "pydata-${var.user_name}}"
  subnet_ids = var.subnets.*.id
}
