#!/bin/bash
print "Instaling etcher"
function etcherArch(parameter) {
  todo "Etcher is not yet implemented for Arch"
}

function etcherUbuntu() {
  echo "deb https://dl.bintray.com/resin-io/debian stable etcher" | sudo tee /etc/apt/sources.list.d/etcher.list
  sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 379CE192D401AB61
  sudo apt-get update
  sudo apt-get install etcher-electron
}

while getopts "ua" opt; do
  case $opt in
    a)
      etcherArch
      ;;
    u)
      etcherUbuntu
      ;;
    \?)
      print "Invalid option: -$OPTARG" >&2
      ;;
  esac
done
