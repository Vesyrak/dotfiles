#!/bin/bash

INSTALL_QUEUE=""
CONFIG_QUEUE=""
CUSTOM=false

. /etc/os-release
OS=$NAME
if [[ $OS != "Ubuntu" || $OS == "Debian GNU/Linux" ]]; then
	print "Warning: unsupported OS!"
	exit 1
fi

for f in ./scripts/core/*; do source $f; done

function install_queue()
{
	install $INSTALL_QUEUE
}

function configure(){
	print "Starting Configuring"
	arr=($CONFIG_QUEUE)
	for config in ${arr[@]}; do
		eval ./scripts/$config.sh $SUFFIX
	done
	print "Finished Configuring"
}

TODO=""
export TODO

checkuser
# Now go through all the options
options=($@)
for config in ${options[@]}; do
	CUSTOM=true
	case "$config" in
		--min)
		install $(cat minpkglist.ubuntu)
		./scripts/ssh.sh
		;;
		--full)
		install $(cat minpkglist.ubuntu)
		install $(cat majpkglist.ubuntu)
		./scripts/atom.sh 
		./scripts/etcher.sh 
		./scripts/ssh.sh 
		;;
		--bluetooth) ./scripts/bluetooth.sh ;;
		--docker) ./scripts/docker.sh;;
		--fstab) ./scripts/fstab.sh ;;
		--ssd) ./scripts/ssd.sh ;;
		--ssh) ./scripts/ssh.sh ;;
		--syncthing) ./scripts/syncthing.sh ;;
		--zsh) ./scripts/zsh.sh ;;
		--config) config;;
		--createuser) createuser;;
		--restow) restow;;
		*) break;;
	esac
done

if [[ $CUSTOM == "true" ]]; then
	exit 0
fi

read -p ':: Do you want to install a minimal package list? [Y/n] ' -r
if [[ $REPLY =~ ^[Yy]$ ]] || [[ $REPLY == "" ]];then
	INSTALL_QUEUE+=$(cat minpkglist.ubuntu)
	INSTALL_QUEUE+=" "
	CONFIG_QUEUE+="ssh "
else
	read -p ':: Do you want to install a complete package list? [Y/n] ' -r
	if [[ $REPLY =~ ^[Yy]$ ]] || [[ $REPLY == "" ]];then
		INSTALL_QUEUE+=$(cat minpkglist.ubuntu)
		INSTALL_QUEUE+=" "
		INSTALL_QUEUE+=$(cat majpkglist.ubuntu)
		INSTALL_QUEUE+=" "
		CONFIG_QUEUE+="ssh atom etcher "
	fi
fi

function request_config()
{
	read -p ":: $1 [Y/n] " -r
	if [[ $REPLY =~ ^[Yy]$ ]] || [[ $REPLY == "" ]];then
		CONFIG_QUEUE+="$2 "
	fi
}

request_config 'Do you want Bluetooth?' "bluetooth"
request_config 'Do you want to install docker?' "docker"
request_config 'Do you want to add to your fstab?' "fstab"
request_config 'Using an SSD?' "ssd"
request_config 'Do you want to use this machine as a Syncthing server?' "syncthing"
request_config 'Do you want to install zsh as shell?' "zsh"
request_config 'Do you want to install i3 on a Kubuntu desktop?' 'ki3'

read -p ':: Do you want to install/update your configuration files? [Y/n] ' -r
if [[ $REPLY =~ ^[Yy]$ ]] || [[ $REPLY == "" ]];then
	install stow
	config
fi

install_queue
configure
addsshclients
print 'Updating DB'
sudo updatedb
print 'Install script terminating'
finish
