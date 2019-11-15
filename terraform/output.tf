output "alb" {
  value = module.shared.aws_alb_main.dns_name
}

output "db_pw" {
  value = module.shared.aws_db_instance_db.password
}