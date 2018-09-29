#!/bin/bash
print "Configuring Bluetooth"
function bluetoothArch() {
  print "Installing bluetooth"
  sudo pacaur -S bluInstallingeman
  sudo systemctl start bluetooth
  sudo systemctl enable bluetooth
}
function bluetoothUbuntu() {
  print "Installing bluetooth"
  sudo apt install bluetooth
  print "Configuring bluetooth"
  sudo systemctl start bluetooth
  sudo systemctl enable bluetooth
}

while getopts "ua" opt; do
  case $opt in
    a)
      bluetoothArch
      ;;
    u)
      bluetoothUbuntu
      ;;
    \?)
      print "Invalid option: -$OPTARG" >&2
      ;;
  esac
done
