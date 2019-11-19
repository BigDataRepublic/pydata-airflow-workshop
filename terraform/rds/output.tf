output "vpc_id" {
  value = aws_vpc.main.id
}

output "aws_region" {
  value = var.aws_region
}

output "rds_host" {
  value = aws_db_instance.db.address
}

output "rds_port" {
  value = aws_db_instance.db.port
}

output "rds_username" {
  value = aws_db_instance.db.username
}

output "rds_password" {
  value = aws_db_instance.db.password
}

output "rds_database" {
  value = aws_db_instance.db.name
}

output "rds_security_group_id" {
  value = aws_security_group.rds.id
}
