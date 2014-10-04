#
# Cookbook Name:: vellum
# Recipe:: default
#
# Copyright (C) 2013 YOUR_NAME
# 
# All rights reserved - Do Not Redistribute
#

app_name = "vellum"
app_path = "/var/www/#{app_name}"
app_config = Chef::EncryptedDataBagItem.load(app_name, "config")
ruby_ver = "2.1.2"

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

include_recipe "nodejs::npm"
nodejs_npm "bower"

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

template "#{shared_config_path}/application.yml" do
  source "application.yml.erb"
  variables(app_config: app_config.to_hash.reject { |k, v| k.to_s == "id" })
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

mysql_database "vellum_production" do
  connection ({:host => "localhost", :username => 'root', :password => node['mysql']['server_root_password']})
  action :create
end

template "#{node['nginx']['dir']}/sites-available/#{app_name}" do
  source "nginx.conf.erb"
  mode 0644
  action :create
  notifies :reload, "service[nginx]" if ::File.exists?("#{node['nginx']['dir']}/sites-enabled/#{app_name}")
  variables(
    params: {
      server_name: ["vellum.aegames.org", "vellum.hempel.sugarpond.net"],
      cert_name: "www.sugarpond.net",
      docroot: "#{app_path}/current/public",
      passenger_ruby: "#{node['rbenv']['root']}/versions/#{ruby_ver}/bin/ruby"
    }
  )
end

nginx_site app_name do
  action :enable
end