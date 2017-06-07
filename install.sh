#!/bin/bash
user=false
function createuser()
{
    read -p ":: Do you want to create a new user? [Y/N] " -n 1 -r
    if [[ $REPLY =~ ^[Nn]$ ]]
    then
        exit 1
    fi
    echo
    read -p ":: Please enter the user name: " NAME
    if id -u $NAME >/dev/null 2>&1; then
        echo ":: User already exists!"
        exit 1
    fi
    sudo useradd $NAME -m -G audio
    echo "$USER ALL=(ALL) ALL" | sudo tee --append /etc/sudoers > /dev/null
    echo ":: Please enter preferred user passwd"
    sudo passwd $NAME
}
function checkuser()
{
    if [ "$(id -un)"  != "root" ]; then
        echo ":: Executing as regular user. Continuing."
        user=true
    else
        echo ":: Warning: running as root. Please create a new user by running createuser or su into it to continue using this script."
        user=false
    fi
}

function mainmin(){
    echo ":: Starting System Update"
    sudo pacman -Syu
    sudo pacman -S base-devel alsa-utils dhcpcd dialog iw wpa_supplicant htop mlocate openssh xorg-xauth xorg-xhost rxvt-unicode sudo wget vim
    echo ":: System Update Finished"
    ssh
}

function main()
{
    echo ":: Starting System Update"
    sudo pacman -Syu
    sudo pacman -S  awesome base-devel alsa-utils dhcpcd dialog iw wpa_supplicant chromium cmatrix dosfstools feh gimp wget htop gtk-chtheme networkmanager network-manager-applet mpv libreoffice-fresh mlocate ntfs-3g openssh pacgraph lxrandr rxvt-unicode scrot sudo tmux xorg-xhost xorg-server xorg-xauth xorg-server-utils xorg-xinit xorg-xrdb lightdm-gtk-greeter pulseaudio an2linux
    echo ":: System Update Finished"
    echo ":: Don't forget to install a wallpaper for lightdm/awesome, otherwise ERRORS ENSURED"
    echo ":: Enabling NetworkManager"
    sudo systemctl start NetworkManager
    sudo systemctl enable NetworkManager
    echo ":: Enabling lightdm"
    sudo systemctl enable lightdm
    echo ":: Stowing lightdm config"
    sudo stow -t / lightdm
    echo ":: Granting lightdm access to config file"
    setfacl -m u:lightdm:rx ~/
    setfacl -m u:lightdm:rx ~/repos
    setfacl -m u:lightdm:rx $PWD
    setfacl -R -m u:lightdm:rx repos/GNU-Linux-Config-Files/lightdm/
    echo ":: Starting AUR Installs"
    pacaur -Syu
    pacaur -S gtk-theme-arc-git pulsemixer
    pacaur -S an2linuxserver-git
    echo ":: Enabling An2Linux server"
    an2linuxserver.py
    systemctl --user enable an2linuxserver.service
    echo ":: Don't forget to manually pair your device first, by running an2linuxserver.py"
    echo ":: AUR Update Finished"
    echo ":: Updating File Locations"
    sudo updatedb
    echo ":: File Locations Updated"
}

function ssh()
{
    echo  ":: Enabling sshd"
    sudo systemctl enable sshd
    sudo systemctl start sshd
    sudo stow -t / ssh
    sudo systemctl restart sshd
}

function aur()
{
    echo ":: Installing AUR"
    wget https://aur.archlinux.org/cgit/aur.git/snapshot/cower.tar.gz
    tar -xvf cower.tar.gz
    cd cower
    makepkg --skippgpcheck
    makepkg -sri
    cd ../
    rm cower/ -r
    wget https://aur.archlinux.org/cgit/aur.git/snapshot/pacaur.tar.gz
    tar -xvf pacaur.tar.gz
    cd pacaur
    makepkg --skippgpcheck
    makepkg -sri
    cd ../
    rm pacaur -r
    echo ":: AUR Installation Finished"
}
function zsh()
{
    echo ":: Installing ZSH"
    sudo pacman -Syu
    sudo pacman -S zsh zsh-completions
    pacaur -S oh-my-zsh-git
    echo ":: ZSH Installation Finished. Changing Shell..."
    chsh -s /bin/zsh
    echo ":: Default Shell is now ZSH"
    echo ":: Reload Shell to see effects"
    echo ":: Installing ZSH config"
    stow -t ~/ zsh
}
function xonsh()
{
    echo ":: Installing XONSH"
    pacaur -Syu
    pacaur -S xonsh
    echo ":: XONSH Installation Finished. Changing Shell.."
    chsh -s /usr/bin/xonsh
    echo ":: Default Shell is now XONSH"
    echo ":: Reload Shell to see effects"
    echo ":: Installin XONSH $ ZSH config used by XONSH"
    stow -t ~/ zsh
    stow -t ~/ xonsh
}

function delugeserver()
{
    echo ":: Setting up Deluge Server"
    sudo pacman -Syu
    sudo pacman -S deluge
    sudo systemctl enable deluged
    sudo systemctl start deluged
    echo ":: Deluge Server Finished"
    echo ":: Setting up Deluge WebServer"
    sudo pacman -S python2-service-identity python2-mako
    stow -t ~/ deluge
    sudo cp /usr/lib/systemd/system/deluged.service /etc/systemd/system/deluged.service #TODO Check if symlink works
    read -p "You will have to edit the following config file to change the user from deluge to $USER"
    sudo vim /etc/systemd/system/deluged.service
    echo ":: Creating deluge auth file"
    read -p ":: Please enter the desired username: " name
    read -p ":: Please enter the desired password: " passwd
    echo "$name : $passwd :10" >> ~/.config/deluge/auth
    sudo systemctl enable deluge-web
}
function bluetooth()
{
    echo ":: Installing Bluetooth"
    sudo pacman -S blueman
    sudo systemctl start bluetooth
    sudo systemctl enable bluetooth
    echo ":: Finished Installing Bluetooth"
}
function awesome()
{
    echo ":: Installing awesome"
    sudo pacman -S awesome
    pacaur -S lain-git
    echo ":: Installation Finished"
    echo ":: Configuring..."
    stow -t ~/ awesome
    echo ":: Finished Installing AwesomeWM"
}
function i3()
{
    echo ":: Installing i3"
    pacaur -S i3status i3lock-blur i3-gaps rofi compton py3status python-mpd2 python-requests
    stow -t ~/ i3
    echo ":: Finished Installing i3WM"
    echo ":: Installing Compton"
    sudo pacman -S compton
    stow -t ~/ compton
    echo ":: Finished Installing Compton"
    echo":: Installing dunst"
    sudo pacman -S dunst
    stow -t ~/ dunst
    echo ":: Finished Installing dunst"

}
function config()
{
    echo ":: Installing Config Files"
    echo ":: Installing XResources"
    mkdir -p ~/.config/xresources/
    stow -t ~/ Xresources
    echo ":: Installing Vim"
    stow -t ~/ vim
    echo ":: Finished Installing Config Files"
}
function blackarch()
{
    echo ":: Installing Blackarch Repo"
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
    echo ":: Finished Installing Blackarch Repo"
}
function odroidC2audiofix(){
    echo ":: Installing odroid audio fix"
    sudo stow -t / OdroidC2AudioFix
    sudo chmod 666 /dev/am*
    sudo gpasswd --add $USER audio
    echo ":: Reboot to gain audio functionality"
}

function audioclient()
{
    echo ":: NOTE: Due to mpd design, the actual audio client is run on the server, displaying it through ssh."
    echo ":: This purely sets the IP address for easy connection"
    mkdir ~/.ssh
    touch ~/.ssh/config
    read -p ":: What is the server's IP address? " IP
    echo "Host mpd" >> ~/.ssh/config
    echo "    HostName $IP " >> ~/.ssh/config
    echo "    Port 22" >> ~/.ssh/config
    echo "    ControlMaster auto" >> ~/.ssh/config
    echo "    ControlPersist yes" >> ~/.ssh/config
    echo "    ControlPath ~/.ssh/sockets/socket-%r@%h:%p" >> ~/.ssh/config
    echo ":: Updated ssh config file for easy server access under 'mpd'"
}
function automountServer()
{
    echo ":: Putting media drive in automount. If you ever change harddrive, change the UUID"
    echo "UUID=4f7a9f5a-2bf7-46e2-9560-29f0326293e4 /music ext4 acl,noatime,nofail,x-systemd.device-timeout=10 0 2" >> /etc/fstab
}
function piholeclient()
{
    mkdir ~/.ssh
    touch ~/.ssh/config
    read -p ":: What is the server's IP address? " IP
    echo "Host pihole" >> ~/.ssh/config
    echo "    HostName $IP " >> ~/.ssh/config
    echo "    Port 22" >> ~/.ssh/config
    echo "    ControlMaster auto" >> ~/.ssh/config
    #echo "    ControlPersist yes" >> ~/.ssh/config TODO
    #echo "    ControlPath ~/.ssh/sockets/socket-%r@%h:%p" >> ~/.ssh/config
    echo ":: Updated ssh config file for easy server access under 'pihole'"
    echo ":: If you want to use the dns server, disable resolv.conf changing by your network manager."
    echo ":: You can do this in e.g. connman by editing connman.service and adding --nodnsproxy to execstart"
    echo ":: Setting the resolv.conf to the server"
    sudo rm /etc/resolv.conf
    sudo touch /etc/resolv.conf
    echo "nameserver $IP" | sudo tee --append /etc/resolv.conf > /dev/null
}
function audioserver()
{
    sudo pacman -Syu
    sudo pacman -S mpd mlocate screenfetch alsa-utils
    # music linkin'
    sudo stow -t / mpd
    setfacl -m "u:mpd:rwx" /media
    # mpd bootin'
    mpd
    sleep 1
    sudo systemctl stop mpd
    read -p ":: Put 'RequiresMountsFor=/media/' under [Unit]"
    sudo vim /usr/lib/systemd/user/mpd.service
    systemctl --user enable mpd
    systemctl --user start mpd
    loginctl enable-linger $USER
    echo ":: This uses PulseAudio. Installing..."
    sudo pacman -S pulseaudio
    sudo stow -t / pulseService
    sudo systemctl enable pulseaudio
    sudo systemctl start pulseaudio
    # Makes sure the wifi-dongle doesn't power off causing connection issues
    sudo stow -t / WLanPOFix
    echo ":: Be sure to mount your drive on /music/Music, and becoming owner of it!"
    echo ":: Installing Beets audio manager"
    sudo pacman -S beets
    stow -t ~/ beets
    echo ":: Installing Beets extension dependencies"
    pacaur -S python2-discogs-client
    sudo pacman -S python2-flask
    echo ":: Beets installed"
    echo ":: Installing Audio Client"
    sudo pacman -Syu
    sudo pacman -S ncmpcpp
    stow -t ~/ ncmpcpp
    echo ":: Finished Installing Audio Client"

}
function pulsetransceiver()
{
    sudo pacman -S pulseaudio-zeroconf avahi paprefs pavucontrol pulseaudio-bluetooth
    sudo systemctl start avahi-daemon
    sudo systemctl enable avahi-daemon
    sudo stow -t / pulsetransceiver
    read -p ":: Do you want Bluetooth on this device? [Y/N]" -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]];then
        pulsebluetooth
    fi

}
function pulsebluetooth()
{
    sudo pacman -S pulseaudio-alsa pulseaudio-bluetooth bluez bluez-libs bluez-utils bluez-firmware
    sudo stow -t / pulseBluetooth
    echo ":: You still need to manually pair and trust the device fam"
}
function windowspassthrough(){
    sudo pacman -S virt-manager qemu libvirt ovmf
    sudo systemctl enable --now libvirtd
    sudo systemctl enable virtlogd.socket
    echo ":: Read the README in ./vm for instructions how to do the passthrough"
}
checkuser
for i in "$@"; do
    if [[ $i == "createuser" ]]; then
        createuser
    fi
done
read -p ":: Do you want to install a minimal package list? [Y/N]" -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]];then
    mainmin
else
    read -p ":: Do you want to install a complete package list? [Y/N]" -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]];then
        main
    fi
fi
echo ":: Warning, the following should be run after a main or minimal install, for it depends on the base-devel group"
read -p ":: Do you want to install an AUR helper? [Y/N]" -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]];then
    aur
fi
read -p ":: Do you want to use this machine as a Deluge Server? [Y/N]" -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]];then
    delugeserver
fi
read -p ":: Do you want to use this machine as a tt-rss server? [Y/N]" -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
    tt-rss
fi
read -p ":: Do you want to install/update your configuration files? [Y/N]" -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]];then
    config
fi
read -p ":: Do you want to install the BlackArch repositories? [Y/N]" -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]];then
    blackarch
fi
read -p ":: Do you want to use this machine for gaming? [Y/N]" -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]];then
    gaming
fi
read -p ":: Do you want to use this machine as an Audio Server? [Y/N]" -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]];then
    audioserver
    read -p ":: I assume you also want the drive auto-mounted? [Y/N]" -n 1 -r

    if [[ $REPLY =~ ^[Yy]$ ]];then
        automountServer
    fi
else
    read -p ":: Do you want to use this machine as an Audio Client instead? [Y/N]" -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]];then
        audioclient
    fi
fi
read -p ":: Do you want Bluetooth? [Y/N]"
if [[ $REPLY =~ ^[Yy]$ ]];then
    bluetooth
fi
read -p ":: Should this device be able to stream audio to/from other devices?"
if [[ $REPLY =~ ^[Yy]$ ]];then
    pulsetransceiver
fi
read -p ":: Will this machine be connected to a pi-hole? [Y/N]" -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]];then
    piholeclient
fi
read -p ":: Will this machine use awesome as WM? [Y/N]" -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]];then
    awesome
else
    read -p ":: Will this machine use i3 instead? [Y/N]" -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]];then
        i3
    fi
fi
read -p ":: Do you want to install zsh as shell? [Y/N]" -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]];then
    zsh
else
    echo ":: WARNING: THE FOLLOWING IS STILL VERY EXPERIMENTAL"
    read -p ":: Do you want to install xonsh as shell instead? [Y/N]" -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]];then
        xonsh
    fi
fi
read -p ":: Is this an odroid C2 without working audio? [Y/N]"
if [[ $REPLY =~ ^[Yy]$ ]];then
    odroidC2audiofix
fi
echo ":: Install script terminating"

