#
# Cookbook Name:: illyan
# Recipe:: default
#
# Copyright (C) 2013 YOUR_NAME
# 
# All rights reserved - Do Not Redistribute
#

app_config = Chef::EncryptedDataBagItem.load("illyan", "config")
ruby_ver = "1.9.3-p484"

rbenv_gem 'bundler' do
  action :install
  ruby_version ruby_ver
end

package "libxml2-dev" do
  action :install
end

package "libxslt-dev" do
  action :install
end

package "nodejs" do
  action :install
end

app_name = "illyan"
app_path = "/var/www/#{app_name}"

directory app_path do
  action :create
  owner "deploy"
  group "www-data"
  mode 0775
end

directory "#{app_path}/shared" do
  action :create
  owner "deploy"
  group "www-data"
  mode 0775
end

shared_config_path = "#{app_path}/shared/config"

directory shared_config_path do
  action :create
  owner "deploy"
  group "www-data"
  mode 0775
end

template "#{shared_config_path}/illyan.yml" do
  source "illyan.yml.erb"
  variables(
    :secret_token => app_config['secret_token'],
    :hoptoad_api_key => app_config['hoptoad_api_key']
  )
  owner "deploy"
  group "www-data"
  mode 0640
end

template "#{shared_config_path}/database.yml" do
  source "database.yml.erb"
  owner "deploy"
  group "www-data"
  mode 0640
end

mysql_database "illyan_production" do
  connection ({:host => "localhost", :username => 'root', :password => node['mysql']['server_root_password']})
  action :create
end

nginx_site app_name do
  template "nginx.conf.erb"
  docroot "#{app_path}/current/public"
  server_name ["accounts.sugarpond.net"]
  passenger_ruby "#{node['rbenv']['root']}/versions/#{ruby_ver}/bin/ruby"
  cert_name "www.sugarpond.net"
end