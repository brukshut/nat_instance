#!/bin/bash

##
## install_packages.sh
##
PATH=/bin:/sbin:/usr/bin:/usr/sbin
DEBIAN_FRONTEND=noninteractive

## update and upgrade
sudo apt-get update -y
sudo apt-get upgrade -y

## useful packages
sudo apt-get install build-essential -y
sudo apt-get install curl -y
sudo apt-get install git -y
sudo apt-get install jq -y
sudo apt-get install keychain -y
sudo apt-get install lsof -y
sudo apt-get install netcat -y
sudo apt-get install nmap -y
sudo apt-get install rsync -y
sudo apt-get install vim -y
sudo apt-get install wget -y

## for emacs
sudo apt-get install libtinfo-dev -y
