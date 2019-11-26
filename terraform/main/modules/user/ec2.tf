data "aws_ami" "ecs" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-*-amazon-ecs-optimized"]
  }

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
}

data "template_file" "ec2_user_data" {
  template = file("./modules/user/templates/ec2/user_data.sh.tpl")

  vars = {
    cluster_name = var.ecs_cluster.name
    user_name = var.user_name
  }
}

resource "aws_instance" "ecs" {
  ami = data.aws_ami.ecs.id
  instance_type = "t3.xlarge"

  # sorting is required to transform the set into a list, which can be indexed
  subnet_id = sort(var.subnet_ids)[0]

  associate_public_ip_address = true
  iam_instance_profile = var.iam_instance_profile_name
  user_data = data.template_file.ec2_user_data.rendered
  vpc_security_group_ids = [var.container_instance_security_group_id]
}
