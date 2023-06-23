#!/bin/bash

GENVER=${GENVER:-401}
DIR=../njm_app_bin$GENVER

if [ ! -e $DIR ]; then
	DIR=../njm_app_bin
fi

echo DIR=$DIR
cd $DIR
#export FGLPROFILE=../etc/profile.ur
export FGLRESOURCEPATH=../etc
export FGLIMAGEPATH=$FGLDIR/lib/image2font.txt:$FGLDIR/lib
if [ "$1" == "njm" ]; then
	export FGLIMAGEPATH=../pics/njmdemos_i2f.txt:../pics
fi
if [ "$1" == "fa5" ]; then
	export FGLIMAGEPATH=../pics/fa5.txt:../pics
fi
if [ "$1" == "mdi" ]; then
	export FGLIMAGEPATH=../pics/gmdi.txt:../pics
fi
fglrun fontAwesome S $1
