name 'postgresql_server'
description "PostgreSQL server"

run_list(
  "role[debian]",
  "recipe[postgresql]",
  "recipe[postgresql::server]"
)

override_attributes "postgresql" => {
  "password" => {
    "postgres" => ""
  }
}