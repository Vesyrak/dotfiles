#!/bin/bash

function ssdArch(){
  print "Installing required utilities"
  sudo pacman -S util-linux
    print "Enabling ssd trimming timer"
    sudo systemctl start fstrim.timer
    sudo systemctl enable fstrim.timer
}

function ssdUbuntu() {
  todo "SSD"
}

while getopts "ua" opt; do
  case $opt in
    a)
      ssdArch
      ;;
    u)
      ssdUbuntu
      ;;
    \?)
      print "Invalid option: -$OPTARG" >&2
      ;;
  esac
done
