resource "aws_cloudwatch_log_group" "log_group" {
  name = var.log_group
  retention_in_days = 30

  tags = {
    Name = "pydata-log-group"
  }
}

resource "aws_cloudwatch_log_stream" "log_stream" {
  name = "pydata-log-stream"
  log_group_name = aws_cloudwatch_log_group.log_group.name
}
