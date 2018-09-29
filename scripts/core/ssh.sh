#!/bin/bash
. ./scripts/core/formatting.sh

function sshclient()
{
    mkdir ~/.ssh/sockets/ -p
    touch ~/.ssh/config
    read -p ":: What is the server's IP address? " IP
    if [ -z "$1" ]; then
        read -p ":: And how do you want to call the server? " NAME
    else
        NAME="$1"
    fi
    echo "Host $NAME" >> ~/.ssh/config
    echo "    HostName $IP " >> ~/.ssh/config
    echo "    Port 22" >> ~/.ssh/config
    echo "    ControlMaster auto" >> ~/.ssh/config
    echo "    ControlPersist yes" >> ~/.ssh/config
    echo "    ControlPath ~/.ssh/sockets/socket-%r@%h:%p" >> ~/.ssh/config
    echo "    AddressFamily inet" >> ~/.ssh/config
    echo ":: Updated ssh config file for easy server access under '$NAME'"
}

function addsshclients()
{
    read -p ':: Add additional ssh connections? [Y/n]' -r
    if [[ $REPLY =~ ^[Yy]$ ]] || [[ $REPLY == "" ]];then
        sshclient
        addsshclients
    fi
}
