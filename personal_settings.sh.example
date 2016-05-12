#!/bin/sh
cd ~

#PROXY_URI=http://192.168.1.144:3128

#echo export http_proxy=$PROXY_URI | sudo tee -a /etc/profile
#echo export https_proxy=$PROXY_URI | sudo tee -a /etc/profile
#echo export ftp_proxy=$PROXY_URI | sudo tee -a /etc/profile
#echo proxy=$PROXY_URI | sudo tee -a /etc/yum.conf

#source /etc/profile

# fix a mirror to make proxy caching help..
#sudo sed -i \
#     's/#baseurl=http:\/\/mirror.centos.org\/centos/baseurl=http:\/\/centos.mirror.xtratelecom.es/g' \
#        /etc/yum.repos.d/*.repo
#sudo sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/*.repo
#sudo sed -i 's/#mirrorlist/mirrorlist/g' /etc/yum.repos.d/*epel*.repo
#sudo sed -i 's/enabled=1/enabled=0/g' /etc/yum/pluginconf.d/fastestmirror.conf


#sudo yum remove -y epel-release
sudo yum install -y epel-release
sudo yum install -y vim vim-enhanced ctags unzip python-flake8

# colorify my prompt
#cp /vagrant/bashrc_prompt ~/.bashrc_prompt
#echo source ~/.bashrc_prompt >~/.bashrc

# go vim go!,
git clone https://github.com/mangelajo/vim-settings
cd vim-settings
echo installing VIM plugins...
./install.sh 2>/dev/null >/dev/null
cd ..

chmod og-rwx ~/.ssh/*

git config --global gitreview.username mangelajo
git config --global user.name "Miguel Angel Ajo"
git config --global user.email "mangelajo@redhat.com"
git config --global core.editor vim

