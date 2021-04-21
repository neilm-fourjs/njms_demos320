#!/bin/bash
cd ../njm_app_bin
#export FGLPROFILE=../etc/profile.ur
export FGLRESOURCEPATH=../etc
export FGLIMAGEPATH=$FGLDIR/lib/image2font.txt:$FGLDIR/lib
if [ "$1" == "fa5" ]; then
	export FGLIMAGEPATH=../pics/fa5.txt:../pics
fi
if [ "$1" == "mdi" ]; then
	export FGLIMAGEPATH=../pics/image2font2.txt:../pics
fi
fglrun fontAwesome.42r S $1
