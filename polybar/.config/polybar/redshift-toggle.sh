#!/bin/sh

#The command for starting compton
#always keep the -b argument!
REDSHIFT="redshift -l 51.291:4.492"

if pgrep -x "redshift" > /dev/null
then
	killall redshift
else
	$REDSHIFT &> /dev/null &
fi
