#
# Cookbook Name:: sugarpond_php5
# Recipe:: default
#
# Copyright (C) 2014 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

package "php5-cgi" do
  action :install
end

package "spawn-fcgi" do
  action :install
end

template "/etc/default/php-cgi" do
  owner "root"
  group "root"
  mode 0644
  source "php-cgi"
  notifies :restart, "service[php-cgi]"
end

template "/etc/init/php-cgi.conf" do
  owner "root"
  group "root"
  mode 0644
  source "php-cgi.conf"
  notifies :restart, "service[php-cgi]"
end

service "php-cgi" do
  provider Chef::Provider::Service::Upstart
  supports :restart => true
  action :enable
end