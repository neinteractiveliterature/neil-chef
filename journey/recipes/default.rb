#
# Cookbook Name:: illyan
# Recipe:: default
#
# Copyright (C) 2013 YOUR_NAME
# 
# All rights reserved - Do Not Redistribute
#

config_data = Chef::EncryptedDataBagItem.load("journey", "config")
app_config = {"SUGAR_POND_BRANDING" => 1, "ILLYAN_URL" => "https://accounts.sugarpond.net"}.merge(config_data.to_hash)
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

package "nodejs" do
  action :install
end

package "libmagickwand-dev" do
  action :install
end

app_name = "journey"
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

directory "#{app_path}/shared/log" do
  action :create
  owner "deploy"
  group "www-data"
  mode 0775
end

file "#{app_path}/shared/log/production.log" do
  action :create
  owner "deploy"
  group "www-data"
  mode 0664
end

file "#{shared_config_path}/application.yml" do
  content(app_config.reject {|k, v| k == "id"}.to_yaml)
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

mysql_database "journey_production" do
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
      server_name: %w(journeysurveys.com www.journeysurveys.com journeysurveys.net www.journeysurveys.net journey.popper.sugarpond.net secure.journeysurveys.com secure.journeysurveys.net),
      secure_server_name: "secure.journeysurveys.com",
      cert_name: "www.sugarpond.net",
      docroot: "#{app_path}/current/public",
      passenger_ruby: "#{node['rbenv']['root']}/versions/#{ruby_ver}/bin/ruby"
    }
  )
end

nginx_site app_name do
  action :enable
end