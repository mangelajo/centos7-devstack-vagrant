require 'vagrant-openstack-provider'

Vagrant.configure('2') do |config|

  config.vm.box       = 'stack'
  config.vm.hostname  = 'devstack'
  config.ssh.forward_agent = true

  config.vm.provider :openstack do |os, override|
    os.server_name        = 'devstack'
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


  config.vm.provision :shell, :inline=> <<-EOF
        # install epel and juno binary stuff to be available to our devstack
        sudo yum install -y https://repos.fedorapeople.org/repos/openstack/openstack-juno/rdo-release-juno-1.noarch.rpm
        sudo yum install -y https://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm
        sudo yum install -y deltarpm
        sudo yum install -y openvswitch MySQL-python git mariadb-devel \
                            git-review python-openvswitch
        sudo yum remove -y firewalld

        # workaround to avoid later compilation problems on MySQLdb, we stick to the RDO provided one
        sudo chmod a-w /usr/lib64/python2.7/site-packages/MySQLdb* -R

        # latest and greatest dnsmasq to avoid neutron problems
        sudo yum update ftp://195.220.108.108/linux/fedora/linux/releases/21/Everything/x86_64/os/Packages/d/dnsmasq-2.72-3.fc21.x86_64.rpm
        # latest six package, to make openstack sdk client work correctly
        sudo yum update ftp://mirror.switch.ch/pool/4/mirror/fedora/linux/releases/test/21-Alpha/Workstation/armhfp/os/Packages/p/python-six-1.7.3-2.fc21.noarch.rpm
        # too many tweaks, it makes me wonder if it's going to be better to start pulling delorean packages
        sudo yum remove python-urllib3 -y
        sudo rm -rf /usr/lib/python2.7/site-packages/urllib3/packages/ssl_match_hostname
        sudo yum install ftp://mirror.switch.ch/pool/4/mirror/fedora/linux/updates/21/i386/p/python-urllib3-1.10-2.fc21.noarch.rpm
        sudo rm -rf /usr/lib/python2.7/site-packages/requests
        sudo yum install ftp://mirror.switch.ch/pool/4/mirror/fedora/linux/updates/21/i386/p/python-requests-2.5.0-3.fc21.noarch.rpm

        exit 0


  EOF


  config.vm.provision :shell, :privileged=>false,
                      :inline=> <<-EOF
        # configure ssh for no strict host checking (avoid making instalation interactive)
        grep StrictHostKeyChecking ~/.ssh/config || \
            echo -e \"Host *\n\tStrictHostKeyChecking no\n\" >> ~/.ssh/config;
        chmod 700 ~/.ssh/config;

        # personalize git, etc, anything you use for development
        [ -f /vagrant/personal_settings.sh ] && /vagrant/personal_settings.sh

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
  #specific provider sections

  config.vm.provider "parallels" do |v, override|
    override.vm.box = "parallels/centos-7.0"
    v.memory = 3024
    v.cpus = 4
    override.vm.network "private_network", ip: "192.168.33.11",
                                           dns: "8.8.8.8"
    override.vm.synced_folder "/Volumes/stack", "/opt/stack/",
                          type: 'nfs', map_uid: 'root', map_gid: 'wheel'

  end


end
