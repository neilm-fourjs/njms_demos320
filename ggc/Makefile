
export CLASSPATH=$(FGLDIR)/testing_utilities/ggc/ggc.jar:$(FGLDIR)/lib/fgl.jar

export GENVER=320
export BIN=bin$(GENVER)

export PROJBASE=..
export DBTYPE=pgs
export GBC=gbc-clean
export GBCPROJDIR=/opt/fourjs/gbc-current
export MUSICDIR=~/Music

export RENDERER=ur

export FGLGBCDIR=$(GBCPROJDIR)/dist/customization/$(GBC)
export FGLIMAGEPATH=$(PROJBASE)/pics:$(PROJBASE)/pics/fa5.txt
export FGLRESOURCEPATH=$(PROJBASE)/etc
export FGLPROFILE=$(PROJBASE)/etc/$(DBTYPE)/profile:$(PROJBASE)/etc/profile.$(RENDERER)
export FGLLDPATH=$(FGLDIR)/testing_utilities/ggc/lib:../g2_lib/bin$(GENVER):$(GREDIR)/lib

all: matdes.42m oe_test.42m

matdes.log:
	cd ../$(BIN) && fglrun --start-guilog=../ggc/$@ materialDesignTest.42r

matdes.4gl: matdes.log
	ggcgen bdl $^

matdes.42m: matdes.4gl
	fglcomp $^

run: matdes.42m
	fglrun matdes ua --url http://localhost/g/ua/r/materialDesignTest

oe_test.log: 
	cd ../$(BIN) && fglrun --start-guilog=../ggc/$@ orderEntry.42r S 1

oe_test.4gl: oe_test.log
	ggcgen bdl $^

oe_test.42m: oe_test.4gl
	fglcomp $^

run_oe_test: oe_test.42m
	fglrun oe_test.42m tcp --working-directory ../$(BIN) --command-line 'fglrun orderEntry.42r S 1'
