#!/bin/bash -x

##
## configure_eni.sh
## wrapper script to fetch eni_ctl.sh and support files from git
##

## functions
function fetch_eni_ctl {
  cleanup
  git clone https://github.com/brukshut/eni_ctl /tmp/eni_ctl
}

function cleanup {
  [[ -d /tmp/eni_ctl ]] && sudo rm -rf /tmp/eni_ctl
}

function copy_files {
  for file in dhclient.conf interfaces eni.service; do
    [[ -e /tmp/eni_ctl/files/${file} ]] &&
      sudo cp /tmp/eni_ctl/files/${file} /tmp
  done
  for script in eni_ctl.sh add_routes.sh configure_eni.sh configure_interfaces.sh; do 
    [[ -e /tmp/eni_ctl/scripts/${script} ]] && 
      sudo cp /tmp/eni_ctl/scripts/${script} /tmp
  done
}

function configure_eni {
  fetch_eni_ctl && copy_files
  for script in configure_eni.sh configure_interfaces.sh; do
    [[ -e /tmp/${script} ]] && 
      ( sudo chmod +x /tmp/${script}
        echo "sudo /tmp/${script}" )
  done
  cleanup
}

## end functions

## main

configure_eni

## end main
