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
        sudo pacman -S base-devel alsa-utils dhcpcd dialog iw wpa_supplicant htop mlocate openssh xorg-xauth xorg-xhost rxvt-unicode sudo wget gvim
        echo ":: System Update Finished"
        ssh
    }

    function main()
    {
        echo ":: Starting System Update"
        sudo pacman -Syu
        sudo pacman -S  awesome base-devel alsa-utils dhcpcd dialog iw wpa_supplicant chromium cmatrix dosfstools feh gimp wget htop gtk-chtheme networkmanager network-manager-applet mpv libreoffice-fresh
        sudo pacman -S mlocate ntfs-3g openssh pacgraph lxrandr rxvt-unicode scrot sudo tmux xorg-xhost xorg-server xorg-xauth xorg-server-utils xorg-xinit xorg-xrdb lightdm-gtk-greeter pulseaudio gvim
        echo ":: System Update Finished"
        echo ":: Don't forget to install a wallpaper for lightdm/awesome, otherwise ERRORS ENSURED"
        echo ":: Enabling NetworkManager"
        sudo systemctl start NetworkManager
        ssh
        echo ":: Enabling lightdm"
        sudo systemctl enable lightdm
        echo ":: Installing lightdm config"
        sudo cp $PWD/lightdm/lightdm-gtk-greeter.conf /etc/lightdm/lightdm-gtk-greeter.conf
        sudo cp $PWD/lightdm/wallpaper.png /etc/lightdm/wallpaper.png
	aur
        echo ":: Starting AUR Installs"
        pacaur -Syu
        pacaur -S gtk-theme-arc-git lain-git pulsemixer
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
        sudo ln -sf $PWD/ssh/sshd_config /etc/ssh
        sudo systemctl restart sshd
    }

    function aur()
    {
        echo ":: Installing AUR"
        sudo pacman -S expac yajl
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
        makepkg
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
        pacaur -S oh-my-zsh-git ttf-droid-sans-mono-slashed-powerline-git
        echo ":: ZSH Installation Finished. Changing Shell..."
        chsh -s /bin/zsh
        echo ":: Default Shell is now ZSH"
        echo ":: Reload Shell to see effects"
        echo ":: Installing ZSH config"
        ln -sf $PWD/zsh/.zshrc ~/.zshrc
        ln -sf $PWD/zsh/.zsh_aliases ~/.zsh_aliases
        ln -sf $PWD/zsh/.zlogin ~/.zlogin
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
        ln -sf $PWD/zsh/.zshrc ~/.zshrc
        ln -sf $PWD/zsh/.zsh_aliases ~/.zsh_aliases
        ln -sf $PWD/zsh/.zlogin ~/.zlogin
        mkdir -p ~/.config/xonsh
        ln -sf $PWD/xonsh/config.json ~/.config/xonsh/config.json
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
        mkdir ~/.config/deluge/
        ln -sf $PWD/deluge/web.conf ~/.config/deluge/
        ln -sf $PWD/deluge/core.conf ~/.config/deluge/
        sudo cp /usr/lib/systemd/system/deluged.service /etc/systemd/system/deluged.service
        read -p "You will have to edit the following config file to change the user from deluge to reinout"
        sudo vim /etc/systemd/system/deluged.service
        echo ":: Creating deluge auth file"
        read -p ":: Please enter the desired username: " name
        read -p ":: Please enter the desired password: " passwd
        echo "$name : $passwd :10" >> ~/.config/deluge/auth
        sudo systemctl enable deluge-web
    }
    function syncthingserver()
    {
        sudo pacman -Syu syncthing
        sudo systemctl enable syncthing@$USER
        sudo systemctl start syncthing@$USER
    }
    function syncthingclient()
    {
        sudo pacman -Syu syncthing
        sudo systemctl --user enable syncthing
        sudo systemctl --user start syncthing
    }
    function awesome()
    {
        echo ":: Installing awesome"
        sudo pacman -S awesome
        echo ":: Installation Finished"
        echo ":: Configuring..."
        echo ":: Installing XProfile"
        ln -sf $PWD/Xorg/.xprofile ~/.xprofile
        echo ":: Installing Xinitrc"
        ln -sf $PWD/Xorg/.xinitrc ~/.xinitrc
        echo ":: Installing awesome"
        ln -sf $PWD/awesome ~/.config/awesome
        echo ":: Awesome Installation completed"
    }
    function config()
    {
        echo ":: Installing Config Files"
        echo ":: Installing XResources"
        mkdir -p ~/.config/xresources/
        ln -sf $PWD/Xorg/xresources/Netron.Xresource ~/.config/xresources/Netron.Xresource
        echo ":: Installing Vim"
        ln -sf $PWD/vim/.vimrc ~/.vimrc
        ln -sf $PWD/vim/.vimrc.plugins ~/.vimrc.plugins
        echo ":: Installing WPA-Enterprise Config Files"
        sudo cp wpa-supplicant-WPA2Enterprise/wpa_supplicant-apwifi /etc/wpa_supplicant/wpa_supplicant-apwifi
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
    function fixlocale(){
        echo ":: Setting locale settings"
        echo "en_US ISO-8859-1" | sudo tee --append /etc/locale.gen > /dev/null
        echo "en_US.UTF-8 UTF-8" | sudo tee --append /etc/locale.gen > /dev/null
        sudo locale-gen
        sudo touch /etc/locale.conf
        echo "LANG=en_US.UTF-8" | sudo tee --append /etc/locale.conf > /dev/null

    }
    function odroidC2audiofix(){
        fixlocale
        echo ":: Installing odroid audio fix"
        sudo cp $PWD/odroidC2audiofix/asound.conf /etc/asound.conf
        sudo chmod 666 /dev/am*
        sudo gpasswd --add $USER audio
        echo ":: Fixing USB sound card error logs"
        sudo touch /etc/modprobe.d/alsa-base.conf
        echo "options snd-usb-audio nrpacks=1" | sudo tee --append /etc/modprobe.d/alsa-base.conf > /dev/null
        echo ":: Reboot to gain audio functionality"

    }
    function gaming()
    {
        # TODO: update user requirements. enable multilib
        sudo pacman -Syu
        sudo pacman -S steam
        pacaur -S steam-fonts
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
        echo "UUID=4f7a9f5a-2bf7-46e2-9560-29f0326293e4 /media ext4 acl,noatime,nofail,x-systemd.device-timeout=10 0 2" | sudo tee -append /etc/fstab > /dev/null
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
        echo "    ControlPersist yes" >> ~/.ssh/config
        echo "    ControlPath ~/.ssh/sockets/socket-%r@%h:%p" >> ~/.ssh/config
        echo ":: Updated ssh config file for easy server access under 'pihole'"
        echo ":: If you want to use the dns server, disable resolv.conf changing by your network manager."
        echo ":: You can do this in e.g. connman by editing connman.service and adding --nodnsproxy to execstart"
        echo ":: Setting the resolv.conf to the server"
        sudo rm /etc/resolv.conf
        sudo touch /etc/resolv.conf
        echo "nameserver $IP" | sudo tee --append /etc/resolv.conf > /dev/null
    }
    function tt-rss()
    {
        sudo pacman -S tt-rss mysql apache php php-apache
        sudo systemctl start httpd
        sudo systemctl enable httpd
        sudo ln -sf $PWD/tt-rss/httpd/httpd.conf /etc/httpd/conf/httpd.conf
        sudo ln -sf /usr/share/webapps/tt-rss /srv/http/tt-rss
        sudo mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
        sudo systemctl enable mariadb
        sudo systemctl start mariadb
        sudo mysql_secure_installation
        echo "CREATE USER 'ttrss'@'localhost' IDENTIFIED BY 'somepassword';"
        echo "CREATE DATABASE ttrss;"
        echo "GRANT ALL PRIVILEGES ON ttrss.* TO "ttrss"@"localhost" IDENTIFIED BY 'somepassword';"
        mysql -p -u root
        sudo ln -sf $PWD/tt-rss/php.ini
        sudo rm /etc/webapps/tt-rss/config.php
        echo "Install using webscript"
    }
    function audioserver()
    {
        sudo pacman -Syu
        sudo pacman -S mpd mlocate screenfetch alsa-utils
        # music linkin'
        sudo ln -sf $PWD/mpd/mpd.conf /etc/mpd.conf
        setfacl -m "u:mpd:rwx" /media
        setfacl -m "u:mpd:rwx" /home/reinout
        # mpd bootin'
        mpd
        sleep 1
        sudo systemctl stop mpd
        sudo systemctl enable mpd
        read -p ":: Put 'RequiresMountsFor=/media/' under [Unit]"
        sudo vim /etc/systemd/system/default.target.wants/mpd.service
        sudo systemctl start mpd

        # Makes sure the wifi-dongle doesn't power off causing connection issues
        sudo ln -sf $PWD/music/WLanPOFix /etc/modprobe.d/8192cu.conf
        echo ":: Be sure to mount your drive on /media/Music, and becoming owner of it!"
        echo ":: Installing Beets audio manager"
        sudo pacman -S beets
        mkdir ~/.config/beets
        ln -sf $PWD/beets/config.yaml ~/.config/beets/
        echo ":: Installing Beets extension dependencies"
        pacaur -S python2-discogs-client
        sudo pacman -S python2-flask
        echo ":: Beets installed"
        echo ":: Installing Audio Client"
        sudo pacman -Syu
        sudo pacman -S ncmpcpp
        mkdir ~/.ncmpcpp
        ln -sf $PWD/ncmpcpp/config /home/reinout/.ncmpcpp/config
        ln -sf $PWD/ncmpcpp/bindings /home/reinout/.ncmpcpp/bindings
        echo ":: Finished Installing Audio Client"
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

