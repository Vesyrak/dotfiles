# GNU-Linux-Config-Files

Use install.sh to install the files you would like to install. Standard user for everything is "reinout".

Be sure to check changed config files often, the following command helps.
```
pacman -Qii | awk '/^MODIFIED/ {print $2}'
```

##Todo:
  - Adding and seperating Graphical Drivers per device.
  - Updating user requirements for gaming (and probably others)
  - Testing
  - Network configuration -> Porting everything to netctl 
