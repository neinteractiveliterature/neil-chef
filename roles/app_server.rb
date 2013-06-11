name 'app_server'
description "App server with nginx and passenger"

run_list(
  "role[debian]",
  "recipe[rbenv]",
  "recipe[rbenv::ruby_build]",
  "recipe[sugarpond_rubies]",
  "recipe[nginx]",
  "recipe[mysql]",
  "recipe[mysql::ruby]",
  "recipe[postgresql]",
  "recipe[postfix]",
  "recipe[postfix::sasl_auth]",
  "recipe[sugarpond_logrotate]"
)

override_attributes(
  "nginx" => {
    "version" => "1.4.1",
    "install_method" => "source",
    "gzip" => "on",
    "init_style" => "upstart",
    "source" => {
      "modules" => ["http_ssl_module", "passenger"]
    },
    "passenger" => {
      "version" => "4.0.5",
      "ruby" => "/opt/rbenv/versions/1.9.3-p392/bin/ruby",
      "root" => "/opt/rbenv/versions/1.9.3-p392/lib/ruby/gems/1.9.1/gems/passenger-4.0.5"
    }
  }, 
  "postfix" => {
    "smtp_sasl_auth_enable" => "yes",
    "smtp_sasl_security_options" => "noanonymous",
    "smtp_sasl_user_name" => "natbudin@gmail.com",
    "smtp_tls_cafile" => "",
    "relayhost" => "[smtp.sendgrid.net]:587",
    "smtp_use_tls" => "yes"
  },
  "users" => ['www-data', 'deploy']
)
