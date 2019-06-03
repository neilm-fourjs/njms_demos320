
export GENVER=320
export BIN=bin$(GENVER)

export PROJBASE=$(PWD)
export DBTYPE=pgs
export GBC=gbc-clean
export GBCPROJDIR=/opt/fourjs/gbc-current
export APP=njms_demos
export ARCH=$(APP)$(GENVER)_$(DBTYPE)
export GASCFG=$(FGLASDIR)/etc/as.xcf
export MUSICDIR=~/Music

export RENDERER=ur

export FGLGBCDIR=$(GBCPROJDIR)/dist/customization/$(GBC)
export FGLIMAGEPATH=$(PROJBASE)/pics:$(FGLDIR)/lib/image2font.txt
export FGLRESOURCEPATH=$(PROJBASE)/etc
export FGLPROFILE=$(PROJBASE)/etc/$(DBTYPE)/profile:$(PROJBASE)/etc/profile.$(RENDERER)
export FGLLDPATH=../g2_lib/bin$(GENVER):$(GREDIR)/lib

export LANG=en_GB.utf8

TARGETS=\
	$(BIN)/menu.42r\
	gbc_clean/distbin/gbc-clean.zip\
	gbc_njm/distbin/gbc-njm.zip\
	gbc_mdi/distbin/gbc-mdi.zip

all: $(TARGETS)

g2_lib/$(BIN)/g2_lib.42x:
	cd g2_lib && gsmake g2_lib.4pw

$(BIN)/menu.42r: g2_lib/$(BIN)/g2_lib.42x
	gsmake $(APP)$(GENVER).4pw

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

run: $(BIN)/menu.42r
	cd $(BIN); fglrun menu.42r


undeploy: 
	cd distbin && gasadmin gar -f $(GASCFG) --disable-archive $(ARCH) | true
	cd distbin && gasadmin gar -f $(GASCFG) --undeploy-archive $(ARCH).gar
	rm -f distbin/.deployed

deploy: 
	cd distbin && gasadmin gar -f $(GASCFG) --deploy-archive $(ARCH).gar
	cd distbin && gasadmin gar -f $(GASCFG) --enable-archive $(ARCH)
	echo "deployed" > distbin/.deployed

redeploy: undeploy deploy


# Not supported!
runmdi: $(BIN)/menu.42r gbc_mdi/distbin/gbc-mdi.zip
	export FGLGBCDIR=$(GBCPROJDIR)/dist/customization/gbc-mdi && cd $(BIN) && fglrun container.42r
