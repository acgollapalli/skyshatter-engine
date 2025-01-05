#!/bin/sh

SCRIPTPATH=$(dirname "$SCRIPT")
BUILDPATH=$(pwd)

is_windows=false

if [ "$(uname)" = 'Linux' ]; then
	echo "We're on Linux"
	if [ -f "/etc/wsl.conf" ]; then
	    echo "We're on WSL"
	    is_windows=true
	fi
fi

if [ "$(uname)" = 'Darwin' ]; then
	echo "We're on Mac"
fi

if [ "$(uname)" = 'FreeBSD' ]; then
	echo "We're on FreeBSD"
	echo "FreeBSD is untested"
fi

if [ "$(uname)" = 'DragonFly' ]; then
	echo "We're on DragonFly"
	echo "DragonFly is untested"
fi

if [ "$(uname)" = 'OpenBSD' ]; then
	echo "We're on OpenBSD"
	echo "OpenBSD is untested"
fi

if [ "$is_windows" = true ]; then 
	./odin/odin.exe build $1 --collection:net="$SCRIPTPATH/net/"
else 
	./odin/odin build $1 --collection:net="$SCRIPTPATH/net/"
fi

