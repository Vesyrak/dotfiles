#!/bin/bash
for f in ./scripts/core/*; do source $f; done

function bluetoothUbuntu() {
  print "Installing bluetooth"
  install bluetooth
  print "Configuring bluetooth"
  sudo systemctl start bluetooth
  sudo systemctl enable bluetooth
}

bluetoothUbuntu
