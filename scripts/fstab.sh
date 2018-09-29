#!/bin/bash

function mountArch() {
  mountUbuntu
}
function mountUbuntu() {
  sudo mkdir /media
  read -p ":: If nessecary, is your HDD already mounted on /media? [Y/n]" -r
  if [[ $REPLY =~ ^[Nn]$ ]]; then
    read -p ":: Please enter device name (e.g. /dev/sda2)"
    DRIVE=$REPLY
    print "Mounting $DRIVE"
    sudo mount $DRIVE /media
    read -p $'\x0a:: I assume you also want the drive auto-mounted? [Y/n]' -r
    if [[ $REPLY =~ ^[Yy]$ ]] || [[ $REPLY == "" ]];then
      print "Putting drive in automount."
      UUID=$(lsblk -no UUID $DRIVE)
      echo "UUID=$UUID /media ext4 acl,noatime,nofail,x-systemd.device-timeout=10 0 2" | sudo tee --append /etc/fstab > /dev/null
    fi
  fi
}

while getopts "ua" opt; do
  case $opt in
    a)
      mountArch
      ;;
    u)
      mountUbuntu
      ;;
    \?)
      print "Invalid option: -$OPTARG" >&2
      ;;
  esac
done
