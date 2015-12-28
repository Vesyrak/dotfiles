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
function main()
{
    sudo pacman -Syu
    sudo pacman -S alsa-utils dhcpcd dialog iw wpa_supplicant chromium cmatrix deluge dosfstools dcfldd feh dmenu gimp gvim-python3 htop gtk-chtheme libreoffice-fresh mlocate ntfs-3g openssh pacgraph rxvt-unicode scrot sudo tmux xorg-server xorg-xauth xorg-server-utils xorg-xinit xorg-xrdb
    wget https://aur.archlinux.org/cgit/aur.git/snapshot/package-query.tar.gz
    tar -xvf package-query.tar.gz
    cd package-query
    makepkg
    makepkg -sri
    cd ../
    rm package-query/ -r
    wget https://aur.archlinux.org/cgit/aur.git/snapshot/yaourt.tar.gz
    cd yaourt
    makepkg
    makepkg -sri
    cd ../
    rm yaourt
    yaourt -Syua
    yaourt -S gtk-theme-arc-git i3-gaps-git i3lock-wrapper j4-dmenu-desktop
    zsh
    sudo updatedb
}
function zsh()
{
    sudo pacman -Syu
    sudo pacman -S zsh zsh-completions
    yaourt -S oh-my-zsh-git
    chsh -s /bin/zsh
    /bin/zsh
}

function delugeserver()
{
    sudo pacman -Syu
    sudo pacman -S deluge
    sudo systemctl enable deluged
    sudo systemctl start deluged
}

function config()
{
    #Installation of config files
    mkdir -p ~/.config/xresources/
    ln -fs Xorg/xresources/Netron.Xresource ~/.config/xresources/Netron.Xresource
    ln -fs Xorg/.xinitrc ~/.xinitrc
    mkdir -p ~/.config/i3/
    ln -fs i3/config ~/.config/i3/config

    ln -fs vim/.vimrc ~/.vimrc
    ln -fs vim/.vimrc.plugins ~/.vimrc.plugins

    ln -fs zsh/.zshrc ~/.zshrc
    ln -fs zsh/.zsh_aliases ~/.zsh_aliases
    ln -fs zsh/.zlogin ~/.zlogin
    #installation of privileged config files
    sudo ln -fs pacman/pacman.conf /etc/pacman.conf
    sudo cp wpa-supplicant-WPA2Enterprise/wpa_supplicant-apwifi /etc/wpa_supplicant/wpa_supplicant-apwifi
    #installation of dmenu aliases and recents support
    ln dmenu/dmenu-recent-aliases /usr/bin/dmenu-recent-aliases
    chmod 777 /usr/bin/dmenu-recent-aliases
}
function blackarch()
{
    #Repository installation
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
    sudo pacman -Syu
    sudo pacman -S ncmpcpp
    ln -fs ncmpcpp/config /home/reinout/.ncmpcpp/config
    ln -fs ncmpcpp/bindings /home/reinout/.ncmpcpp/bindings
}

function audioserver()
{
    sudo pacman -Syu
    sudo pacman -S mpd mlocate screenfetch alsa-utils
    sudo chown -R reinout /var/lib/mpd

    # music linkin'
    ln -fs mpd /etc/mpd.conf
    # mpd bootin'
    mpd --create-db
    sleep 1
    sudo systemctl stop mpd
    sudo systemctl enable mpd
    sudo systemctl start mpd

    # Makes sure the wifi-dongle doesn't power off causing connection issues
    sudo ln -sf music/WLanPOFix /etc/modprobe.d/8192cu.conf
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
                echo "Unknown Command"
            fi
    fi
done
echo "Nothing left to be done"
