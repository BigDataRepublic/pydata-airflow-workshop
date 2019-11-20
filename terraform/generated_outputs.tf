output "abacus_jupyter" {
  value = "${module.shared.aws_alb_main.dns_name}/abacus/jupyter"
}
output "abacus_airflow" {
  value = "${module.shared.aws_alb_main.dns_name}/abacus/airflow"
}

output "abdomen_jupyter" {
  value = "${module.shared.aws_alb_main.dns_name}/abdomen/jupyter"
}
output "abdomen_airflow" {
  value = "${module.shared.aws_alb_main.dns_name}/abdomen/airflow"
}