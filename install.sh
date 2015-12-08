#!/bin/bash
# The install script for my vim dotfiles.
# Find the location of the script.
mkdir -p ~/.config/xresources/
ln -sf Xorg/xresources/Netron.Xresource ~/.config/xresources/Netron.Xresource
ln -sf Xorg/.xinitrc ~/.xinitrc
mkdir -p ~/.config/i3/
ln -sf i3/config ~/.config/i3/config
sudo ln -sf pacman/pacman.conf /etc/pacman.conf
ln -sf vim/.vimrc ~/.vimrc
ln -sf vim/.vimrc.plugins ~/.vimrc.plugins
cp wpa-supplicant-WPA2Enterprise/wpa_supplicant-apwifi /etc/wpa_supplicant/wpa_supplicant-apwifi
ln -sf zsh/.zshrc ~/.zshrc
ln -sf zsh/.zsh_aliases ~/.zsh_aliases
ln -sf zsh/.zlogin ~/.zlogin


