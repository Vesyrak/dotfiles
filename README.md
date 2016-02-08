# GNU-Linux-Config-Files

Use install.sh to install the files you would like to install. Standard user for everything is "reinout".

Be sure to check changed config files often, the following command helps.
```
pacman -Qii | awk '/^MODIFIED/ {print $2}'
```
##Usage:
./install.sh

###Command Options:
  - main: Creates Base Install
  - zsh: Installs and enables ZSH
  - delugeserver: Configures the system to be  a deluge server
  - config: Installs main's config files
  - blackarch: Installs Blackarch Repo
  - gaming: Installs base gaming programs (TODO)
  - audioclient: Sets up system for MPD Connection
  - mainpy: Sets up base raspberry pi
  - audioserver: Sets up system as MPD server

##Todo:
  - Adding and seperating Graphical Drivers per device.
  - Updating user requirements for gaming (and probably others)
  - Network configuration -> Porting everything to netctl (Or other
    alternative) 
  - Move away from Systemd
  - Harden System
  - Find best vim version & plugins
