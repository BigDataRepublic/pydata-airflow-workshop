output "alb" {
  value = module.shared.aws_alb_main.dns_name
}