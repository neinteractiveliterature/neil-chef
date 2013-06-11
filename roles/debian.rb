name 'debian'
description "Basic debianish server setup"

run_list(
  "recipe[apt]",
  "recipe[build-essential]",
  "recipe[networking_basic]",
  "recipe[backupninja]",
  "recipe[sugarpond_backups]",
  "recipe[unattended-upgrades]",
  "recipe[ssl]",
  "recipe[user::data_bag]"
)

override_attributes( 
  "duplicity" => {
    "s3_bucket" => "nbudin"
  }, "backupninja" => {
    "reportemail" => "natbudin@gmail.com"
  }, "unattended-upgrades" => {
    "send_email" => true,
    "email_address" => "natbudin@gmail.com"
  }
)