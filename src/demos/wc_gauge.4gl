# A simple WC demo for https://www.highcharts.com/demo/gauge-solid

IMPORT util
IMPORT FGL g2_lib.*

CONSTANT C_PRGVER  = "3.1"
CONSTANT C_PRGDESC = "WC Test Demo"
CONSTANT C_PRGAUTH = "Neil J.Martin"
CONSTANT C_PRGICON = "logo_dark"

MAIN
	DEFINE l_debug              BOOLEAN
	DEFINE l_wc_guage, l_slider INTEGER
	DEFINE l_wc_pie             STRING

	CALL g2_core.m_appInfo.progInfo(C_PRGDESC, C_PRGAUTH, C_PRGVER, C_PRGICON)
	CALL g2_init.g2_init(base.Application.getArgument(1), "default")

-- Is the WC debug feature enabled?
	CALL ui.Interface.frontCall("standard", "getenv", ["QTWEBENGINE_REMOTE_DEBUGGING"], l_debug)
	DISPLAY "DEBUG:", l_debug
	CALL util.Math.srand()

	OPEN FORM f FROM "wc_gauge"
	DISPLAY FORM f

	LET l_wc_guage = 50
	LET l_slider   = l_wc_guage
	INPUT BY NAME l_wc_guage, l_wc_pie, l_slider ATTRIBUTES(UNBUFFERED, WITHOUT DEFAULTS)
		ON ACTION refresh
			CALL setGraphTitle("text", "Title set in 4GL INPUT")
			LET l_wc_pie = getData()

		ON ACTION plus5
			LET l_wc_guage = l_wc_guage + 5
			LET l_slider   = l_wc_guage

		ON ACTION minus5
			LET l_wc_guage = l_wc_guage - 5
			LET l_slider   = l_wc_guage

		ON ACTION about
			CALL g2_about.g2_about()

		ON ACTION quit
			EXIT INPUT

		ON CHANGE l_slider
			LET l_wc_guage = l_slider
	END INPUT

	CALL g2_core.g2_exitProgram(0, %"Program Finished")
END MAIN
--------------------------------------------------------------------------------
FUNCTION getData()
	DEFINE jo, sjo util.JSONObject
	DEFINE ja, sja util.JSONArray
	DEFINE li_rand SMALLINT
	DEFINE li_tot  SMALLINT
	DEFINE x       SMALLINT
	DEFINE lc_name CHAR(10)

	LET sja = util.JSONArray.create()
	LET ja  = util.JSONArray.create()

	-- Set up the 'series' JSON object
	LET sjo = util.JSONObject.create()
	CALL sjo.put("name", "Name from 4GL")
	CALL sjo.put("colorByPoint", TRUE)

	LET li_tot = 0
	LET x      = 1
	WHILE li_tot < 100
		LET lc_name = "NJMs Demos ", x USING "<<<<<&"
		LET li_rand = util.Math.rand(60)
		IF (li_tot + li_rand) > 100 THEN
			LET li_rand = 100 - li_tot
		END IF

		LET jo = util.JSONObject.create()
		CALL jo.put("name", lc_name)
		CALL jo.put("y", li_rand)
		IF x = 1 THEN
			CALL jo.put("sliced", TRUE)
			CALL jo.put("selected", TRUE)
		END IF
		CALL ja.put(x, jo)
		LET li_tot = li_tot + li_rand
		LET x      = x + 1
	END WHILE

	-- Write this 'data' array information to the 'series' JSONObject.
	CALL sjo.put("data", ja)
	-- 'series' is an array, so write the series object, now including data, to the array.
	CALL sja.put(1, sjo)

	DISPLAY "JSONSeries:", sja.toString()
	RETURN sja.toString()
END FUNCTION
--------------------------------------------------------------------------------
FUNCTION setGraphTitle(l_prop, l_val)
	DEFINE l_prop, l_val STRING
	DEFINE w             ui.Window
	DEFINE n             om.DomNode
	LET w = ui.Window.getCurrent()
	LET n = w.findNode("Property", l_prop)
	IF n IS NULL THEN
		DISPLAY "can't find property:", l_prop
		RETURN
	END IF
	CALL n.setAttribute("value", l_val)
END FUNCTION
