#
# Cookbook Name:: sugarpond_logrotate
# Recipe:: default
#
# Copyright (C) 2013 YOUR_NAME
# 
# All rights reserved - Do Not Redistribute
#

package "logrotate" do
  action :install
end

template "/etc/logrotate.d/nginx" do
  owner "root"
  group "root"
  mode 0644
  source "nginx.erb"
end

template "/etc/logrotate.d/rails-apps" do
  owner "root"
  group "root"
  mode 0644
  source "rails-apps.erb"
end