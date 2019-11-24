data "aws_iam_policy_document" "ecs_task" {
  version = "2012-10-17"
  statement {
    sid = ""
    effect = "Allow"
    actions = [
      "sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = [
        "ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_task" {
  name = "ecs_task_${var.user_name}"
  assume_role_policy = data.aws_iam_policy_document.ecs_task.json
}


resource "aws_iam_role_policy" "ecs_instance_s3_access" {
  role = aws_iam_role.ecs_task.id
  name = "ecs_instance_s3_access_${var.user_name}"
  policy = <<EOF
{
   "Version":"2012-10-17",
   "Statement":[
      {
         "Action":"s3:*",
         "Effect":"Allow",
         "Resource":[
            "${aws_s3_bucket.workshop.arn}",
            "${aws_s3_bucket.workshop.arn}/*"
         ]
      }
   ]
}
EOF
}
