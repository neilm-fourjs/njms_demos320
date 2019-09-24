#!/bin/bash
BASE=$(pwd)
export CLASSPATH=$FGLDIR/testing_utilities/ggc/ggc.jar:$FGLDIR/lib/fgl.jar
export GENVER=320
export BIN=bin$GENVER
export PROJBASE=..
export DBTYPE=pgs
export GBC=gbc-clean
export GBCPROJDIR=/opt/fourjs/gbc-current
export MUSICDIR=~/Music
export RENDERER=ur
export FGLGBCDIR=$GBCPROJDIR/dist/customization/$GBC
export FGLIMAGEPATH=$PROJBASE/pics:$PROJBASE/pics/fa5.txt
export FGLRESOURCEPATH=$PROJBASE/etc
export FGLPROFILE=$PROJBASE/etc/$DBTYPE/profile:$PROJBASE/etc/profile.$RENDERER
export FGLLDPATH=$FGLDIR/testing_utilities/ggc/lib:../g2_lib/bin$GENVER:$GREDIR/lib

# Run local test
TEST=oe_test
echo "Running Test: $TEST ..."
fglrun $TEST tcp --working-directory $PROJBASE/$BIN --command-line 'fglrun orderEntry.42r S 1' > $TEST.rpt 2> $TEST.err
if [ $? -ne 0 ]; then
	echo "Test Failed to Run!"
else
	echo "Test Okay!"
fi

sleep 2

# Run test via GAS
TEST=matdes
echo "Running Test: $TEST ..."
fglrun $TEST ua --url http://localhost/g/ua/r/materialDesignTest > $TEST.rpt 2> $TEST.err
if [ $? -ne 0 ]; then
	echo "Test Failed to Run!"
else
	echo "Test Okay!"
fi

