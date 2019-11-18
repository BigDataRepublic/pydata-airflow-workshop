output "vpc_id" {
  value = aws_vpc.main.id
}

output "rds_id" {
  value = aws_db_instance.db.id
}
