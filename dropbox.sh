#!/bin/sh

sudo yum install -y wget
export LC_CTYPE=C
cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
nohup ~/.dropbox-dist/dropboxd &
mv /opt/stack/neutron /opt/stack/neutron_
ln -s ~/Dropbox/neutron /opt/stack/neutron

echo Feel free to use CTRL+C once your dropbox account is linked, dropboxd will
echo run in the background
tail -f nohup.out


