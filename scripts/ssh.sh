#!/bin/bash
for f in ./scripts/core/*; do source $f; done

function sshArch()
{
    print  "Enabling sshd"
    sudo systemctl enable sshd
    sudo systemctl start sshd
    sudo ln -sf $PWD/ssh/etc/ssh/* /etc/ssh/
    sudo systemctl restart sshd
    confenable ssh 2
}

function sshUbuntu() {
  todo "Ssh setting is skipped in ubuntu"
  todo "To re-enable this, you need to re-check existing configuration"
}


while getopts "ua" opt; do
  case $opt in
    a)
      sshArch
      ;;
    u)
      sshUbuntu
      ;;
    \?)
      print "Invalid option: -$OPTARG" >&2
      ;;
  esac
done
