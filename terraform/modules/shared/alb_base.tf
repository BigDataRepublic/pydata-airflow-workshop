resource "aws_alb" "main" {
  name = "pydata-bigdatarepublic"
  subnets = var.subnets.*.id
  security_groups = [
    var.load_balancer_security_group_id]
}