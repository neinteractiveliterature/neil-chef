#
# Cookbook Name:: sugarpond_mysql_ssl
# Recipe:: default
#
# Copyright (C) 2013 YOUR_NAME
# 
# All rights reserved - Do Not Redistribute
#

include_recipe "ssl"

cert_name = "www.sugarpond.net"

orig_ca_file = File.join(node['ssl']['certs_dir'], "#{cert_name}.chain.crt")
orig_cert_file = File.join(node['ssl']['certs_dir'], "#{cert_name}.crt")
orig_key_file = File.join(node['ssl']['keys_dir'], "#{cert_name}.key")

ssl_dir = node['mysql']['conf_dir']
ca_file = File.join(ssl_dir, "#{cert_name}-ca.pem")
cert_file = File.join(ssl_dir, "#{cert_name}-cert.pem")
key_file = File.join(ssl_dir, "#{cert_name}-key.pem")

execute "copy_ssl_certs_and_key" do
  command "cp #{orig_ca_file} #{ca_file} && cp #{orig_cert_file} #{cert_file} && cp #{orig_key_file} #{key_file}"
end

file ca_file do
  owner "mysql"
  group node['mysql']['root_group']
  mode 0644
end

file cert_file do
  owner "mysql"
  group node['mysql']['root_group']
  mode 0644
end

file key_file do
  owner "mysql"
  group node['mysql']['root_group']
  mode 0600
end

template "#{node['mysql']['confd_dir']}/ssl.cnf" do
  owner "root"
  group node['mysql']['root_group']
  mode "0644"
  source "ssl.cnf.erb"
  notifies :reload, "service[mysql]", :immediately
  variables :cert_file => cert_file, :key_file => key_file, :ca_file => ca_file
  
  only_if { File.exists?(ca_file) && File.exists?(cert_file) && File.exists?(key_file) }
end