
PROJBASE=..
TRG=$(PROJBASE)/bin$(GENVER)
G2LIB=$(PROJBASE)/g2_lib/g2_lib
INCL=-I gl_dynMaint -I app
export FGLIMAGEPATH=$(PROJBASE)/pics:$(PROJBASE)/pics/fa6.txt
export FGLRESOURCEPATH=$(PROJBASE)/etc
export FGLLDPATH=$(GREDIR)/lib
export FGLDBPATH=$(PROJBASE)/etc

FORMS=$(wildcard */*.per)

DB=\
	db/mk_db.4gl

DYN=\
	gl_dynMaing/ dynMaint.4gl

APP=\
	app/cust_mnt.4gl \
	app/dm_stock.4gl \
	app/ordent.4gl \
	app/printInvoices.4gl \
	app/webOE2.4gl \
	app/webOE.4gl

APPWEB=\
	app_web/custmnt.4gl \
	app_web/custs.4gl \
	app_web/prodmnt.4gl \
	app_web/prods.4gl \
	app_web/quotemnt.4gl \
	app_web/quotes.4gl


SYS=\
	sys/container.4gl \
	sys/login_hist.4gl \
	sys/menu.4gl \
	sys/menu_mnt.4gl \
	sys/user_mnt.4gl 

DEMOS=\
	demos/dispArr.4gl \
	demos/expenses.4gl \
	demos/ipodTree.4gl \
	demos/listView.4gl \
	demos/multi_cell_sel.4gl \
	demos/picflow.4gl \
	demos/showfile.4gl \
	demos/table.4gl \
	demos/wc_aircraft.4gl \
	demos/wc_amcharts.4gl \
	demos/wc_c3charts.4gl \
	demos/wc_calendar_demo.4gl \
	demos/wc_d3Charts.4gl \
	demos/wc_gallery.4gl \
	demos/wc_gauge.4gl \
	demos/wc_gm.4gl \
	demos/wc_kite.4gl \
	demos/wc_music.4gl \
	demos/wc_richtext.4gl \
	demos/widgets.4gl \
	demos/wizard_dnd.4gl \
	demos/wizard_md.4gl \
	demos/wizard_mrs.4gl \
	demos/wizard_sd.4gl

UTILS=\
	utils/fontAwesome.4gl \
	utils/gbc_theme.4gl \
	utils/gre_test4rp.4gl \
	utils/icons_2_image2font.4gl \
	utils/matDesTest.4gl

API=api/njm_demoapi.4gl

all: $(TRG) forms build_db build_dyn build_aw build_app build_sys build_demos build_utils build_api

$(TRG):
	mkdir $@

forms: $(FORMS)
	fglform -M --make -o $(TRG) $^

build_db: $(DB)
	fglcomp -M --make -o $(TRG) $^

build_dyn: $(APP)
	fglcomp -M --make -o $(TRG) $(INCL) $^

build_aw: $(APPWEB)
	fglcomp -M --make -o $(TRG) $^

build_app: $(APP)
	fglcomp -M --make -o $(TRG) $^

build_sys: $(SYS)
	fglcomp -M --make -o $(TRG) $(INCL) $^

build_demos: $(DEMOS)
	fglcomp -M --make -o $(TRG) $^

build_utils: $(UTILS)
	fglcomp -M --make -o $(TRG) $^

build_api: $(API)
	fglcomp -M --make -o $(TRG) $^

run:
	cd $(TRG) && fglrun menu

clean:
	rm $(TRG)/*.42?

env:
	env | sort

code:
	code .
