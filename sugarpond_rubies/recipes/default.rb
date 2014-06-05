#
# Cookbook Name:: sugarpond_rubies
# Recipe:: default
#
# Copyright (C) 2013 YOUR_NAME
# 
# All rights reserved - Do Not Redistribute
#

#rbenv_ruby "1.8.7-p371"
rbenv_ruby "1.9.3-p547"
rbenv_ruby "2.1.2"

rbenv_gem "passenger" do
  ruby_version "2.1.2"
  version node["nginx"]["passenger"]["version"]
end

directory "#{node['rbenv']['root']}/shims" do
  action :create
  owner "rbenv"
  group "rbenv"
  mode 0775
end