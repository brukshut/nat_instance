#!/bin/bash

##
## build_emacs.sh
##

## functions
function build_emacs() {
  [[ -d /tmp/emacs ]] && sudo rm -rf /tmp/emacs
  git clone https://github.com/brukshut/emacs /tmp/emacs
  /tmp/emacs/build_emacs.sh
  sudo rm -rf /tmp/emacs
}
## end functions

## main
build_emacs
## end main
