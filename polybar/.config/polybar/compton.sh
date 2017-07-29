#!/bin/sh

#The icon that would change color
icon=""

if pgrep -x "compton" > /dev/null
then
	echo "%{F#FFFFFF}$icon" #Green
else
	echo "%{F#65737E}$icon" #Gray
fi
