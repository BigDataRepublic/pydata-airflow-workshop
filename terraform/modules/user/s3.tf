resource "aws_s3_bucket" "workshop" {
  bucket = "pydata-eindhoven-2019-airflow-${var.user_name}"
  force_destroy = true
  acl = "public-read-write"
}

variable "training_data_file_path" {
  default = "./modules/user/files/s3/iris.csv"
}

resource "aws_s3_bucket_object" "raw_training_data" {
  bucket = aws_s3_bucket.workshop.bucket
  key = "raw_training_data.csv"
  source = var.training_data_file_path
  etag = filemd5(var.training_data_file_path)
  acl = "public-read"
}

resource "aws_s3_bucket_policy" "b" {
  bucket = aws_s3_bucket.workshop.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "PublicReadGetObject",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::pydata-eindhoven-2019-airflow-abacus/*"
     }
  ]
}
POLICY
}
