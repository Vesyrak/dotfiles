#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

/usr/bin/xset b off
nm-applet --sm-disable &

xrdb -merge ~/.config/xresources/Netron.Xresource
feh --bg-scale ~/Wallpapers/red.png --bg-scale ~/Wallpapers/blu.png
compton -b
export STEAM_RUNTIME=0

