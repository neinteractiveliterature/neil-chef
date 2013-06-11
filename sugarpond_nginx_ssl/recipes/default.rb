#
# Cookbook Name:: sugarpond_nginx_ssl
# Recipe:: default
#
# Copyright (C) 2013 YOUR_NAME
# 
# All rights reserved - Do Not Redistribute
#

include_recipe 'ssl'
include_recipe 'nginx'

group node['ssl']['group'] do
  action :modify
  append true
  members node['nginx']['user']
end