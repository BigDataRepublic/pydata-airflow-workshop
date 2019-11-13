resource "aws_s3_bucket" "workshop" {
  bucket = "pydata-eindhoven-2019-airflow-${var.user_name}"
  force_destroy = true
  acl = "private"
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

