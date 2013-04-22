name 'debian'
description "Basic debianish server setup"

run_list(
  "recipe[apt]",
  "recipe[build-essential]",
  "recipe[networking_basic]"
)