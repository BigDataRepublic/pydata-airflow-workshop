resource "postgresql_database" "user_database" {
  name = var.user_name
}

resource "postgresql_role" "user" {
  name = var.user_name
  password = "${var.user_name}-password"
  login = true
//  superuser = true
  skip_reassign_owned = true
}

resource postgresql_grant "all_tables" {
  database    = postgresql_database.user_database.name
  role        = postgresql_role.user.name
  schema      = "public"
  object_type = "table"
  privileges  = ["ALL"]
}

resource postgresql_grant "all_sequences" {
  database    = postgresql_database.user_database.name
  role        = postgresql_role.user.name
  schema      = "public"
  object_type = "sequence"
  privileges  = ["ALL"]
}
