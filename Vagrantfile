# -*- mode: ruby -*-
# vi: set ft=ruby :
BOX_LOCATION = "http://files.vagrantup.com/precise32.box"
IP_ADDR = "192.168.1.150"
ADAPTER = "en0: Wi-Fi (AirPort)"

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "precise32"

  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  config.vm.box_url = BOX_LOCATION
 
  # Kick off bootstrap script
  config.vm.provision :shell, :path => "bootstrap.sh"

  # Enable symlinks
  config.vm.provider "virtualbox" do |v|
    ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/v-root", "1"]
  end

  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  config.vm.box_url = IP_ADDR

  # Configure the network
  config.vm.network :public_network, ip: IP_ADDR, bridge: ADAPTER

  # Set up a shared folder.
  config.vm.synced_folder "shared/", "/home/vagrant/shared", owner: "vagrant", group: "www-data", mount_options: ["dmode=755,fmode=755"]

end