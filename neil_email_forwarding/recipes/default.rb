#
# Cookbook Name:: neil_email_forwarding
# Recipe:: default
#
# Copyright (C) 2016 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

execute 'update-postfix-virtual' do
  command "postmap /etc/postfix/virtual"
  action :nothing
end

template "/etc/postfix/virtual" do
  source "virtual.erb"
  owner "root"
  group "root"
  mode 0644

  variables :virtual_map => data_bag_item('postfix', 'virtual')['aliases']

  notifies :run, "execute[update-postfix-virtual]"
end