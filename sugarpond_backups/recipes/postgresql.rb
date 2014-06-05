include_recipe "python"
include_recipe "postgresql::server"

aws_creds = Chef::EncryptedDataBagItem.load("aws_creds", node.chef_environment)

package "lzop" do
  action :install
end

package "pv" do
  action :install
end

package "daemontools" do
  action :install
end

package "libevent-dev" do
  action :install
end

python_pip "six" do
  action :install
  version "1.6.1"
end

python_pip "WAL-E" do
  action :install
end

directory "/etc/wal-e.d/env" do
  owner "postgres"
  group "postgres"
  action :create
  recursive true
  mode 0750
end

file "/etc/wal-e.d/env/AWS_ACCESS_KEY_ID" do
  owner "postgres"
  group "postgres"
  action :create
  mode 0640
  content aws_creds["aws_access_key_id"]
end

file "/etc/wal-e.d/env/AWS_SECRET_ACCESS_KEY" do
  owner "postgres"
  group "postgres"
  action :create
  mode 0640
  content aws_creds["aws_secret_access_key"]
end

file "/etc/wal-e.d/env/WALE_S3_PREFIX" do
  owner "postgres"
  group "postgres"
  action :create
  mode 0640
  content "s3://#{node["sugarpond_backups"]["postgresql"]["s3_bucket"]}/postgres-wals/#{node["hostname"]}"
end

node.normal["postgresql"]["config"]["wal_level"] = "archive"
node.normal["postgresql"]["config"]["archive_mode"] = "on"
node.normal["postgresql"]["config"]["archive_command"] = "envdir /etc/wal-e.d/env /usr/local/bin/wal-e wal-push %p"
node.normal["postgresql"]["config"]["archive_timeout"] = 60

file "#{node["postgresql"]["dir"]}/recovery.conf" do
  owner "postgres"
  group "postgres"
  action :create
  mode 0644
  content "restore_command = 'envdir /etc/wal-e.d/env /usr/local/bin/wal-e wal-fetch \"%f\" \"%p\"'"
end

template "/etc/cron.daily/wal-e-nightly" do
  owner "root"
  group "root"
  action :create
  mode 0755
  source "wal-e-nightly.erb"
end

service :postgresql do
  action :reload
end