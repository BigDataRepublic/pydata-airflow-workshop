data "aws_availability_zones" "available" {}

resource "aws_vpc" "main" {
  cidr_block = "10.222.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    name = "pydata"
  }
}

# ALB requires a VPC that spans multiple availability zones
resource "aws_subnet" "public" {
  count = 2
  cidr_block = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  vpc_id = aws_vpc.main.id
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route" "internet_access" {
  route_table_id = aws_vpc.main.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.gw.id
}

# This resource provides access to S3 buckets of workshop participants from private subnets.
# It is used instead of adding a NAT gateway to give ECS tasks internet access.
# The buckets are used in the Airflow tutorial as external storage to interact with.
resource "aws_vpc_endpoint" "s3" {
  vpc_id = aws_vpc.main.id
  service_name = "com.amazonaws.${var.aws_region}.s3"
  route_table_ids = [
    aws_vpc.main.main_route_table_id]
}
