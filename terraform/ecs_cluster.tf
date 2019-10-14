# https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-optimized_AMI.html
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
  template = file("./templates/ec2/user_data.sh.tpl")

  vars = {
    cluster_name = aws_ecs_cluster.main.name
    efs_id = aws_efs_file_system.shared_storage.id
  }
}

# https://docs.aws.amazon.com/AmazonECS/latest/developerguide/launch_container_instance.html
resource "aws_instance" "ecs" {
  ami = data.aws_ami.ecs.id
  instance_type = "t2.medium"
  subnet_id = aws_subnet.public.0.id
  associate_public_ip_address = true
  iam_instance_profile = aws_iam_instance_profile.container_instance.name
  user_data = data.template_file.ec2_user_data.rendered
  vpc_security_group_ids = [aws_security_group.container_instance.id]
}

resource "aws_ecs_cluster" "main" {
  name = "pydata-cluster"
}
