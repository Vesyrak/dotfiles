#!/bin/bash
for f in ./scripts/core/*; do source $f; done

function etcherUbuntu() {
  print "Instaling etcher"
  echo "deb https://deb.etcher.io stable etcher" | sudo tee /etc/apt/sources.list.d/balena-etcher.list
  sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 379CE192D401AB61
  install balena-etcher-electron
}

etcherUbuntu
