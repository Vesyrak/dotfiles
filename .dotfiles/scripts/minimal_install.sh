#!/bin/bash
for f in ./scripts/core/*; do source $f; done

function minimal_install(){
    INSTALL_QUEUE=""
    #Audio
    INSTALL_QUEUE+="alsa-utils "
    #Monitoring
    INSTALL_QUEUE+="htop "
    #Extracting
    INSTALL_QUEUE+="bzip2 gzip p7zip unzip "
    #File location
    INSTALL_QUEUE+="mlocate "
    #File Systems
    INSTALL_QUEUE+="ntfs-3g dosfstools "
    #Web Fetching
    INSTALL_QUEUE+="wget "
    #ZSH / Terminal
    INSTALL_QUEUE+="rxvt-unicode zsh "
    #Networking
    INSTALL_QUEUE+="bluetooth "
    #Docker
    sudo apt-get purge docker lxc-docker docker-engine docker.io
    sudo apt install curl apt-transport-https ca-certificates software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
    apt-cache policy docker-ce
    INSTALL_QUEUE+="docker-ce "
    #Docker-Compose
    sudo curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose

    #Syncthing
    curl -s https://syncthing.net/release-key.txt | sudo apt-key add -
    echo "deb http://apt.syncthing.net/ syncthing release" | sudo tee /etc/apt/sources.list.d/syncthing.list
    INSTALL_QUEUE+="syncthing xmlstarlet "
}


function minimal_configure(){
    #Networking
    sudo systemctl enable bluetooth
    sudo systemctl start bluetooth
    #Docker
    sudo usermod -aG docker ${USER}
    #Syncthing
    xmlstarlet ed -L -u '/configuration/gui/address' -v 0.0.0.0:8384 .config/syncthing/config.xml
    sudo systemctl enable syncthing@$USER
    sudo systemctl start syncthing@$USER
    todo "Syncthing"
    todo "Further configurations can be done by the webui"
    #ZSH / Terminal
    sudo chsh -s $(which zsh) $USER

}
INSTALL_QUEUE=""
sudo apt update
minimal_install
sudo apt update
sudo apt install $INSTALL_QUEUE
minimal_configure
