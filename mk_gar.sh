#!/bin/bash

# Set up variables
DB=pgs
FILE=distbin/njms_demos${GENVER}_${DB}.gar
DISTARC=distarc

# Clean previous archive folder
if [ -d $DISTARC ]; then
	rm -rf $DISTARC
fi

# Make archive folder
mkdir -p $DISTARC/bin/g2_lib
mkdir $DISTARC/bin/applib
mkdir $DISTARC/bin/glm
mkdir $DISTARC/pics
mkdir $DISTARC/etc

# Copy files to archive folder
cp njm_app_bin${GENVER}/*.42? $DISTARC/bin
cp njm_app_bin${GENVER}/g2_lib/*.42? $DISTARC/bin/g2_lib
cp njm_app_bin${GENVER}/applib/*.42? $DISTARC/bin/applib
cp njm_app_bin${GENVER}/glm/*.42? $DISTARC/bin/glm
#cp g2_lib/bin320/*.42? $DISTARC/bin
cp gas_deploy/*.xcf $DISTARC/
cp etc/* $DISTARC/etc 2> /dev/null
cp etc/$DB/* $DISTARC/etc
cp etc/progs.txt $DISTARC/etc
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
