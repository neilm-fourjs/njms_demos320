export GENVER=401
. env$GENVER

export BIN=bin$GENVER

export PROJBASE=$PWD
export DBTYPE=pgs
export GBC=gbc-clean
export GBCPROJDIR=/opt/fourjs/gbc-current
export APP=njms_demos
export ARCH=$APP$GENVER_$DBTYPE
export GASCFG=$FGLASDIR/etc/as.xcf
export MUSICDIR=~/Music

export FGLGBCDIR=$GBCPROJDIR/dist/customization/$GBC
export FGLIMAGEPATH=$PROJBASE/pics:$PROJBASE/pics/fa5.txt
export FGLRESOURCEPATH=$PROJBASE/etc
export FGLPROFILE=$PROJBASE/etc/$DBTYPE/profile:$PROJBASE/etc/profile
export FGLLDPATH=../g2_lib/bin$GENVER:$GREDIR/lib

export DB_LOCALE=en_GB.utf8
export LANG=en_GB.utf8

