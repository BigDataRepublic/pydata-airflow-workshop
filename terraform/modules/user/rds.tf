
resource "postgresql_database" "user_database" {
  name = var.user_name
}

resource "postgresql_role" "user" {
  name = var.user_name
  password = var.user_name
  login = true
}