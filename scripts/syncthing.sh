#!/bin/bash
for f in ./scripts/core/*; do source $f; done

function syncthingUbuntu()
{
    print "Installing Syncthing"
    curl -s https://syncthing.net/release-key.txt | sudo apt-key add -
    echo "deb http://apt.syncthing.net/ syncthing release" | sudo tee /etc/apt/sources.list.d/syncthing.list
    install syncthing xmlstarlet
    print "Configuring Syncthing"
    xmlstarlet ed -L -u '/configuration/gui/address' -v 0.0.0.0:8384 .config/syncthing/config.xml
    sudo systemctl enable syncthing@$USER
    sudo systemctl start syncthing@$USER
    todo "Syncthing"
    todo "Further configurations can be done by the webui"
}

syncthingUbuntu
