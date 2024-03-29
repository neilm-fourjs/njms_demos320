-- Simple Google Maps Demo
IMPORT util

IMPORT FGL g2_init
IMPORT FGL g2_core
IMPORT FGL g2_appInfo
IMPORT FGL g2_about
CONSTANT C_PRGVER  = "3.1"
CONSTANT C_PRGDESC = "WC GoogleMaps Demo"
CONSTANT C_PRGAUTH = "Neil J.Martin"
CONSTANT C_PRGICON = "logo_dark"

MAIN
	DEFINE wc_gm, in_data STRING
	DEFINE l_latlng_rec RECORD
		lat FLOAT,
		lng FLOAT
	END RECORD

	CALL g2_core.m_appInfo.progInfo(C_PRGDESC, C_PRGAUTH, C_PRGVER, C_PRGICON)
	CALL g2_init.g2_init(ARG_VAL(1), "default")

	OPEN FORM f FROM "wc_gm"
	DISPLAY FORM f

	LET l_latlng_rec.lat = "50.8462723212"
	LET l_latlng_rec.lng = "-0.2846145630"
	LET wc_gm            = "."
	CALL wc_setProp("lat", l_latlng_rec.lat)
	CALL wc_setProp("lng", l_latlng_rec.lng)

	INPUT BY NAME wc_gm, l_latlng_rec.*, in_data ATTRIBUTE(UNBUFFERED, WITHOUT DEFAULTS)
		ON ACTION close
			EXIT INPUT
		ON ACTION quit
			EXIT INPUT
		ON ACTION go
			CALL wc_setProp("lat", l_latlng_rec.lat)
			CALL wc_setProp("lng", l_latlng_rec.lng)

		ON ACTION mapclicked
			LET in_data = wc_gm
			CALL util.JSONObject.parse(in_data).toFGL(l_latlng_rec) -- turn json string into fgl rec

		ON ACTION about
			CALL g2_about.g2_about()
	END INPUT
	CALL g2_core.g2_exitProgram(0, %"Program Finished")
END MAIN
--------------------------------------------------------------------------------
-- Set a Property in the AUI
FUNCTION wc_setProp(prop_name STRING, value STRING)
	DEFINE w ui.Window
	DEFINE n om.domNode
	LET w = ui.Window.getCurrent()
	LET n = w.findNode("Property", prop_name)
	IF n IS NULL THEN
		RETURN
	END IF -- just in case!
	CALL n.setAttribute("value", value)
END FUNCTION
