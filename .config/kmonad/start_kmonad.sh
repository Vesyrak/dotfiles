#!/bin/bash
#
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    *)          machine="Unhandled: ${unameOut}"
esac

echo $KBD_DEV

KBD_DEV=$(find /dev/input/by-path/*kbd* | fzf)
export KBD_DEV
echo $KBD_DEV

if [ "$machine" == "Mac" ]; then
    KBDCFG=$(envsubst < kmonad_macos.cfg)
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    KBDCFG=$(envsubst < kmonad_linux.cfg)
fi

echo $KBDCFG

kmonad <(echo "$KBDCFG")
