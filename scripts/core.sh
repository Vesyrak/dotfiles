#!/bin/bash

function print() {
  echo ":: $1"
}

function todo() {
  TODO+=":: $1\n"
}

function finish() {
  print "TODO"
  echo $TODO
}

function configure(){
    print "Starting Configuring"
    arr=($CONFIG_QUEUE)
    for config in ${arr[@]}; do
        echo "$config"
        eval "$config"
    done
    print "Finished Configuring"
}

function confenable() {
  if !([ -f $CONFIG_FILE ]); then
    mkdir -p $HOME/.config/sysconf/
    touch $CONFIG_FILE
  fi
  if !(grep -q "$0 *= " $CONFIG_FILE); then
    echo "$0 $1" >> $CONFIG_FILE
  fi
}

function checkuser()
{
    if [ "$(id -un)"  != "root" ]; then
        print "Executing as regular user. Continuing."
    else
        print "Warning: running as root. Please create a new user by running createuser or su into it to continue using this script."
        exit 1
    fi
}

function createuser()
{
    read -p "Do you want to create a new user? [Y/n] " -r
    if [[ $REPLY =~ ^[Nn]$ ]]
    then
        exit 1
    fi
    echo
    read -p "Please enter the user name: " NAME
    if id -u $NAME >/dev/null 2>&1; then
        print "User already exists!"
        exit 1
    fi
    sudo useradd $NAME -m -G audio
    echo "$USER ALL=(ALL) ALL" | sudo tee --append /etc/sudoers > /dev/null
    print "Please enter preferred user passwd"
    sudo passwd $NAME
}

function checkconf()
{
    echo ":: Reading configuration"
    if !([ -f $CONFIG_FILE ]); then
        echo ":: No config file found. Make sure you run a regular install with this script."
    fi
}

function checksudo()
{
    if !(which sudo > /dev/null); then
        echo ":: Warning: sudo has to be installed before running this script."
        echo ":: Exiting"
        exit 0
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
                echo ":: WARNING: ERROR FOUND IN CONFIGURATION FILE"
                echo ":: ABORTING"
                exit 1
                ;;
        esac
    done < $CONFIG_FILE
}
