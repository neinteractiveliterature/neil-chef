name 'mysql_server'
description "MySQL server"

run_list(
  "role[debian]",
  "recipe[mysql]",
  "recipe[mysql::server]"
)

override_attributes "mysql" => {
  "server_root_password" => ""
}