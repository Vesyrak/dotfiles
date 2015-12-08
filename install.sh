#!/bin/bash
# The install script for my vim dotfiles.
# Find the location of the script.
curl -O http://blackarch.org/strap.sh && sha1sum strap.sh
chmod 777 strap.sh
sudo ./strap.sh
rm strap.sh
sudo pacman-key --init
sudo dirmngr &
sleep 3
last_pid=$!
sudo kill -KILL $last_pid
sudo pacman-key -r 962DDE58
sudo pacman-key --lsign-key 962DDE58
mkdir -p ~/.config/xresources/
ln -f Xorg/xresources/Netron.Xresource ~/.config/xresources/Netron.Xresource
ln -f Xorg/.xinitrc ~/.xinitrc
mkdir -p ~/.config/i3/
ln -f i3/config ~/.config/i3/config
sudo ln -f pacman/pacman.conf /etc/pacman.conf
ln -f vim/.vimrc ~/.vimrc
ln -f vim/.vimrc.plugins ~/.vimrc.plugins
sudo cp wpa-supplicant-WPA2Enterprise/wpa_supplicant-apwifi /etc/wpa_supplicant/wpa_supplicant-apwifi
ln -f zsh/.zshrc ~/.zshrc
ln -f zsh/.zsh_aliases ~/.zsh_aliases
ln -f zsh/.zlogin ~/.zlogin


