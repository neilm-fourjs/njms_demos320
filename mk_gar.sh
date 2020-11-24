#!/bin/bash

# Set up variables
DB=pgs
FILE=distbin/njms_demos320_${DB}.gar
DISTARC=distarc

# Clean previous archive folder
if [ -d $DISTARC ]; then
	rm -rf $DISTARC
fi

# Make archive folder
mkdir -p $DISTARC/bin
mkdir $DISTARC/pics
mkdir $DISTARC/etc

# Copy files to archive folder
cp njm_app_bin/*.42? $DISTARC/bin
#cp g2_lib/bin320/*.42? $DISTARC/bin
cp gas_deploy/*.xcf $DISTARC/
cp etc/* $DISTARC/etc 2> /dev/null
cp etc/$DB/* $DISTARC/etc
cp -r pics/* $DISTARC/pics

# build list of .xcf files
cd gas_deploy
for file in $(ls -1 *.xcf)
do
APPS+=--application
APPS+=" "
APPS+=$file
APPS+=" "
done
cd ..

# build the gar file
echo fglgar gar -o $FILE -s $DISTARC/ --resource ./pics $APPS
fglgar gar -o $FILE -s $DISTARC/ --resource ./pics $APPS
