#!/bin/bash
for f in ./scripts/core/*; do source $f; done

function atomArch() {
  todo "Installing atom in arch is not implemented yet"
}

function atomUbuntu() {
  print "Installing atom"
  curl -sL https://packagecloud.io/AtomEditor/atom/gpgkey | sudo apt-key add -
  sudo sh -c 'echo "deb [arch=amd64] https://packagecloud.io/AtomEditor/atom/any/ any main" > /etc/apt/sources.list.d/atom.list'
  sudo apt update
  sudo apt install atom
}

while getopts "ua" opt; do
  case $opt in
    a)
      atomArch
      ;;
    u)
      atomUbuntu
      ;;
    \?)
      print "Invalid option: -$OPTARG" >&2
      ;;
  esac
done
