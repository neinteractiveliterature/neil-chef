#
# Cookbook Name:: illyan
# Recipe:: default
#
# Copyright (C) 2013 YOUR_NAME
# 
# All rights reserved - Do Not Redistribute
#

app_config = Chef::EncryptedDataBagItem.load("journey", "config")
ruby_ver = "2.0.0-p353"

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
server_names = %w(journeysurveys.com www.journeysurveys.com journeysurveys.net www.journeysurveys.net journey.popper.sugarpond.net secure.journeysurveys.com secure.journeysurveys.net)
secure_server_name = "secure.journeysurveys.com"
ssl_redirect_servers = ["secure.journeysurveys.net"]

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

template "#{shared_config_path}/journey.yml" do
  source "journey.yml.erb"
  variables(
    :secret_token => app_config['secret_token'],
    :airbrake_api_key => app_config['airbrake_api_key'],
    :illyan_token => app_config['illyan_token']
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

mysql_database "journey_production" do
  connection ({:host => "localhost", :username => 'root', :password => node['mysql']['server_root_password']})
  action :create
end

template "#{node['nginx']['dir']}/sites-available/#{app_name}" do
  mode 0644  
  source "nginx.conf.erb"
  variables(
    {
      :root => "#{app_path}/current/public",
      :server_names => server_names,
      :secure_server_name => secure_server_name,
      :ssl_redirect_servers => ssl_redirect_servers,
      :passenger_ruby => "#{node['rbenv']['root']}/versions/#{ruby_ver}/bin/ruby"
    }
  )
  notifies :restart, resources(:service => "nginx")
end

nginx_site app_name do
end