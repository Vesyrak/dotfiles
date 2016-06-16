#!/bin/bash
user=false
function createUser()
{
    if [ "$(id -u)" != "0" ]; then
        echo "This script must be run as root" 1>&2
        exit 1
    fi
    if id -u "reinout" >/dev/null 2>&1; then
        echo "User already exists!"
        exit 1
    fi
    useradd reinout -m -G audio
    sudo 'echo "reinout ALL=(ALL) ALL" >> /etc/sudoers'
    echo "Please enter preferred user passwd"
    sudo passwd reinout
    su reinout
}
function checkUser()
{

    if id -u "reinout" >/dev/null 2>&1; then
        echo "Standard user exists. Continuing."
        user=true
    else
        echo "Warning: Standard user doesn't exist. Please create it by executing /bin/bash install.sh createUser or change into it by using su"
        user=false
    fi
}
function mainpi(){
    echo "Starting System Update"
    sudo pacman -Syu
    sudo pacman -S base-devel alsa-utils dhcpcd dialog iw wpa_supplicant chromium htop mlocate openssh pacgraph rxvt-unicode sudo tmux xorg-server
xorg-xauth xorg-server-utils xorg-xinit xorg-xrdb
    echo "System Update Finished"
    echo "Installing AUR"
    wget https://aur.archlinux.org/cgit/aur.git/snapshot/cower.tar.gz
    tar -xvf cower.tar.gz
    cd cower
    makepkg
    makepkg -sri
    cd ../
    rm cower/ -r
    wget https://aur.archlinux.org/cgit/aur.git/snapshot/pacaur.tar.gz
    tar -xvf pacaur.tar.gz
    cd pacaur
    makepkg
    makepkg -sri
    cd ../
    rm pacaur -r
    echo "AUR Installation Finished"
    echo "Starting AUR Update"
    pacaur -Syu
    echo "AUR Update Finished"
    echo "Updating File Locations"
    sudo updatedb
    echo "File Locations Updated"
}
function main()
{
    echo "Starting System Update"
    sudo pacman -Syu
    sudo pacman -S  awesome base-devel alsa-utils dhcpcd dialog iw wpa_supplicant chromium cmatrix dosfstools feh gimp wget htop gtk-chtheme
libreoffice-fresh mlocate ntfs-3g openssh pacgraph rxvt-unicode scrot sudo tmux xorg-server xorg-xauth xorg-server-utils xorg-xinit xorg-xrdb lightdm-gtk-greeter pulseaudio pavucontrol
    echo "System Update Finished"
    echo "Enabling lightdm"
    sudo systemctl enable lightdm
    echo "Installing AUR"
    wget https://aur.archlinux.org/cgit/aur.git/snapshot/cower.tar.gz
    tar -xvf cower.tar.gz
    cd cower
    makepkg
    makepkg -sri
    cd ../
    rm cower/ -r
    wget https://aur.archlinux.org/cgit/aur.git/snapshot/pacaur.tar.gz
    tar -xvf pacaur.tar.gz
    cd pacaur
    makepkg
    makepkg -sri
    cd ../
    rm pacaur -r
    echo "AUR Installation Finisshed"
    echo "Starting AUR Update"
    pacaur -Syu
    pacaur -S gtk-theme-arc-git lain-git pulsemixer
    echo "AUR Update Finished"
    zsh
    echo "Updating File Locations"
    sudo updatedb
    echo "File Locations Updated"
}
function zsh()
{
    echo "Installing ZSH"
    sudo pacman -Syu
    sudo pacman -S zsh zsh-completions
    pacaur -S oh-my-zsh-git
    echo "ZSH Installation Finished. Changing Shell..."
    chsh -s /bin/zsh
    echo "Default Shell is now ZSH"
    echo "Reload Shell to see effects"
    echo "Installing ZSH config"
    ln -sf $PWD/zsh/.zshrc ~/.zshrc
    ln -sf $PWD/zsh/.zsh_aliases ~/.zsh_aliases
    ln -sf $PWD/zsh/.zlogin ~/.zlogin
}
function xonsh()
{
    echo "Installing XONSH"
    pacaur -Syu
    pacaur -S xonsh
    echo "XONSH Installation Finished. Changing Shell.."
    chsh -s /bin/xonsh
    echo "Default Shell is now XONSH"
    echo "Reload Shell to see effects"
    echo "Installin XONSH $ ZSH config used by XONSH"
    ln -sf $PWD/zsh/.zshrc ~/.zshrc
    ln -sf $PWD/zsh/.zsh_aliases ~/.zsh_aliases
    ln -sf $PWD/zsh/.zlogin ~/.zlogin
    mkdir -p ~/.config/xonsh
    ln -sf $PWD/xonsh/config.json ~/.config/xonsh/config.json
}

function delugeserver()
{
    echo "Setting up Deluge Server"
    sudo pacman -Syu
    sudo pacman -S deluge
    sudo systemctl enable deluged
    sudo systemctl start deluged
    echo "Deluge Server Finished"
    echo "WebServer is probably not configured yet"
    read -p "What is the server's IP address?" ip
    echo "Host torrent" >> ~/.ssh/config
    echo "    HostName $IP " >> ~/.ssh/config
    echo "    Port 22" >> ~/.ssh/config
    echo "Updated ssh config file for easy server access under 'torrent'"
}

function config()
{
    echo "Installing Config Files"
    echo "Installing XResources"
    mkdir -p ~/.config/xresources/
    ln -sf $PWD/Xorg/xresources/Netron.Xresource ~/.config/xresources/Netron.Xresource
    echo "Installing Xinitrc"
    ln -sf $PWD/Xorg/.xinitrc ~/.xinitrc
    echo "Installing awesome"
    ln -sf $PWD/awesome ~/.config/awesome
    echo "Installing Vim"
    ln -sf $PWD/vim/.vimrc ~/.vimrc
    ln -sf $PWD/vim/.vimrc.plugins ~/.vimrc.plugins
    echo "Installing WPA-Enterprise Config Files"
    sudo cp wpa-supplicant-WPA2Enterprise/wpa_supplicant-apwifi /etc/wpa_supplicant/wpa_supplicant-apwifi
    echo "Finished Installing Config Files"
}
function blackarch()
{
    echo "Installing Blackarch Repo"
    curl -O http://blackarch.org/strap.sh && sha1sum strap.sh
    chmod 777 strap.sh
    sudo ./strap.sh
    rm strap.sh
    sudo pacman-key --init
    sudo dirmngr &
    sleep 1
    last_pid=$!
    sudo kill -KILL $last_pid
    sudo pacman-key -r 962DDE58
    sudo pacman-key --lsign-key 962DDE58
    sudo echo "[blackarch]" >> /etc/pacman.conf
    sudo echo "Server = http://www.mirrorservice.org/sites/blackarch.org/blackarch//$repo/os/$arch " >> /etc/pacman.conf
    echo "Finished Installing Blackarch Repo"
}

function gaming()
{
# TODO: update user requirements.
    sudo pacman -Syu
    sudo pacman -S steam
    pacaur -S steam-fonts
}

function audioclient()
{
    echo "NOTE: Due to mpd design, the actual audio client is run on the server, displaying it through ssh."
    echo "This purely sets the IP address for easy connection"
    read -p "What is the server's IP address?" ip
    echo "Host mpd" >> ~/.ssh/config
    echo "    HostName $IP " >> ~/.ssh/config
    echo "    Port 22" >> ~/.ssh/config
    echo "Updated ssh config file for easy server access under 'mpd'"
}
function pihole()
{
    echo "WARNING: THIS HAS NOT BEEN IMPLEMENTED YET"
    read -p "What is the server's IP address?" ip
    echo "Host pihole" >> ~/.ssh/config
    echo "    HostName $IP " >> ~/.ssh/config
    echo "    Port 22" >> ~/.ssh/config
    echo "Updated ssh config file for easy server access under 'pihole'"
}
function audioserver()
{
    sudo pacman -Syu
    sudo pacman -S mpd mlocate screenfetch alsa-utils
    sudo chown -R reinout /var/lib/mpd

    # music linkin'
    ln -sf $PWD/mpd/mpd.conf /etc/mpd.conf
    # mpd bootin'
    mpd --create-db
    sleep 1
    sudo systemctl stop mpd
    sudo systemctl enable mpd
    sudo systemctl start mpd

    # Makes sure the wifi-dongle doesn't power off causing connection issues
    sudo ln -sf $PWD/music/WLanPOFix /etc/modprobe.d/8192cu.conf
    echo "Be sure to mount your drive on /music/Music, and becoming owner of it!"
    echo "Installing Audio Client"
    sudo pacman -Syu
    sudo pacman -S ncmpcpp
    mkdir .ncmpcpp
    ln -sf $PWD/ncmpcpp/config /home/reinout/.ncmpcpp/config
    ln -sf $PWD/ncmpcpp/bindings /home/reinout/.ncmpcpp/bindings
    echo "Finished Installing Audio Client"
}
checkUser
for i in "$@"; do
    if [[ $i == "createUser" ]]; then
        createUser

     elif $user; then
            if [[ $i == "main" ]]; then
                main

            elif [[ $i == "zsh" ]]; then
                zsh

            elif [[ $i == "mainpy" ]]; then
                mainpy
            elif [[ $i == "delugeserver" ]]; then
                delugeserver

            elif [[ $i == "config" ]]; then
                config

            elif [[ $i == "blackarch" ]]; then
                blackarch

            elif [[ $i == "gaming" ]]; then
                gaming

            elif [[ $i == "audioclient" ]]; then
                audioclient

            elif [[ $i == "audioserver" ]]; then
                audioserver
            else
                echo "Unknown Command $i"
            fi
    fi
done
echo "Nothing left to be done"
