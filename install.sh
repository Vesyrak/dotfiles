#!/bin/bash

CONFIG_FILE="$HOME/.config/sysconf/dotfiles.cfg"
INSTALL_QUEUE=""
CONFIG_QUEUE=""
TODO=""

. /etc/os-release
OS=$NAME

function main()
{
    echo ":: Enabling NetworkManager"
    sudo systemctl start NetworkManager
    sudo systemctl enable NetworkManager
    echo ":: Enabling An2Linux server"
    an2linuxserver.py
    systemctl --user enable an2linuxserver.service
    TODO+=":: An2Linux\n"
    TODO+=":: Don't forget to manually pair your device first, by running an2linuxserver.py\n"
    echo ":: Updating File Locations"
    sudo updatedb
}

function askaur()
{
    if !(which pacaur > /dev/null); then
        read -p $'\x0a:: Do you want to install an AUR helper? [Y/n]' -r
        if [[ $REPLY =~ ^[Yy]$ ]] || [[ $REPLY == "" ]];then
            aur
        else
            echo $'\x0a:: Pacaur is required for this script to function properly.'
            echo ":: Exiting"
            exit 0
        fi
    fi
}

function install()
{
    echo ":: Starting System Update"
    askaur
    pacaur -S --needed  $INSTALL_QUEUE
    echo ":: System Update Finished"
}

function configure(){
    echo ":: Starting Configuring"
    arr=($CONFIG_QUEUE)
    for config in ${arr[@]}; do
        echo "$config"
        eval "$config"
    done
    echo ":: Configuring Finished"
}

function addsshclients()
{
    read -p ':: Add additional ssh connections? [Y/n]' -r
    if [[ $REPLY =~ ^[Yy]$ ]] || [[ $REPLY == "" ]];then
        sshclient
        addsshclients
    fi
}

function aur()
{
    echo ":: Installing AUR"
    sudo pacman -Syu
    echo ":: First installing development packages"
    sudo pacman -S --needed base-devel cower yajl  expac wget
    #If cower can't be installed via pacman (aka if the AUR repo isn't present)
    if !(which cower > /dev/null); then
        wget https://aur.archlinux.org/cgit/aur.git/snapshot/cower.tar.gz
        tar -xvf cower.tar.gz
        cd cower
        makepkg --skippgpcheck
        makepkg -sri
        cd ../
        rm cower/ -r
    fi
    wget https://aur.archlinux.org/cgit/aur.git/snapshot/pacaur.tar.gz
    tar -xvf pacaur.tar.gz
    cd pacaur
    makepkg --skippgpcheck
    makepkg -sri
    cd ../
    rm pacaur -r
    echo ":: AUR Installation Finished"
}

function audioclient()
{
    echo ":: NOTE: Due to mpd design, the actual audio client is run on the server, displaying it through ssh."
    echo ":: This purely sets the IP address for easy connection"
    sshclient mpd
}

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

checkuser
checksudo

while getopts "a" opt; do
  case $opt in
    m)
      echo "-a was triggered!" >&2
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      ;;
  esac
done

read -p ':: Do you want to install a minimal package list? [Y/n]' -r
if [[ $REPLY =~ ^[Yy]$ ]] || [[ $REPLY == "" ]];then
    INSTALL_QUEUE+=$(cat minpkglist)
    CONFIG_QUEUE+="ssh "
else
    read -p ':: Do you want to install a complete package list? [Y/n]' -r
    if [[ $REPLY =~ ^[Yy]$ ]] || [[ $REPLY == "" ]];then
        INSTALL_QUEUE+=$(cat minpkglist)
        INSTALL_QUEUE+=$(cat majpkglist)
        INSTALL_QUEUE+=" "
        INSTALL_QUEUE+="an2linuxserver-git lightdm light-locker lightdm-gtk-greeter gtk-theme-arc-git "
        CONFIG_QUEUE+="main ssh "
    fi
fi

install
configure
addsshclients
echo ':: Install script terminating'
echo "$TODO"
if [[ $OS == "Ubuntu"]]
