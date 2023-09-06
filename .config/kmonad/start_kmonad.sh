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


if [ "$machine" == "Mac" ]; then
    KBD_DEV=$(./list-keyboards / 2>&1 | fzf)
    export KBD_DEV
    if [ "$KBD_DEV" == "Apple Internal Keyboard / Trackpad" ]; then
        KBDCFG=$(envsubst < kmonad_macos.cfg)
    else
        KBDCFG=$(envsubst < kmonad_macos_external.cfg)
    fi
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    KBD_DEV=$(find /dev/input/by-path/*kbd* | fzf)
    export KBD_DEV
    KBDCFG=$(envsubst < kmonad_linux.cfg)
fi

kmonad <(echo "$KBDCFG")
