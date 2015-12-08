# GNU-Linux-Config-Files

Use install.sh to automatically install the symlinks.
The pacman database has to be manually installed.

Be sure to check changed config files often, the following command helps.
```
pacman -Qii | awk '/^MODIFIED/ {print $2}'
```
