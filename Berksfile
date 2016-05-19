source "https://supermarket.chef.io"

cookbook 'apt'
cookbook 'build-essential'
cookbook 'networking_basic'
cookbook 'hostname'
cookbook 'rbenv', ">= 1.5.0"
cookbook 'nginx'
cookbook 'htpasswd', github: 'Youscribe/htpasswd-cookbook'
cookbook 'mysql'
cookbook 'mysql_chef_gem'
cookbook 'postgresql'
cookbook 'php-fpm'
cookbook 'chef-client'
cookbook 'unattended-upgrades', github: "firstbanco/chef-unattended-upgrades"
cookbook 'ssl', ">= 1.0.8"
cookbook 'sudo'
cookbook 'user'
cookbook 'ufw'
cookbook 'nodejs'
cookbook 'docker'
cookbook 'git'

# needed for nginx, somehow
cookbook 'runit', "~> 1.2"
cookbook 'yum-epel', '~> 0.3'
cookbook 'yum', '~> 3.0'

group :forked do
  cookbook 'postfix', github: "nbudin/postfix"
  cookbook 'backupninja', github: "nbudin/backupninja-cookbook"
end

group :sugarpond do
  cookbook 'sugarpond_backups', path: "./sugarpond_backups"
  cookbook 'sugarpond_mysql_ssl', path: "./sugarpond_mysql_ssl"
  cookbook 'sugarpond_rubies', path: "./sugarpond_rubies"
  cookbook 'sugarpond_logrotate', path: "./sugarpond_logrotate"
  cookbook 'sugarpond_nginx_ssl', path: "./sugarpond_nginx_ssl"
end

group :neil do
  cookbook 'neil_email_forwarding', path: "./neil_email_forwarding"
end

group :apps do
  cookbook 'sugarpond_errbit', path: "./sugarpond_errbit"
  cookbook 'illyan', path: "./illyan"
  cookbook 'journey', path: "./journey"
  cookbook 'vellum', path: "./vellum"
  cookbook 'procon', path: "./procon"
end
