#
# Cookbook Name:: sugarpond_errbit
# Recipe:: default
#
# Copyright (C) 2013 YOUR_NAME
# 
# All rights reserved - Do Not Redistribute
#

mongodb = Chef::EncryptedDataBagItem.load("sugarpond_errbit", "mongodb")
secret_token = Chef::EncryptedDataBagItem.load("sugarpond_errbit", "secret_token")
ruby_ver = "1.9.3-p547"

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

app_name = "sugarpond_errbit"
app_path = "/var/www/#{app_name}"
server_names = ["errbit.sugarpond.net"]

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

template "#{shared_config_path}/config.yml" do
  source "config.yml.erb"
  variables(
    :host => server_names.first,
    :app_path => app_path
  )
  owner "deploy"
  group "www-data"
  mode 0640
end

template "#{shared_config_path}/mongoid.yml" do
  source "mongoid.yml.erb"
  variables(
    :host => mongodb["host"],
    :port => mongodb["port"],
    :username => mongodb["username"],
    :password => mongodb["password"],
    :database => mongodb["database"]
  )
  owner "deploy"
  group "www-data"
  mode 0640
end

directory "#{shared_config_path}/initializers" do
  action :create
  owner "deploy"
  group "www-data"
  mode 0775
end

template "#{shared_config_path}/initializers/secret_token.rb" do
  source "secret_token.rb.erb"
  variables(
    :secret_token => secret_token["secret_token"]
  )
  owner "deploy"
  group "www-data"
  mode 0640
end

template "#{node['nginx']['dir']}/sites-available/#{app_name}" do
  source "nginx.conf.erb"
  mode 0644
  action :create
  notifies :reload, "service[nginx]" if ::File.exists?("#{node['nginx']['dir']}/sites-enabled/#{app_name}")
  variables(
    params: {
      server_name: server_names,
      docroot: "#{app_path}/current/public",
      passenger_ruby: "#{node['rbenv']['root']}/versions/#{ruby_ver}/bin/ruby"
    }
  )
end

nginx_site app_name do
  action :enable
end