
export GENVER=400
#export GENVER=320
export BIN=njm_app_bin$(GENVER)

export PROJBASE=$(PWD)
export DBTYPE=pgs
export GBC=gbc-clean2
export GBCPROJDIR=/opt/fourjs/gbc-current
export APP=njms_demos
export ARCH=$(APP)$(GENVER)_$(DBTYPE)
export GASCFG=$(FGLASDIR)/etc/as.xcf
export MUSICDIR=~/Music

export RENDERER=ur

export FGLGBCDIR=$(GBCPROJDIR)/dist/customization/$(GBC)
export FGLIMAGEPATH=$(PROJBASE)/pics:$(PROJBASE)/pics/fa5.txt
export FGLRESOURCEPATH=$(PROJBASE)/etc
export FGLPROFILE=$(PROJBASE)/etc/$(DBTYPE)/profile:$(PROJBASE)/etc/profile.$(RENDERER)
export FGLLDPATH=njm_app_bin:$(GREDIR)/lib

export LANG=en_GB.utf8

TARGETS=\
	gars\
	gbc_clean/distbin/gbc-clean.zip\
	gbc_njm/distbin/gbc-njm.zip\
	gbc_mdi/distbin/gbc-mdi.zip

all: $(TARGETS)

$(BIN)/g2_lib.42x:
	cd g2_lib && gsmake g2_lib.4pw

$(BIN)/menu.42r: 
	gsmake $(APP)$(GENVER).4pw

gars: $(BIN)/menu.42r

gbc_clean/gbc-current:
	cd gbc_clean && ln -s $(GBCPROJDIR)

gbc_clean/distbin/gbc-clean.zip: gbc_clean/gbc-current
	cd gbc_clean && make

gbc_njm/gbc-current:
	cd gbc_njm && ln -s $(GBCPROJDIR)

gbc_njm/distbin/gbc-njm.zip: gbc_njm/gbc-current
	cd gbc_njm && make

gbc_mdi/gbc-current:
	cd gbc_mdi && ln -s $(GBCPROJDIR)

gbc_mdi/distbin/gbc-mdi.zip: gbc_mdi/gbc-current
	cd gbc_mdi && make

clean:
	find . -name \*.42? -delete
	find . -name \*.zip -delete
	find . -name \*.gar -delete
	find . -name \*.4pdb -delete

undeploy: 
	cd distbin && gasadmin gar -f $(GASCFG) --disable-archive $(ARCH) | true
	cd distbin && gasadmin gar -f $(GASCFG) --undeploy-archive $(ARCH).gar
	rm -f distbin/.deployed

deploy: 
	cd distbin && gasadmin gar -f $(GASCFG) --deploy-archive $(ARCH).gar
	cd distbin && gasadmin gar -f $(GASCFG) --enable-archive $(ARCH)
	echo "deployed" > distbin/.deployed

redeploy: undeploy deploy

run: $(BIN)/menu.42r
	cd $(BIN) && fglrun menu.42r

runur: $(BIN)/menu.42r
	export FGLGBCDIR=$(GBCPROJDIR)/dist/customization/gbc-clean && cd $(BIN) && fglrun menu.42r

runnat: $(BIN)/menu.42r
	FGLPROFILE=$(PROJBASE)/etc/$(DBTYPE)/profile:$(PROJBASE)/etc/profile.nat && cd $(BIN) && fglrun menu.42r

rundef: $(BIN)/menu.42r
	unset FGLGBCDIR && cd $(BIN) && fglrun menu.42r

clear:
	clear

runmatdes: clear $(BIN)/menu.42r
	export FGLPROFILE=../etc/profile.nat && \
	cd $(BIN) && fglrun materialDesignTest.42r

runmatdesur: clear $(BIN)/menu.42r
	echo $(GBC) && export FGLPROFILE=../etc/profile.ur && \
	cd $(BIN) && fglrun materialDesignTest.42r

# Not supported!
runmdi: $(BIN)/menu.42r gbc_mdi/distbin/gbc-mdi.zip
	export FGLGBCDIR=$(GBCPROJDIR)/dist/customization/gbc-mdi && cd $(BIN) && fglrun container.42r

recmatdes: $(BIN)/menu.42r
	cd $(BIN) && fglrun --start-guilog=../ggc/matdes.log materialDesignTest.42r
