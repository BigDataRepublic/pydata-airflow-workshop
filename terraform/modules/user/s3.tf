resource "aws_s3_bucket" "workshop" {
  bucket = "pydata-eindhoven-2019-airflow-${var.user_name}"
  force_destroy = true
  acl = "public-read-write"
}

variable "training_data_file_path" {
  default = "./modules/user/files/s3/raw_training_data.csv"
}

resource "aws_s3_bucket_object" "raw_training_data" {
  bucket = aws_s3_bucket.workshop.bucket
  key = "raw_training_data.csv"
  source = var.training_data_file_path
  etag = filemd5(var.training_data_file_path)
  acl = "public-read"
}

variable "unlabeled_data_file_path" {
  default = "./modules/user/files/s3/raw_unlabeled_data.csv"
}

resource "aws_s3_bucket_object" "raw_unlabeled_data" {
  bucket = aws_s3_bucket.workshop.bucket
  key = "raw_unlabeled_data.csv"
  source = var.unlabeled_data_file_path
  etag = filemd5(var.unlabeled_data_file_path)
  acl = "public-read"
}

resource "aws_s3_bucket_policy" "b" {
  bucket = aws_s3_bucket.workshop.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "pydata-policy-${var.user_name}",
  "Statement": [
    {
      "Sid": "PublicReadGetObject-${var.user_name}",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::pydata-eindhoven-2019-airflow-abacus/*"
     }
  ]
}
POLICY
}