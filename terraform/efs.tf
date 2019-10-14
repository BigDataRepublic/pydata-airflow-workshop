resource "aws_efs_file_system" "shared_storage" {
  creation_token = "pydata-shared-storage"
}

resource "aws_efs_mount_target" "alpha" {
  file_system_id = aws_efs_file_system.shared_storage.id
  subnet_id = aws_subnet.public.0.id
  security_groups = [aws_security_group.efs.id]
}
