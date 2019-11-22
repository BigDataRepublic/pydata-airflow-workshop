output "alb_arns" {
  value = module.shared.aws_alb_main_arns
}

output "alb_dns_names" {
  value = module.shared.aws_alb_main_dns_names
}
