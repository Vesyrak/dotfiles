# GNU-Linux-Config-Files

Use install.sh to install the files you would like to install. Install as user, not as root. 
There is a built-in command to add a new user if preferred. 

##Usage:
./install.sh

###Command Options:
  - createuser: Create admin user
  - main: Creates Base Install
  - mainpy: Creates Base Install for Raspberry Pi
  - config: Installs main's config files
  - zsh: Installs and enables ZSH
  - xonsh: Installs and enables XONSH
  - i3: Installs and configures i3
  - i3rpi: Installs and configures i3, somewhat optimized for a raspberry pi
  - awesome: Installs and configures awesome
  - blackarch: Installs Blackarch Repo
  - gaming: Installs base gaming programs (TODO)
  - delugeserver: Configures the system to be  a deluge server
  - audioserver: Sets up system as MPD server
  - audioclient: Sets up system for MPD Connection. (NOTE: Actually sets system up for easy ncmcpp connecting via ssh)
  - piholeclient: Sets up dns for a pi-hole client. Currently manipulates connman dns settings.

##Todo:
  - Create --help section
  - Adding and seperating Graphical Drivers per device.
  - Updating user requirements for gaming (and probably others)
    - NOTE: If steam doesn't work, it is because of the outdated libraries it
  ships with. Check
  https://wiki.archlinux.org/index.php/Steam/Game-specific_troubleshooting
  and https://bbs.archlinux.org/viewtopic.php?id=193802 for solutions.
  - ~~Network configuration -> Porting everything to connman (Or other
    alternative)~~
  - ~~Move away from Systemd~~ (Scrapped due to unneccesary changes)
  - Harden System
  - Find best vim version & plugins
