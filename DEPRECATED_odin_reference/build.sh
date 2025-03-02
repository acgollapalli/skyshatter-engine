#!/bin/sh

SCRIPTPATH=$(dirname "$SCRIPT")
BUILDPATH=$(pwd)
BUILD_COMMAND=./odin/odin

COLLECTIONS="--collection:net=$SCRIPTPATH/net/"

is_windows=false

if [ "$(uname)" = 'Linux' ]; then
	echo "We're on Linux"
	if [ -f "/etc/wsl.conf" ]; then
	    echo "We're on WSL"
	    BUILD_COMMAND=./odin/odin.exe
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

if [ $1 = 'test' ]; then 
	$BUILD_COMMAND test $2 $COLLECTIONS
else 
	$BUILD_COMMAND build $1 "$COLLECTIONS"
fi

