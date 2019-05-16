#!/bin/bash

##
## enable ip masquerading
##
PATH=/bin:/sbin:/usr/bin:/usr/sbin

## functions
function die { echo "$*" 1>&2 && exit 1; }

function kernel_flags {
  ## device should already be plumbed
  local device=$1
  echo "${0}: enabling ip forwarding"
  sysctl -q -w net.ipv4.ip_forward=1
  sysctl net.ipv4.conf.${device}.send_redirects &&
    sysctl -q -w net.ipv4.conf.${device}.send_redirects=0 || die
}
    
function masquerade {
  local device=$1
  echo "${0}: enabling ip masquerading"
  ( iptables -t nat -C POSTROUTING -o ${device} -j MASQUERADE 2> /dev/null ||
    iptables -t nat -A POSTROUTING -o ${device} -j MASQUERADE ) ||
    die "${FUNCNAME[0]}: something went wrong with ip masquerading."
}

function usage { printf "%s\n" "Usage: $0 -d [device]" ; exit 1; }
## end functions

## main
while getopts "d:" opt; do
  case $opt in
    d) DEVICE=${OPTARG}
       kernel_flags $DEVICE && masquerade ${DEVICE} || die
      ;;
    *) usage
      ;;
  esac
done

## require device
[[ -z ${DEVICE} ]] && usage
## end main
