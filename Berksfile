chef_api :config
site :opscode

cookbook 'apt'
cookbook 'build-essential'
cookbook 'networking_basic'
cookbook 'rbenv'
cookbook 'nginx', github: "brandonmartin/nginx", branch: "COOK-2622"
cookbook 'mysql'
cookbook 'postgresql'
cookbook 'chef-client'
cookbook 'unattended-upgrades', github: "firstbanco/chef-unattended-upgrades"
cookbook 'ssl', github: "cap10morgan/ssl-cookbook"
cookbook 'user'

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

group :apps do
  cookbook 'sugarpond_errbit', path: "./sugarpond_errbit"
  cookbook 'illyan', path: "./illyan"
end