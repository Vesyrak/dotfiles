#!/bin/bash

function delugeArch(){
  print "Installing Deluge Server"
  sudo pacaur -S python2-service-identity python2-mako deluge
  print "Configuring Deluge Server"
  sudo systemctl enable deluged
  sudo systemctl start deluged
  sudo sed -i "s/\(User*=*\).*/\1$USER/" /etc/systemd/system/deluged.service
  print "Configuring Deluge WebServer"
  stow -t ~/ deluge
  sudo cp /usr/lib/systemd/system/deluged.service /etc/systemd/system/deluged.service
  print "Creating deluge auth file"
  read -p ":: Please enter the desired username: " name
  read -p ":: Please enter the desired password: " passwd
  echo "$name : $passwd :10" >> ~/.config/deluge/auth
  sudo systemctl enable deluge-web
  confenable deluge 0

}

function delugeUbuntu() {
  print "Installing Deluge Server"
  sudo apt install deluged deluge-web deluge-console
  print "Configuring Deluge Server"
  sudo adduser --system  --gecos "Deluge Service" --disabled-password --group --home /var/lib/deluge deluge
  sudo adduser reinout deluge
  sudo cp deluge/delugeservice/etc/systemd/system/deluged.service /etc/systemd/system/deluged.service
  sudo systemctl enable deluged
  sudo systemctl start deluged
  print "Configuring Deluge WebServer"
  sudo cp deluge/delugewebservice/etc/systemd/system/deluge-web.service /etc/systemd/system/deluge-web.service
  sudo systemctl enable deluge-web
  sudo systemctl start deluge-web
  stow -t ~/ deluge
  print "Configuring Deluge Logging"
  sudo mkdir -p /var/log/deluge
  sudo chown -R deluge:deluge /var/log/deluge
  sudo chmod -R 750 /var/log/deluge

  print "Creating deluge auth file"
  read -p "Please enter the desired username: " name
  read -p "Please enter the desired password: " passwd
  echo "$name : $passwd :10" >> ~/.config/deluge/auth
  confenable deluge 0
}

while getopts "ua" opt; do
  case $opt in
    a)
    delugeArch
    ;;
    u)
    delugeUbuntu
    ;;
    \?)
    print "Invalid option: -$OPTARG" >&2
    ;;
  esac
done
