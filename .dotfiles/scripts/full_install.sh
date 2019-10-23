#!/bin/bash
for f in ./scripts/core/*; do source $f; done
. ./scripts/minimal_install.sh

function full_install(){
    #Office Suite
    INSTALL_QUEUE+="wps-office "
    #Web Suite
    INSTALL_QUEUE+="chromium-browser "
    #Ricing
    INSTALL_QUEUE+="gtk-chtheme lxrandr "
    #Dropdown Terminal
    INSTALL_QUEUE+="yakuake "
    #Video
    INSTALL_QUEUE+="mpv "
    #Editing
    INSTALL_QUEUE+="gimp "
    #Image Writing
    echo "deb https://deb.etcher.io stable etcher" | sudo tee /etc/apt/sources.list.d/balena-etcher.list
    sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 379CE192D401AB61
    INSTALL_QUEUE+="balena-etcher-electron "

    #Window Manager
    INSTALL_QUEUE+="libxcb1-dev libxcb-keysyms1-dev libpango1.0-dev libxcb-util0-dev libxcb-icccm4-dev libyajl-dev libstartup-notification0-dev libxcb-randr0-dev libev-dev libxcb-cursor-dev libxcb-xinerama0-dev libxcb-xkb-dev libxkbcommon-dev libxkbcommon-x11-dev autoconf libxcb-xrm0 libxcb-xrm-dev automake "

}

function snap_full_install(){
    #File Editing
    snapinstall "atom --classic "

    #Window Manager
    cd /tmp
    git clone https://www.github.com/Airblader/i3 i3-gaps
    cd i3-gaps

    autoreconf --force --install
    rm -rf build/
    mkdir -p build && cd build/

    ../configure --prefix=/usr --sysconfdir=/etc --disable-sanitizers
    make
    sudo make install

}
INSTALL_QUEUE=""
minimal_install
full_install
sudo apt update
sudo apt install $INSTALL_QUEUE
snap_full_install

