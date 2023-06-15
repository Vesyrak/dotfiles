#!/bin/bash
sudo apt remove  \
    kmahjongg \
    kmines \
    kpatience \
    ksudoku \
    libreoffice-base-core \
    libreoffice-common \
    libreoffice-core

sudo apt autoremove

sudo apt update && sudo apt install \
    bluetooth \
    build-essential \
    chromium-browser \
    dosfstools \
    gimp \
    gtk-chtheme \
    i3wm \
    kcolorchooser \
    kitty \
    lxrandr \
    mpv \
    nitrogen \
    syncthing \
    wget \
    zsh

#Todo i3
