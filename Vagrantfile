# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "trusty64"
  #config.vm.box = "precise64"

  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  #config.vm.box_url = "http://files.vagrantup.com/precise64.box"
  config.vm.box_url = "http://cloud-images.ubuntu.com/quantal/current/quantal-server-cloudimg-vagrant-amd64-disk1.box"
  
  config.vm.provider "virtualbox" do |v|
    v.customize ["modifyvm", :id, "--memory", 1024]
  end

  # Every Vagrant virtual environment requires a box to build off of.
  #config.vm.box = "precise64-chef10.26.0"

  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  #config.vm.box_url = "http://nbudin.s3.amazonaws.com/precise64-chef10.26.0.box"

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network :forwarded_port, guest: 80, host: 8080

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network :private_network, ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network :public_network

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider :virtualbox do |vb|
  #   # Don't boot with headless mode
  #   vb.gui = true
  #
  #   # Use VBoxManage to customize the VM. For example to change memory:
  #   vb.customize ["modifyvm", :id, "--memory", "1024"]
  # end
  #
  # View the documentation for the provider you're using for more
  # information on available options.

  config.berkshelf.enabled = true
  config.omnibus.chef_version = :latest

  # Enable provisioning with chef solo, specifying a cookbooks path, roles
  # path, and data_bags path (all relative to this Vagrantfile), and adding
  # some recipes and/or roles.
  #
  # config.vm.provision :chef_solo do |chef|
  #   chef.roles_path = "roles"
  #   chef.data_bags_path = "data_bags"
  #   chef.encrypted_data_bag_secret_key_path = "encrypted_data_bag_secret"
  #   
  #   chef.json = { 
  #     :nginx => {
  #       :version => "1.4.1",
  #       :install_method => "source",
  #       :gzip => "on",
  #       :init_style => "upstart",
  #       :source => {
  #         :modules => ['http_ssl_module', 'passenger']
  #       },
  #       :passenger => {
  #         :version => "4.0.2",
  #         :ruby => "/opt/rbenv/versions/1.9.3-p392/bin/ruby",
  #         :root => "/opt/rbenv/versions/1.9.3-p392/lib/ruby/gems/1.9.1/gems/passenger-4.0.0.rc6"
  #       }
  #     },
  #     :postgresql => {
  #       :password => {
  #         :postgres => ""
  #       }
  #     },
  #     :mysql => {
  #       :server_debian_password => "debian",
  #       :server_root_password => "",
  #       :server_repl_password => "repl"
  #     },
  #     :duplicity => {
  #       :s3_bucket => "nbudin"
  #     }
  #   }
  # 
  #   chef.add_role "mysql_server"
  #   chef.add_role "postgresql_server"
  #   chef.add_role "app_server"
  # end

  config.vm.provision :chef_client do |chef|
    chef.chef_server_url = "https://api.opscode.com/organizations/sugarpond"
    chef.validation_key_path = "#{ENV["HOME"]}/.chef/sugarpond-validator.pem"
    chef.validation_client_name = "sugarpond-validator"
    chef.encrypted_data_bag_secret_key_path = "encrypted_data_bag_secret"

    chef.add_role "mysql_server"
    chef.add_role "postgresql_server"
    chef.add_role "app_server"
    chef.add_role "elasticsearch_server"
    chef.add_recipe "sugarpond_errbit"
    chef.add_recipe "journey"
    chef.add_recipe "illyan"
  end
end
