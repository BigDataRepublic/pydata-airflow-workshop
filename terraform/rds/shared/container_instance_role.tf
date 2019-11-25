data "aws_iam_policy_document" "container_instance" {
  version = "2012-10-17"
  statement {
    sid = ""
    effect = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "container_instance" {
  name = "pydata_container_instance"
  assume_role_policy = data.aws_iam_policy_document.container_instance.json
}

resource "aws_iam_policy" "container_instance" {
  name        = "pydata-container-instance"
  path        = "/"
  description = "Role for EC2 ECS container instances for pydata workshop"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecs:DeregisterContainerInstance",
        "ecs:DiscoverPollEndpoint",
        "ecs:Poll",
        "ecs:RegisterContainerInstance",
        "ecs:StartTelemetrySession",
        "ecs:Submit*",
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "container_instance" {
  role = aws_iam_role.container_instance.name
  policy_arn = aws_iam_policy.container_instance.arn
}

resource "aws_iam_instance_profile" "container_instance" {
  name = "pydata_container_instance"
  role = aws_iam_role.container_instance.name
}
