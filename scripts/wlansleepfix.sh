#!/bin/bash
function sleepFixArch() {
  print "Making sure the Wi-Fi connection doesn't sleep"
  sudo stow -t / WLanPOFix
  confenable WLanPOFix 1
}

function sleepFixUbuntu() {
  todo "Sleepfix is not yet implemented in ubuntu"
}

while getopts "ua" opt; do
  case $opt in
    a)
    sleepFixArch
    ;;
    u)
    sleepFixUbuntu
    ;;
    \?)
    print "Invalid option: -$OPTARG" >&2
    ;;
  esac
done
