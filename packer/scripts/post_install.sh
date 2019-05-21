#!/bin/bash

##
## post-install.sh
##
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin

## remove unneeded users
for USER in games news www-data list gnats irc proxy uucp lp; do
  sudo userdel -r $USER &> /dev/null
done

## disable admin user
sudo usermod -s /bin/false admin

## sort passwd and group by uid/gid
sort -n -t ':' -k3 /etc/passwd > /tmp/passwd
sort -n -t ':' -k3 /etc/group > /tmp/group
sudo mv /tmp/passwd /etc/passwd
sudo mv /tmp/group /etc/group
sudo pwconv

## motd
[[ -e /tmp/motd ]] && 
  ( sudo mv /tmp/motd /etc/motd
    sudo chown root:root /etc/motd
    sudo chmod 644 /etc/motd )

## remove dynamic motd message
sudo perl -i -pe 's/session.*pam_motd.*dynamic/#$&/' /etc/pam.d/sshd
