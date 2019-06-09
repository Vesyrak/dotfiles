#!/bin/bash
for f in ./scripts/core/*; do source $f; done

function dockerUbuntu() {
  install apt-transport-https ca-certificates curl software-properties-common
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
  apt-cache policy docker-ce
  install docker-ce
  
  sudo usermod -aG docker ${USER}
}

function dockerComposeUbuntu()
{
  sudo curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose

}

dockerUbuntu
dockerComposeUbuntu
