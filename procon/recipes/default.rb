#
# Cookbook Name:: procon
# Recipe:: default
#
# Copyright (C) 2014 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "docker"

app_config = Chef::EncryptedDataBagItem.load("procon", "config")

file "/etc/procon.env" do
  content(app_config.to_hash.reject {|k, v| k == "id"}.map {|k, v| "#{k}=#{v}"}.join("\n"))
  owner "root"
  mode 0600
end

mysql_database "procon_production" do
  connection ({:host => "localhost", :username => 'root', :password => node['mysql']['server_root_password']})
  action :create
end

docker_image 'nbudin/procon'

docker_container 'procon' do
  image 'nbudin/procon:v1'
  detach true
  port '5000:3000'
  env_file '/etc/procon.env'
end