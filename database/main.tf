resource "terraform_data" "database" {
  input = "3"
}

resource "terraform_data" "read_replica" {
  input = "db.r6g.large"
}
