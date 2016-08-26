# GNU-Linux-Config-Files

Use install.sh to install the files you would like to install. Install as user, not as root. 
There is a built-in command to add a new user if preferred. 

##Usage:
Run ./install.sh from inside the directory.

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
