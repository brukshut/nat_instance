#!/bin/bash -x

##
## configure_nat.sh
##
PATH=/bin:/sbin:/usr/bin:/usr/sbin
DEBIAN_FRONTEND=noninteractive

## install iptables-persistent
echo iptables-persistent iptables-persistent/autosave_v4 boolean true | sudo debconf-set-selections
echo iptables-persistent iptables-persistent/autosave_v6 boolean true | sudo debconf-set-selections
sudo apt-get install iptables-persistent -y

## masquerade.sh
[[ -e /tmp/masquerade.sh ]] && 
  ( sudo mv /tmp/masquerade.sh /usr/local/sbin
    sudo chown root:root /usr/local/sbin/masquerade.sh
    sudo chmod 0755 /usr/local/sbin/masquerade.sh )
