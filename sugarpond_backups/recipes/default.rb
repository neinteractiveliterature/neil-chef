aws_creds = Chef::EncryptedDataBagItem.load("aws_creds", node.chef_environment)
duplicity_secrets = Chef::EncryptedDataBagItem.load("duplicity", node.chef_environment)

package "duplicity" do
  action :install
end

backupninja_duplicity "90" do
  desturl "s3+http://#{node["duplicity"]["s3_bucket"]}/backups/#{node["hostname"]}"
  encryption_password duplicity_secrets["encryption_password"]
  aws_access_key_id aws_creds["aws_access_key_id"]
  aws_secret_access_key aws_creds["aws_secret_access_key"]
end