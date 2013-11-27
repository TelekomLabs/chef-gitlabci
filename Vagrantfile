# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  
  config.omnibus.chef_version = :latest
  config.berkshelf.enabled = true

  config.vm.provider :virtualbox do |vb|
    # Use VBoxManage to customize the VM. For example to change memory:
    vb.customize ["modifyvm", :id, "--memory", "1024"]
  end

  config.vm.define "server", primary: true do |server|
    server.vm.hostname = "gitlabci"
    server.vm.box = "precise"
    server.vm.box_url = "http://cloud-images.ubuntu.com/vagrant/precise/current/precise-server-cloudimg-amd64-vagrant-disk1.box"

    server.vm.network :forwarded_port, guest: 80, host: 8080

    server.vm.provision :chef_solo do |chef|
      chef.json = {
        :gitlabci => {
          :database_adapter => "postgresql",
          :database_password => "datapass",
          :env => "production",
          :production => {
           :gitlab => {
             :server => ["https://dev.gitlab.org/" , "https://staging.gitlab.org/"]
            }
          }
        },
        :mysql => {
          :server_root_password => "rootpass",
          :server_repl_password => "replpass",
          :server_debian_password => "debianpass"
        },
        :postgresql => {
          :password => {
            :postgres => "psqlpass"
          }
        },
      }
      chef.run_list = [
        "apt",
        "gitlabci::server"
      ]
    end
  end

  # we use raring because it has better docker support
  config.vm.define "runner", primary: true do |runner|
    runner.vm.hostname = "gitlabci"
    runner.vm.box = "raring"
    runner.vm.box_url = "http://cloud-images.ubuntu.com/vagrant/raring/current/raring-server-cloudimg-amd64-vagrant-disk1.box"

    #runner.vm.network :forwarded_port, guest: 80, host: 8080

    runner.vm.provision :chef_solo do |chef|
      chef.json = {
        :gitlabci => {
          :runner => {
            :ciserver => "https://ci.example.com",
            :ciregistrationtoken => "replaceme"
          }
        }
      }
      chef.run_list = [
        "apt",
        "gitlabci::runner"
      ]
    end
  end
end