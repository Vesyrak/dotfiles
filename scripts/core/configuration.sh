#!/bin/bash

function confenable() {
  if !([ -f $CONFIG_FILE ]); then
    mkdir -p $HOME/.config/sysconf/
    touch $CONFIG_FILE
  fi
  if !(grep -q "$0 *= " $CONFIG_FILE); then
    echo "$0 $1" >> $CONFIG_FILE
  fi
}

function config()
{
    print "Installing Config Files"
    print "Installing XResources"
    mkdir -p ~/.config/xresources/
    stow -t ~/ Xresources
  #  stow -t ~/ xprofile
    confenable Xresources 0
  #  confenable xprofile 0
    print "Installing Vim"
    stow -t ~/ vim
    confenable vim 0
}

function checkconf()
{
    print "Reading configuration"
    if !([ -f $CONFIG_FILE ]); then
        print "No config file found. Make sure you run a regular install with this script."
    fi
}

function restow(){
    checkconf
    while read config sudo; do
        case "$sudo" in
            "0")
                stow -R -t ~/ $config
                ;;
            "1")
                sudo stow -R -t / $config
                ;;
            "2")
                for DIR in $(find . -type f -name '*f*' | sed -r 's|/[^/]+$||' | sort -u); do
                    sudo ln $config/$DIR/* $DIR/
                done
                ;;
            *)
                print "WARNING: ERROR FOUND IN CONFIGURATION FILE"
                print "ABORTING"
                exit 1
                ;;
        esac
    done < $CONFIG_FILE
}
