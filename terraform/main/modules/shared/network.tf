data "aws_vpc" "main" {
  id = var.vpc_id
}

data "aws_subnet_ids" "subnets" {
  vpc_id = var.vpc_id
}

# This resource provides access to S3 buckets of workshop participants from private subnets.
# It is used instead of adding a NAT gateway to give ECS tasks internet access.
# The buckets are used in the Airflow tutorial as external storage to interact with.
resource "aws_vpc_endpoint" "s3" {
  vpc_id = data.aws_vpc.main.id
  service_name = "com.amazonaws.${var.aws_region}.s3"
  route_table_ids = [
    data.aws_vpc.main.main_route_table_id]
}
