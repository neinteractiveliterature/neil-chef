name 'postgresql_server'
description "PostgreSQL server"

run_list(
  "role[debian]",
  "recipe[postgresql]",
  "recipe[postgresql::server]",
  "recipe[sugarpond_backups::postgresql]"
)

override_attributes(
  "postgresql" => {
    "password" => {
      "postgres" => ""
    }
  },
  "sugarpond_backups" => {
    "postgresql" => {
      "s3_bucket" => "nbudin"
    }
  }
)