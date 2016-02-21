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
    sudo pacman -S base-devel alsa-utils dhcpcd dialog iw wpa_supplicant chromium dmenu gvim-python3 htop mlocate openssh pacgraph rxvt-unicode sudo tmux xorg-server xorg-xauth xorg-server-utils xorg-xinit xorg-xrdb
    echo "System Update Finished"
    echo "Installing AUR"
    wget https://aur.archlinux.org/cgit/aur.git/snapshot/package-query.tar.gz
    tar -xvf package-query.tar.gz
    cd package-query
    makepkg
    makepkg -sri
    cd ../
    rm package-query/ -r
    wget https://aur.archlinux.org/cgit/aur.git/snapshot/yaourt.tar.gz
    tar -xvf yaourt.tar.gz
    cd yaourt
    makepkg
    makepkg -sri
    cd ../
    rm yaourt -r
    echo "AUR Installation Finished"
    echo "Starting AUR Update"
    yaourt -Syua
    yaourt -S j4-dmenu-desktop
    echo "AUR Update Finished"
    zsh
    echo "Updating File Locations"
    sudo updatedb
    echo "File Locations Updated"
}
function i3rpi()
{
    echo "Installing i3 for Raspberry Pi"
    sudo pacman -S xorg-xrdb xorg-xinit unclutter
    yaourt -S j4-dmenu-desktop i3-gaps-git
    echo "Installation Complete"
    echo "Configuring..."
    echo "Installing Xinitrc"
    ln -sf $PWD/Xorgrpi/.xinitrc ~/.xinitrc
    echo "Installing i3Config"
    mkdir -p ~/.config/i3/
    ln -sf $PWD/i3rpi/config ~/.config/i3/config
    echo "i3 Installation Completed"
}
function main()
{
    echo "Starting System Update"
    sudo pacman -Syu
    sudo pacman -S base-devel alsa-utils dhcpcd dialog iw wpa_supplicant chromium cmatrix deluge dosfstools feh dmenu gimp htop gtk-chtheme libreoffice-fresh mlocate ntfs-3g openssh pacgraph rxvt-unicode scrot sudo tmux
    echo "System Update Finished"
    echo "Installing AUR"
    wget https://aur.archlinux.org/cgit/aur.git/snapshot/package-query.tar.gz
    tar -xvf package-query.tar.gz
    cd package-query
    makepkg
    makepkg -sri
    cd ../
    rm package-query/ -r
    wget https://aur.archlinux.org/cgit/aur.git/snapshot/yaourt.tar.gz
    tar -xvf yaourt.tar.gz
    cd yaourt
    makepkg
    makepkg -sri
    cd ../
    rm yaourt -r
    echo "AUR Installation Finisshed"
    echo "Starting AUR Update"
    yaourt -Syua
    yaourt -S gtk-theme-arc-git
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
    yaourt -S oh-my-zsh-git
    echo "ZSH Installation Finished. Changing Shell..."
    chsh -s /bin/zsh
    /bin/zsh
    echo "Shell is now ZSH"
}

function delugeserver()
{
    echo "Setting up Deluge Server"
    sudo pacman -Syu
    sudo pacman -S deluge
    sudo systemctl enable deluged
    sudo systemctl start deluged
    echo "Deluge Server Finished"
}
function i3()
{
    echo "Installing i3"
    sudo pacman -S xorg-server xorg-xauth xorg-server-utils xorg-xinit xorg-xrdb
    yaourt -S j4-dmenu-desktop i3-gaps-git i3lock-wrapper
    echo "Installation Finished"
    echo "Configuring..."
    echo "Installing Xinitrc"
    ln -sf $PWD/Xorg/.xinitrc ~/.xinitrc
    echo "Installing i3Config"
    mkdir -p ~/.config/i3/
    ln -sf $PWD/i3/config ~/.config/i3/config
    echo "i3 Installation completed"
}
function config()
{
    echo "Installing Config Files"
    echo "Installing XResources"
    mkdir -p ~/.config/xresources/
    ln -sf $PWD/Xorg/xresources/Netron.Xresource ~/.config/xresources/Netron.Xresource
    echo "Installing Vim"
    ln -sf $PWD/vim/.vimrc ~/.vimrc
    ln -sf $PWD/vim/.vimrc.plugins ~/.vimrc.plugins
    echo "Installing zsh config"
    ln -sf $PWD/zsh/.zshrc ~/.zshrc
    ln -sf $PWD/zsh/.zsh_aliases ~/.zsh_aliases
    ln -sf $PWD/zsh/.zlogin ~/.zlogin
    echo "Installing Pacman Config files"
    sudo ln -sf $PWD/pacman/pacman.conf /etc/pacman.conf
    echo "Installing WPA-Enterprise Config Files"
    sudo cp wpa-supplicant-WPA2Enterprise/wpa_supplicant-apwifi /etc/wpa_supplicant/wpa_supplicant-apwifi
    echo "Installing Dmenu Recent Aliases"
    sudo ln -sf $PWD/dmenu/dmenu-recent-aliases /usr/bin/dmenu-recent-aliases
    chmod 777 /usr/bin/dmenu-recent-aliases
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
    echo "[blackarch]" >> pacman.conf
    echo "Server = http://www.mirrorservice.org/sites/blackarch.org/blackarch//$repo/os/$arch "
    echo "Finished Installing Blackarch Repo"
}

function gaming()
{
# TODO: update user requirements.
    sudo pacman -Syu
    sudo pacman -S playonlinux wine steam
    yaourt -S steam-fonts
}

function audioclient()
{
    echo "Installing Audio Client"
    sudo pacman -Syu
    sudo pacman -S ncmpcpp
    mkdir .ncmpcpp
    ln -sf $PWD/ncmpcpp/config /home/reinout/.ncmpcpp/config
    ln -sf $PWD/ncmpcpp/bindings /home/reinout/.ncmpcpp/bindings
    echo "Finished Installing Audio Client"
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
            elif [[ $i == "i3" ]]; then
                i3
            elif [[ $i == "i3rpi" ]]; then
                i3rpi
            else
                echo "Unknown Command"
            fi
    fi
done
echo "Nothing left to be done"
