name 'elasticsearch_server'
description "ElasticSearch server"

run_list(
  "role[debian]",
  "recipe[java]",
  "recipe[elasticsearch::deb]"
)

override_attributes(
  java: {
    install_flavor: "openjdk",
    jdk_version: "7"
  },
  elasticsearch: {
    allocated_memory: "512M"
  }
)