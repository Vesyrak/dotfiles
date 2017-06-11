#!/bin/bash

user=false
CONFIG_FILE="$HOME/.config/sysconf/dotfiles.cfg"

function checkconf(){
    echo ":: Reading configuration"
    if !([ -f $CONFIG_FILE ]); then
        echo ":: No config file found. Make sure you run a regular install with this script."
    fi
}

function confenable(){
    if !(grep -q "$1 *= " $CONFIG_FILE); then
        echo "$1 $2" >> $CONFIG_FILE
    fi
}

function checksudo(){
    if !(which sudo > /dev/null); then
        echo ":: Warning: sudo has to be installed before running this script."
        echo ":: Exiting"
        exit 0
    fi
}

function checkstow(){
    if !(which stow > /dev/null); then
        sudo pacman -S stow
    fi
}

function createuser()
{
    read -p ":: Do you want to create a new user? [Y/n] " -n 1 -r
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
    sudo pacman -S --needed - < minpkglist
    askaur
    echo ":: System Update Finished"
    ssh
}

function main()
{
    echo ":: Starting System Update"
    sudo pacman -Syu
    sudo pacman -S --needed - < minpkglist
    sudo pacman -S --needed - < majpkglist
    askaur
    echo ":: System Update Finished"
    echo ":: Enabling NetworkManager"
    sudo systemctl start NetworkManager
    sudo systemctl enable NetworkManager
    lightdm
    echo ":: Starting AUR Installs"
    pacaur -Syu
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

function lightdm(){
    sudo pacman -S --needed lightdm lightdm-gtk-greeter
    pacaur -S gtk-theme-arc-git
    echo ":: Enabling lightdm"
    sudo systemctl enable lightdm
    echo ":: Stowing lightdm config"
    sudo ln -sf $PWD/lightdm/etc/lightdm/* /etc/lightdm/
    echo ":: Granting lightdm access to config file"
    setfacl -m u:lightdm:rx ~/
    setfacl -m u:lightdm:rx ~/repos
    setfacl -m u:lightdm:rx $PWD
    setfacl -R -m u:lightdm:rx repos/GNU-Linux-Config-Files/lightdm/
    echo ":: Please do note that this also enables VNC"
    echo ":: Setting VNC passwd"
    sudo vncpasswd /etc/vncpasswd
    echo ":: Don't forget to install a wallpaper for lightdm/awesome, otherwise ERRORS ENSURED"
    confenable lightdm 2
}

function ssh()
{
    echo  ":: Enabling sshd"
    sudo systemctl enable sshd
    sudo systemctl start sshd
    sudo ln -sf $PWD/ssh/etc/ssh/* /etc/ssh/
    sudo systemctl restart sshd
    confenable ssh 2
}

function aur()
{
    echo ":: Installing AUR"
    sudo pacman -S cower expac
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
    checkstow
    echo ":: Installing ZSH"
    sudo pacman -S --needed zsh zsh-completions pkgfile
    sudo pkgfile --update
    pacaur -S oh-my-zsh-git
    echo ":: ZSH Installation Finished. Changing Shell..."
    chsh -s /bin/zsh
    echo ":: Default Shell is now ZSH"
    echo ":: Reload Shell to see effects"
    echo ":: Installing ZSH config"
    stow -t ~/ zsh
    confenable zsh 0
}

function xonsh()
{
    checkstow
    echo ":: Installing XONSH"
    pacaur -S xonsh
    echo ":: XONSH Installation Finished. Changing Shell.."
    chsh -s /usr/bin/xonsh
    echo ":: Default Shell is now XONSH"
    echo ":: Reload Shell to see effects"
    echo ":: Installin XONSH $ ZSH config used by XONSH"
    stow -t ~/ zsh
    stow -t ~/ xonsh
    confenable zsh 0
    confenable xonsh 0
}

function delugeserver()
{
    checkstow
    echo ":: Setting up Deluge Server"
    sudo pacman -S --needed deluge
    sudo systemctl enable deluged
    sudo systemctl start deluged
    echo ":: Deluge Server Finished"
    echo ":: Setting up Deluge WebServer"
    sudo pacman -S --needed python2-service-identity python2-mako
    stow -t ~/ deluge
    sudo cp /usr/lib/systemd/system/deluged.service /etc/systemd/system/deluged.service #TODO Check if symlink works
    sudo sed -i "s/\(User*=*\).*/\1$USER/" /etc/systemd/system/deluged.service
    echo ":: Creating deluge auth file"
    read -p ":: Please enter the desired username: " name
    read -p ":: Please enter the desired password: " passwd
    echo "$name : $passwd :10" >> ~/.config/deluge/auth
    sudo systemctl enable deluge-web
    confenable deluge 0
}

function bluetooth()
{
    echo ":: Installing Bluetooth"
    sudo pacman -S --needed blueman
    sudo systemctl start bluetooth
    sudo systemctl enable bluetooth
    echo ":: Finished Installing Bluetooth"
}

function awesome()
{
    checkstow
    echo ":: Installing awesome"
    sudo pacman -S --needed awesome
    pacaur -S lain-git
    echo ":: Installation Finished"
    echo ":: Configuring..."
    stow -t ~/ awesome
    echo ":: Finished Installing AwesomeWM"
    confenable awesome 0
}

function i3()
{
    checkstow
    echo ":: Installing i3"
    pacaur -S i3status i3lock-blur i3-gaps rofi compton py3status python-mpd2 python-requests
    stow -t ~/ i3
    echo ":: Finished Installing i3WM"
    echo ":: Installing Compton"
    sudo pacman -S --needed compton
    stow -t ~/ compton
    echo ":: Finished Installing Compton"
    echo":: Installing dunst"
    sudo pacman -S --needed dunst
    stow -t ~/ dunst
    echo ":: Finished Installing dunst"
    confenable i3 0
    confenable compton 0
    confenable dunst 0
}

function config()
{
    checkstow
    echo ":: Installing Config Files"
    echo ":: Installing XResources"
    mkdir -p ~/.config/xresources/
    stow -t ~/ Xresources
    echo ":: Installing Vim"
    stow -t ~/ vim
    echo ":: Finished Installing Config Files"
    confenable Xresources 0
    confenable vim 0
}

#TODO Review
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

function odroidC2audiofix()
{
    echo ":: Installing odroid audio fix"
    sudo ln -sf $PWD/OdroidC2AudioFix/etc/* /etc/
    sudo chmod 666 /dev/am*
    sudo gpasswd --add $USER audio
    echo ":: Reboot to gain audio functionality"
    confenable OdroidC2AudioFix 2
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
    echo "UUID=4f7a9f5a-2bf7-46e2-9560-29f0326293e4 /media ext4 acl,noatime,nofail,x-systemd.device-timeout=10 0 2" >> /etc/fstab
}

#TODO Review
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
    sudo mkdir /media
    read -p ":: If nessecary, is your HDD already mounted on /media? [Y/n]" -n -r
    if [[ $REPLY =~ ^[Nn]$ ]]; then
        read -p ":: Please enter device name (e.g. /dev/sda2)"
        echo ":: Mounting $REPLY"
        sudo mount $REPLY /media
    fi
    checkstow
    sudo pacman -S --needed mpd mlocate screenfetch alsa-utils
    stow -t ~/ mpd
    setfacl -m "u:mpd:rwx" /media
    # mpd bootin'
    mpd
    sleep 1
    sudo systemctl stop mpd
    sudo sed  '/\[Unit\]/a RequiresMountsFor=/media/' /usr/lib/systemd/user/mpd.service
    systemctl --user enable mpd
    systemctl --user start mpd
    loginctl enable-linger $USER
    echo ":: This uses PulseAudio. Installing..."
    sudo pacman -S --needed pulseaudio
    sudo stow -t / pulseService
    sudo systemctl --user enable pulseaudio #todo unsynced with transceiver
    sudo systemctl --user start pulseaudio
    # Makes sure the wifi-dongle doesn't power off causing connection issues
    sudo stow -t / WLanPOFix
    echo ":: Installing Beets audio manager"
    sudo pacman -S --needed beets
    stow -t ~/ beets
    echo ":: Installing Beets extension dependencies"
    pacaur -S python2-discogs-client
    sudo pacman -S --needed python2-flask
    echo ":: Beets installed"
    echo ":: Installing Audio Client"
    sudo pacman -S --needed ncmpcpp
    stow -t ~/ ncmpcpp
    echo ":: Finished Installing Audio Client"
    confenable mpd 0
    confenable pulseService 1
    confenable WLanPOFix 1
    confenable beets 0
    confenable ncmpcpp 0

}

function pulsetransceiver()
{
    checkstow
    sudo pacman -S --needed pulseaudio-zeroconf avahi paprefs pavucontrol ttf-droid
    sudo systemctl start avahi-daemon
    sudo systemctl enable avahi-daemon
    stow -t ~/ pulsetransceiver
    systemctl --user enable pulseaudio
    loginctl enable-linger $USER
    read -p ":: Do you also want Bluetooth streaming on this device? [Y/n]" -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]] || [[ $REPLY == "" ]];then
        pulsebluetooth
    fi
    confenable pulsetransceiver 0

}

function pulsebluetooth()
{
    sudo pacman -S --needed pulseaudio-alsa pulseaudio-bluetooth bluez bluez-libs bluez-utils bluez-firmware
    sudo ln -sf $PWD/pulseBluetooth/etc/bluetooth/* /etc/bluetooth/
    echo ":: You still need to manually pair and trust the device fam"
    confenable pulseBluetooth 2
}

function windowspassthrough(){
    sudo pacman -S --needed virt-manager qemu libvirt ovmf bridge-utils
    sudo systemctl enable --now libvirtd
    sudo systemctl enable virtlogd.socket
    echo ":: Read the README in ./vm for instructions how to do the passthrough"
}

function restow(){
    checkstow
    checkconf
    while read config sudo; do
        echo $config
        case "$sudo" in
            "0")
                stow -R -t ~/ $config
                ;;
            "1")
                sudo stow -R -t / $config
                ;;
            "2")
                DIR=find $config -type d -links 2 | sed 's/^[^\/]*//g' #Change to find every folder containing files, followed by for
                sudo ln $config/$DIR/* $DIR/
                ;;
            *)
                echo ":: WARNING: ERROR FOUND IN CONFIGURATION FILE"
                echo ":: ABORTING"
                exit 1
                ;;
        esac
    done < $CONFIG_FILE

}

function askaur(){
    read -p $'\x0a:: Do you want to install an AUR helper? [Y/n]' -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]] || [[ $REPLY == "" ]];then
        aur
    else
        echo ":: Sure thing, ignore the potential errors coming up though. I'll fix this later."
    fi
}

checkuser
checksudo
for i in "$@"; do
    case "$i" in
        "createuser")
            createuser
            ;;
        "restow")
            restow
            ;;
    esac
done
read -p $'\x0a:: Do you want to install a minimal package list? [Y/n]' -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]] || [[ $REPLY == "" ]];then
    mainmin
else
    read -p $'\x0a:: Do you want to install a complete package list? [Y/n]' -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]] || [[ $REPLY == "" ]];then
        main
    fi
fi
read -p $'\x0a:: Do you want to use this machine as a Deluge Server? [Y/n]' -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]] || [[ $REPLY == "" ]];then
    delugeserver
fi
read -p $'\x0a:: Do you want to use this machine as a tt-rss server? [Y/n]' -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]] || [[ $REPLY == "" ]];then
    tt-rss
fi
read -p $'\x0a:: Do you want to install/update your configuration files? [Y/n]' -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]] || [[ $REPLY == "" ]];then
    config
fi
read -p $'\x0a:: Do you want to install the BlackArch repositories? [Y/n]' -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]] || [[ $REPLY == "" ]];then
    blackarch
fi
read -p $'\x0a:: Do you want to use this machine for gaming? [Y/n]' -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]] || [[ $REPLY == "" ]];then
    gaming
fi
read -p $'\x0a:: Do you want to use this machine as an Audio Server? [Y/n]' -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]] || [[ $REPLY == "" ]];then
    audioserver
    read -p $'\x0a:: I assume you also want the drive auto-mounted? [Y/n]' -n 1 -r

    if [[ $REPLY =~ ^[Yy]$ ]] || [[ $REPLY == "" ]];then
        automountServer
    fi
else
    read -p $'\x0a:: Do you want to use this machine as an Audio Client instead? [Y/n]' -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]] || [[ $REPLY == "" ]];then
        audioclient
    fi
fi
read -p $'\x0a:: Do you want Bluetooth? [Y/n]' -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]] || [[ $REPLY == "" ]];then
    bluetooth
fi
read -p $'\x0a:: Should this device be able to stream audio to/from other devices? [Y/n]' -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]] || [[ $REPLY == "" ]];then
    pulsetransceiver
fi
read -p $'\x0a:: Will this machine be connected to a pi-hole? [Y/n]' -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]] || [[ $REPLY == "" ]];then
    piholeclient
fi
read -p $'\x0a:: Will this machine use awesome as WM? [Y/n]' -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]] || [[ $REPLY == "" ]];then
    awesome
else
    read -p $'\x0a:: Will this machine use i3 instead? [Y/n]' -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]] || [[ $REPLY == "" ]];then
        i3
    fi
fi
read -p $'\x0a:: Do you want to install zsh as shell? [Y/n]' -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]] || [[ $REPLY == "" ]];then
    zsh
else
    echo $'\x0a:: WARNING: THE FOLLOWING IS STILL VERY EXPERIMENTAL'
    read -p $'\x0a:: Do you want to install xonsh as shell instead? [Y/n]' -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]] || [[ $REPLY == "" ]];then
        xonsh
    fi
fi
read -p $'\x0a:: Is this an odroid C2 without working audio? [Y/n]' -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]] || [[ $REPLY == "" ]];then
    odroidC2audiofix
fi
echo $'\x0a:: Install script terminating'

