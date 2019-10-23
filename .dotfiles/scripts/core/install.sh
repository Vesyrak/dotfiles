#!/bin/bash

function install()
{
  sudo apt update
  sudo apt install -y $@
}

function snapinstall() {
  sudo snap install $@
}

function validate_command() {
  (eval $1) >> /dev/null
  if [[ $? != 0 ]]; then
    print $2
    exit 1
  fi
}
