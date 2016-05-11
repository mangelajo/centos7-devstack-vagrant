require 'vagrant-openstack-provider'

VM_MEMORY=6000
VM_CPUS=4

Vagrant.configure('2') do |config|

  config.vm.box       = 'stack'
  config.vm.hostname  = 'devstack'
  config.ssh.forward_agent = true

  config.vm.provision :shell, :privileged=>true, :inline=> <<-EOF
        sudo yum install -y epel-release git git-review
        sudo yum remove -y firewalld
        exit 0
  EOF


  config.vm.provision :shell, :privileged=>false,
                      :inline=> <<-EOF
        # configure ssh for no strict host checking (avoid making instalation interactive)
        grep StrictHostKeyChecking ~/.ssh/config 2>/dev/null || \
            echo -e \"Host *\n\tStrictHostKeyChecking no\n\" >> ~/.ssh/config;
        chmod 700 ~/.ssh/config;

        # personalize git, etc, anything you use for development
        [ -f /vagrant/personal_settings.sh ] && /vagrant/personal_settings.sh
        source /etc/profile

        git clone https://git.openstack.org/openstack-dev/devstack
        cd devstack

        # link the personal config, otherwise the example one (in git)
        if [ -f /vagrant/local.conf ]; then
            ln -s /vagrant/local.conf local.conf
        else
            ln -s /vagrant/local.conf.example local.conf
        fi

        ./unstack.sh
        ./stack.sh
  EOF

  #############################################################################
  # specific provider sections                                                #
  #############################################################################

  config.vm.box       = 'bento/centos-7.1'
  config.vm.provider :virtualbox do |v|
    v.memory = VM_MEMORY
    v.cpus = VM_CPUS
  end

  config.vm.provider "parallels" do |v, override|
    override.vm.box = "parallels/centos-7.1"
    v.memory = VM_MEMORY
    v.cpus = VM_CPUS
    v.customize ["set", :id, "--nested-virt", "on"]
  end

  config.vm.provider :openstack do |os, override|
    os.server_name        = 'rdo-kilo'
    os.openstack_auth_url = "#{ENV['OS_AUTH_URL']}/tokens"
    os.username           = "#{ENV['OS_USERNAME']}"
    os.password           = "#{ENV['OS_PASSWORD']}"
    os.tenant_name        = "#{ENV['OS_TENANT_NAME']}"
    os.flavor             = ['oslab.4cpu.20hd.8gb', 'm1.large']
    os.image              = ['centos7', 'centos-7-cloud']
    os.floating_ip_pool   = ['external', 'external-compute01']
    os.user_data          = <<-EOF
#!/bin/bash
sed -i 's/Defaults    requiretty/Defaults    !requiretty/g' /etc/sudoers
    EOF
    override.ssh.username = 'centos'
  end

   config.vm.provider :libvirt do |libvirt, config|
	config.vm.box = "centos/7"
	config.vm.synced_folder './', '/vagrant', type: 'rsync'
	libvirt.nested = true 
	libvirt.cpus = VM_CPUS
        libvirt.memory = VM_MEMORY
        libvirt.suspend_mode = 'managedsave'
   end
end
