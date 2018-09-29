#!/bin/bash

function checksudo()
{
    if !(which sudo > /dev/null); then
        echo ":: Warning: sudo has to be installed before running this script."
        echo ":: Exiting"
        exit 0
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
