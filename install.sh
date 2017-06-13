#!/bin/bash

user=false
CONFIG_FILE="$HOME/.config/sysconf/dotfiles.cfg"
INSTALL_QUEUE=""
CONFIG_QUEUE=""

function checkconf()
{
    echo ":: Reading configuration"
    if !([ -f $CONFIG_FILE ]); then
        echo ":: No config file found. Make sure you run a regular install with this script."
    fi
}

function confenable()
{
    if !([ -f $CONFIG_FILE ]); then
        mkdir -p $HOME/.config/sysconf/
        touch $CONFIG_FILE
    fi
    if !(grep -q "$1 *= " $CONFIG_FILE); then
        echo "$1 $2" >> $CONFIG_FILE
    fi
}

function checksudo()
{
    if !(which sudo > /dev/null); then
        echo ":: Warning: sudo has to be installed before running this script."
        echo ":: Exiting"
        exit 0
    fi
}

function createuser()
{
    read -p ":: Do you want to create a new user? [Y/n] " -r
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

function main()
{
    echo ":: Enabling NetworkManager"
    sudo systemctl start NetworkManager
    sudo systemctl enable NetworkManager
    echo ":: Enabling An2Linux server"
    an2linuxserver.py
    systemctl --user enable an2linuxserver.service
    echo ":: Don't forget to manually pair your device first, by running an2linuxserver.py"
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

function lightdm()
{
    echo ":: Configuring Lightdm"
    sudo systemctl enable lightdm
    sudo ln -sf $PWD/lightdm/etc/lightdm/* /etc/lightdm/
    confenable lightdm 2
    setfacl -m u:lightdm:rx ~/
    setfacl -m u:lightdm:rx ~/repos
    setfacl -m u:lightdm:rx $PWD
    setfacl -R -m u:lightdm:rx repos/GNU-Linux-Config-Files/lightdm/
    echo ":: Please do note that this also enables VNC"
    echo ":: Setting VNC passwd"
    sudo vncpasswd /etc/vncpasswd
    echo ":: Don't forget to install a wallpaper for lightdm/awesome, otherwise ERRORS ENSURED"
}

function syncthing()
{
    echo ":: Configuring Syncthing"
    sudo systemctl enable syncthing@$USER
    sudo systemctl start syncthing@$USER
    echo ":: Further configurations can be done by the webui"
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
    sudo pacman -Syu
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
    echo ":: Configuring ZSH"
    stow -t ~/ zsh
    confenable zsh 0
    sudo pkgfile --update
    echo ":: Changing Shell"
    chsh -s /bin/zsh
    echo ":: Reload Shell to see effects"
}

function xonsh()
{
    echo ":: Configuring XONSH"
    stow -t ~/ zsh
    confenable zsh 0
    stow -t ~/ xonsh
    confenable xonsh 0
    echo ":: Changing Shell.."
    chsh -s /usr/bin/xonsh
    echo ":: Reload Shell to see effects"
}

function delugeserver()
{
    echo ":: Configuring Deluge Server"
    sudo systemctl enable deluged
    sudo systemctl start deluged
    sudo sed -i "s/\(User*=*\).*/\1$USER/" /etc/systemd/system/deluged.service
    echo ":: Configuring Deluge WebServer"
    stow -t ~/ deluge
    sudo cp /usr/lib/systemd/system/deluged.service /etc/systemd/system/deluged.service
    echo ":: Creating deluge auth file"
    read -p ":: Please enter the desired username: " name
    read -p ":: Please enter the desired password: " passwd
    echo "$name : $passwd :10" >> ~/.config/deluge/auth
    sudo systemctl enable deluge-web
    confenable deluge 0
}

function bluetooth()
{
    echo ":: Configuring Bluetooth"
    sudo systemctl start bluetooth
    sudo systemctl enable bluetooth
}

function awesome()
{
    echo ":: Configuring AwesomeWM"
    stow -t ~/ awesome
    confenable awesome 0
}

function i3()
{
    echo ":: Configuring i3"
    stow -t ~/ i3
    confenable i3 0
    echo ":: Installing Compton"
    stow -t ~/ compton
    confenable compton 0
    echo":: Installing dunst"
    stow -t ~/ dunst
    confenable dunst 0
}

function config()
{
    echo ":: Installing Config Files"
    echo ":: Installing XResources"
    mkdir -p ~/.config/xresources/
    stow -t ~/ Xresources
    confenable Xresources 0
    echo ":: Installing Vim"
    stow -t ~/ vim
    confenable vim 0
}

function blackarch()
{
    echo ":: Installing Blackarch Repo"
    curl -O https://blackarch.org/strap.sh && sha1sum strap.sh
    chmod 777 strap.sh
    sudo ./strap.sh
    rm strap.sh
    sudo pacman -Syyu
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
    sshclient mpd
}

function installvpn()
{
    #https://github.com/Angristan/OpenVPN-install
    echo ":: Installing openvpn through git script"
    mkdir $PWD/tmp
    cd tmp
    git clone https://github.com/Angristan/OpenVPN-install.git
    cd OpenVPN-install
    chmod +x openvpn-install.sh
    sudo ./openvpn-install.sh
    cd ../../
    rm tmp -r
    echo ":: Due to current bugs in the script for the Arch distribution, several files still have to be moved/generated."
    echo ":: Please check once in a while if this is still necessary."
    sudo mv /etc/openvpn/server.conf /etc/openvpn/server/
    sudo mv /etc/openvpn/ca.crt /etc/openvpn/server/
    sudo mv /etc/openvpn/server.key /etc/openvpn/server/
    sudo mv /etc/openvpn/server.crt /etc/openvpn/server/
    sudo mv /etc/openvpn/crl.pem /etc/openvpn/server/
    sudo mv /etc/openvpn/tls-auth.key /etc/openvpn/server/
    sudo openssl dhparam -out /etc/openvpn/server/dh.pem 2048
    sudo systemctl enable openvpn-server@server
    sudo systemctl start openvpn-server@server

}

function sshclient()
{
    mkdir ~/.ssh/sockets/ -p
    touch ~/.ssh/config
    read -p ":: What is the server's IP address? " IP
    if [ -z "$1" ]
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

#TODO review
function piholeclient()
{
    sshclient
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
    read -p ":: If nessecary, is your HDD already mounted on /media? [Y/n]" -r
    if [[ $REPLY =~ ^[Nn]$ ]]; then
        read -p ":: Please enter device name (e.g. /dev/sda2)"
        echo ":: Mounting $REPLY"
        sudo mount $REPLY /media
        read -p $'\x0a:: I assume you also want the drive auto-mounted? [Y/n]' -r
        if [[ $REPLY =~ ^[Yy]$ ]] || [[ $REPLY == "" ]];then
            echo ":: Putting $REPLY drive in automount."
            UUID=$(sudo blkid /dev/sda1)
            echo "UUID=$UUID /media ext4 acl,noatime,nofail,x-systemd.device-timeout=10 0 2" | sudo tee --append /etc/fstab > /dev/null
        fi
    fi
    echo ":: Configuring mpd"
    stow -t ~/ mpd
    confenable mpd 0
    setfacl -m "u:mpd:rwx" /media
    sudo sed  '/\[Unit\]/a RequiresMountsFor=/media/' /usr/lib/systemd/user/mpd.service
    systemctl --user enable mpd
    systemctl --user start mpd
    sudo loginctl enable-linger $USER
    echo ":: Installing PulseAudio Service."
    sudo stow -t / pulseService
    systemctl --user enable pulseaudio #todo unsynced with transceiver
    systemctl --user start pulseaudio
    confenable pulseService 1
    # Makes sure the wifi-dongle doesn't power off causing connection issues
    echo ":: Making sure the Wi-Fi connection doesn't sleep"
    sudo stow -t / WLanPOFix
    confenable WLanPOFix 1
    echo ":: Configuring Beets audio manager"
    stow -t ~/ beets
    confenable beets 0
    echo ":: Configuring Audio Client"
    stow -t ~/ ncmpcpp
    confenable ncmpcpp 0
}

function pulsetransceiver()
{
    echo ":: Configuring PulseAudio for streaming"
    stow -t ~/ pulsetransceiver
    confenable pulsetransceiver 0
    sudo systemctl start avahi-daemon
    sudo systemctl enable avahi-daemon
    systemctl --user enable pulseaudio
    sudo loginctl enable-linger $USER
}

function pulsebluetooth()
{
    echo ":: Configuring PulseAudio for Bluetooth"
    sudo ln -sf $PWD/pulseBluetooth/etc/bluetooth/* /etc/bluetooth/
    echo ":: You still need to manually pair and trust the device fam"
    confenable pulseBluetooth 2
}

function windowspassthrough(){
    echo ":: Enabling libvirt for passthrough"
    sudo systemctl enable --now libvirtd
    sudo systemctl enable virtlogd.socket
    echo ":: Read the README in ./vm for instructions how to do the passthrough"
}

function restow(){
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
                for DIR in $(find . -type f -name '*f*' | sed -r 's|/[^/]+$||' | sort -u); do
                    sudo ln $config/$DIR/* $DIR/
                done
                ;;
            *)
                echo ":: WARNING: ERROR FOUND IN CONFIGURATION FILE"
                echo ":: ABORTING"
                exit 1
                ;;
        esac
    done < $CONFIG_FILE
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
            exit 0
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
        INSTALL_QUEUE+="an2linuxserver-git lightdm lightdm-gtk-greeter gtk-theme-arc-git "
        CONFIG_QUEUE+="main ssh "
    fi
fi
read -p ':: Do you want to use this machine as a Deluge Server? [Y/n]' -r
if [[ $REPLY =~ ^[Yy]$ ]] || [[ $REPLY == "" ]];then
    INSTALL_QUEUE+="python2-service-identity python2-mako deluge "
    CONFIG_QUEUE+="delugeserver "
fi
read -p ':: Do you want to use this machine as a Syncthing server? [Y/n]' -r
if [[ $REPLY =~ ^[Yy]$ ]] || [[ $REPLY == "" ]];then
    INSTALL_QUEUE+="syncthing "
    CONFIG_QUEUE+="syncthing "
fi
read -p ':: Do you want to install/update your configuration files? [Y/n]' -r
if [[ $REPLY =~ ^[Yy]$ ]] || [[ $REPLY == "" ]];then
    CONFIG_QUEUE+="config "
fi
read -p ':: Do you want to install the BlackArch repositories? [Y/n]' -r
if [[ $REPLY =~ ^[Yy]$ ]] || [[ $REPLY == "" ]];then
    CONFIG_QUEUE+="blackarch "
fi
read -p ':: Do you want to use this machine for passthrough? [Y/n]' -r
if [[ $REPLY =~ ^[Yy]$ ]] || [[ $REPLY == "" ]];then
    INSTALL_QUEUE+="virt-manager qemu libvirt ovmf bridge-utils "
    CONFIG_QUEUE+="windowspassthrough "
fi
read -p ':: Do you want to use this machine as an Audio Server? [Y/n]' -r
if [[ $REPLY =~ ^[Yy]$ ]] || [[ $REPLY == "" ]];then
    INSTALL_QUEUE+="mpd mlocate screenfetch alsa-utils pulseaudio beets python2-discogs-client python2-flask ncmpcpp "
    CONFIG_QUEUE+="audioserver "
else
    read -p ':: Do you want to use this machine as an Audio Client instead? [Y/n]'  -r
    if [[ $REPLY =~ ^[Yy]$ ]] || [[ $REPLY == "" ]];then
        CONFIG_QUEUE+="audioclient "
    fi
fi
read -p ':: Do you want Bluetooth? [Y/n]' -r
if [[ $REPLY =~ ^[Yy]$ ]] || [[ $REPLY == "" ]];then
    INSTALL_QUEUE+="blueman "
    CONFIG_QUEUE+="bluetooth "
fi
read -p ':: Should this device be able to stream audio to/from other devices? [Y/n]'  -r
if [[ $REPLY =~ ^[Yy]$ ]] || [[ $REPLY == "" ]];then
    INSTALL_QUEUE+="pulseaudio-zeroconf avahi paprefs pavucontrol ttf-droid "
    CONFIG_QUEUE+="pulsetransceiver "
    read -p ":: Do you also want Bluetooth streaming on this device? [Y/n]" -r
    if [[ $REPLY =~ ^[Yy]$ ]] || [[ $REPLY == "" ]];then
        INSTALL_QUEUE+="pulseaudio-alsa pulseaudio-bluetooth bluez bluez-libs bluez-utils bluez-firmware "
        CONFIG_QUEUE+="pulsebluetooth "
    fi
fi
read -p ':: Will this machine be connected to a pi-hole? [Y/n]' -r
if [[ $REPLY =~ ^[Yy]$ ]] || [[ $REPLY == "" ]];then
    CONFIG_QUEUE+="piholeclient "
fi
read -p ':: Will this machine use awesome as WM? [Y/n]' -r
if [[ $REPLY =~ ^[Yy]$ ]] || [[ $REPLY == "" ]];then
    INSTALL_QUEUE+="awesome lain-git "
    CONFIG_QUEUE+="awesome "
else
    read -p ':: Will this machine use i3 instead? [Y/n]' -r
    if [[ $REPLY =~ ^[Yy]$ ]] || [[ $REPLY == "" ]];then
        INSTALL_QUEUE+="i3lock-blur i3-gaps rofi compton py3status python-mpd2 python-requests compton dunst "
        CONFIG_QUEUE+="i3 "
    fi
fi
read -p ':: Do you want to install zsh as shell? [Y/n]' -r
if [[ $REPLY =~ ^[Yy]$ ]] || [[ $REPLY == "" ]];then
    INSTALL_QUEUE+="oh-my-zsh-git zsh zsh-completions pkgfile "
    CONFIG_QUEUE+="zsh "
else
    echo ':: WARNING: THE FOLLOWING IS STILL VERY EXPERIMENTAL'
    read -p ':: Do you want to install xonsh as shell instead? [Y/n]' -r
    if [[ $REPLY =~ ^[Yy]$ ]] || [[ $REPLY == "" ]];then
        INSTALL_QUEUE+="xonsh "
        CONFIG_QUEUE+="xonsh "
    fi
fi
read -p ':: Is this an odroid C2 without working audio? [Y/n]' -r
if [[ $REPLY =~ ^[Yy]$ ]] || [[ $REPLY == "" ]];then
    CONFIG_QUEUE+="OdroidC2AudioFix "
fi
read -p ':: Set up as VPN point? [Y/n]' -r
if [[ $REPLY =~ ^[Yy]$ ]] || [[ $REPLY == "" ]];then
    CONFIG_QUEUE+="installvpn "
fi
install
configure
addsshclients
echo ':: Install script terminating'

