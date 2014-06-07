#
# Cookbook Name:: gvapi
# Recipe:: default
#
# Copyright (C) 2014 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

htpasswd_data = Chef::EncryptedDataBagItem.load("gvapi", "htpasswd")
app_path = "/var/www/gvapi"
htpasswd_file = "/var/www/htpasswd.gvapi"

include_recipe "sugarpond_php5"

package "graphviz" do
  action :install
end

directory app_path do
  action :create
  owner "deploy"
  group "www-data"
  mode 0775
end

template "#{app_path}/graphviz.php" do
  source "graphviz.php"
  mode 0644
  action :create
  owner "deploy"
  group "www-data"
end

htpasswd_data['users'].each do |username, pass|
  htpasswd "gvapi user #{username}" do
    file htpasswd_file
    user username
    password pass
  end
end

template "#{node['nginx']['dir']}/sites-available/gvapi" do
  source "nginx.conf.erb"
  mode 0644
  action :create
  notifies :reload, "service[nginx]" if ::File.exists?("#{node['nginx']['dir']}/sites-enabled/gvapi")
  variables(
    params: {
      server_name: "gvapi.sugarpond.net",
      docroot: app_path,
      htpasswd_file: htpasswd_file
    }
  )
end

nginx_site "gvapi" do
  action :enable
end