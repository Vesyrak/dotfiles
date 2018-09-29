#!/bin/bash

function syncthingArch(){
  print "Installing Syncthing"
  sudo pacaur -S syncthing
  print "Configuring Syncthing"
  sudo systemctl enable syncthing@$USER
  sudo systemctl start syncthing@$USER
  todo "Syncthing\n"
  todo "Further configurations can be done by the webui\n"
}

function syncthingUbuntu()
{
    print "Installing Syncthing"
    curl -s https://syncthing.net/release-key.txt | sudo apt-key add -
    echo "deb http://apt.syncthing.net/ syncthing release" | sudo tee /etc/apt/sources.list.d/syncthing.list
    sudo apt-get update
    sudo apt-get install syncthing
    print "Configuring Syncthing"
    xmlstarlet ed -L -u '/configuration/gui/address' -v 0.0.0.0:8384 .config/syncthing/config.xml
    sudo systemctl enable syncthing@$USER
    sudo systemctl start syncthing@$USER
    todo "Syncthing"
    todo "Further configurations can be done by the webui"
}

while getopts "ua" opt; do
  case $opt in
    a)
      syncthingArch
      ;;
    u)
      syncthingUbuntu
      ;;
    \?)
      print "Invalid option: -$OPTARG" >&2
      ;;
  esac
done
