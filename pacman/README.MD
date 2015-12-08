# Pacman

Before uploading a new pacman database, make sure to check your pacgraph and remove any orphans.
```
pacman -Rns $(pacman -Qtdq)
```

Backing up:
```
tar -cjf pacman_database.tar.bz2 /var/lib/pacman/local
```

Restoring (in / folder)
```
tar -xjvf pacman_database.tar.bz2
```
*NOTE: if after restoration it complains about duplicate database entries, simply remove the older folders/versions at /var/lib/pacman/local/*
