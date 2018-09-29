#!/bin/bash

function airsonicArch() {
  todo "Airsonic not yet implemented"
}

function airsonicUbuntu() {
  print "Installing Airsonic"
  sudo apt install oracle-java8-jdk tomcat8 ffmpeg
  wget https://github.com/airsonic/airsonic/releases/download/v10.1.2/airsonic.war
  print "Configuring Airsonic"
  sudo sed -i 's/\(JAVA_HOME=\).*/\1/' /etc/default/config
  sudo sed -i '/^JAVA_HOME=/ s/$/'java-8-oracle'/' /etc/default/config
  sudo mkdir /var/airsonic/
  sudo chown -R tomcat8:tomcat8 /var/airsonic/
  sudo systemctl stop tomcat8.service
  sudo rm /var/lib/tomcat8/webapps/airsonic.war
  sudo rm -R /var/lib/tomcat8/webapps/airsonic/
  sudo rm -R /var/lib/tomcat8/work/*
  sudo mv airsonic.war /var/lib/tomcat8/webapps/airsonic.war
  sudo mkdir /var/airsonic/transcode
  cd /var/airsonic/transcode/
  sudo ln -s /usr/bin/ffmpeg
  sudo chown -R tomcat8:tomcat8 /var/airsonic
  sudo systemctl start tomcat8.service
}

while getopts "ua" opt; do
  case $opt in
    a)
      airsonicArch
      ;;
    u)
      airsonicUbuntu
      ;;
    \?)
      print "Invalid option: -$OPTARG" >&2
      ;;
  esac
done
