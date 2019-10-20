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
    efs_id = var.efs_id
    user_name = var.user_name
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDeUq9TmFqiBrUj/vgOzCUmKe3Eqt6nSZRsDPQEdXQmVakznlHUC9tWyduY6yhnXrYApQhIFmSw5SM6M+LRlzfRqSD8pmRPPa1pbUbWjX3ui5gRb82W1Y8jUyYde+/8MSnCNTMFBlL/9MEOK7UuvUE5boAQ4jM/NakWhxcbc9TqCcgHNdcK1eAAs6dEUM63nKHQNr7lV6DC+2hpracDUC0MOps6bIbBPVTnw/4vH/hu4JDUAfE/LW3dD07mmn6H+bYlCToOB0o9ohXCMhSY1Yd6zehMip123Q3JBHWY6GuDG7uehdqx1svvF2wDtoSk+zm8G1wBIduNPyVaSLQlnOljwJ8L7ULrEYC8OwM+1NALPvU6Ou4kh1I5SCtNkDmAVI89Y1FLNEe9dOhe1rUHwKDCF2M07jS2SIaBPd7ZpYNNGc5gwPUEmfoC+gieFM56/FMw1VD9Lbmnk/7ZtDEYQrpF4CNtevJ/n72Djbpw+kzaBmULmTIavLUyT8iLNU8EUycp8Ke9MFwrhzPvp4C8jLr65o/e7cwbm5oFkRkLPWTb5lUwIRGoZqdC1jZ1NLSlQphd5t9EM5ICwyzp3pVAeO0BK8DMCxwlDpQSl66KGmoTyN791AlNoO1ml/uU/pfLguhIVNzEjUxNhw33pUq75zg1yRsZkk9QX7niuINbTe563w== axel.goblet@bigdatarepublic.nl"
}

resource "aws_instance" "ecs" {
  ami = data.aws_ami.ecs.id
  instance_type = "t2.medium"
  subnet_id = var.subnets.0.id
  associate_public_ip_address = true
  iam_instance_profile = var.iam_instance_profile_name
  user_data = data.template_file.ec2_user_data.rendered
  vpc_security_group_ids = [var.container_instance_security_group_id]
  key_name = aws_key_pair.deployer.key_name
}
