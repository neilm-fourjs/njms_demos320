-- This program is for viewing the fontAwesome fonts.
-- By: Neil J Martin ( neilm@4js.com )

IMPORT os

IMPORT FGL g2_init
IMPORT FGL g2_core
IMPORT FGL g2_about

CONSTANT C_PRGDESC = "FontAwesome Viewer"
CONSTANT C_PRGAUTH = "Neil J.Martin"
CONSTANT C_PRGVER  = "3.2"
CONSTANT C_PRGICON = "logo_dark"

TYPE t_rec RECORD
	img  STRING,
	nam  STRING,
	font STRING,
	val  STRING
END RECORD
DEFINE m_rec DYNAMIC ARRAY OF t_rec
DEFINE m_rec2 DYNAMIC ARRAY OF RECORD -- images
	i01 STRING,
	i02 STRING,
	i03 STRING,
	i04 STRING,
	i05 STRING,
	i06 STRING,
	i07 STRING,
	i08 STRING,
	i09 STRING,
	i10 STRING
END RECORD
DEFINE m_rec3 DYNAMIC ARRAY OF RECORD -- icon name
	v01 STRING,
	v02 STRING,
	v03 STRING,
	v04 STRING,
	v05 STRING,
	v06 STRING,
	v07 STRING,
	v08 STRING,
	v09 STRING,
	v10 STRING
END RECORD
DEFINE m_rec4 DYNAMIC ARRAY OF RECORD -- Fontname
	f01 STRING,
	f02 STRING,
	f03 STRING,
	f04 STRING,
	f05 STRING,
	f06 STRING,
	f07 STRING,
	f08 STRING,
	f09 STRING,
	f10 STRING
END RECORD

DEFINE m_img STRING
MAIN
	DEFINE l_ret    SMALLINT
	DEFINE l_filter STRING

	CALL g2_core.m_appInfo.progInfo(C_PRGDESC, C_PRGAUTH, C_PRGVER, C_PRGICON)
	CALL g2_init.g2_init(ARG_VAL(1), "default")

	OPEN FORM f FROM "fontAwesome"
	DISPLAY FORM f
	{MENU
		ON ACTION quit EXIT MENU
	END MENU}

	CALL ui.Window.getCurrent().setText(SFMT("Font Viewer - %1", ARG_VAL(2)))

	DISPLAY "FGLIMAGEPATH:" || fgl_getEnv("FGLIMAGEPATH") TO fglimagepath
	MESSAGE "Loading arrays ..."
	CALL ui.interface.refresh()
	CALL load_arr()
	DISPLAY "Before the dialog"
	MESSAGE SFMT("Finished loading %1 icons", m_rec.getLength())

	DIALOG ATTRIBUTE(UNBUFFERED)
		INPUT BY NAME l_filter
			BEFORE INPUT
				DISPLAY "in BEFORE INPUT"
			ON ACTION applyfilter ATTRIBUTES(ACCELERATOR = 'RETURN')
				CALL load_arr3(l_filter)
		END INPUT
		DISPLAY ARRAY m_rec2 TO arr.* ATTRIBUTES(FOCUSONFIELD)
			ON ACTION copy
				CALL ui.Interface.frontCall("standard", "cbSet", m_img, l_ret)

			BEFORE FIELD a01
				CALL dsp_img(m_rec2[arr_curr()].i01, m_rec3[arr_curr()].v01, m_rec4[arr_curr()].f01)
			BEFORE FIELD a02
				CALL dsp_img(m_rec2[arr_curr()].i02, m_rec3[arr_curr()].v02, m_rec4[arr_curr()].f02)
			BEFORE FIELD a03
				CALL dsp_img(m_rec2[arr_curr()].i03, m_rec3[arr_curr()].v03, m_rec4[arr_curr()].f03)
			BEFORE FIELD a04
				CALL dsp_img(m_rec2[arr_curr()].i04, m_rec3[arr_curr()].v04, m_rec4[arr_curr()].f04)
			BEFORE FIELD a05
				CALL dsp_img(m_rec2[arr_curr()].i05, m_rec3[arr_curr()].v05, m_rec4[arr_curr()].f05)
			BEFORE FIELD a06
				CALL dsp_img(m_rec2[arr_curr()].i06, m_rec3[arr_curr()].v06, m_rec4[arr_curr()].f06)
			BEFORE FIELD a07
				CALL dsp_img(m_rec2[arr_curr()].i07, m_rec3[arr_curr()].v07, m_rec4[arr_curr()].f07)
			BEFORE FIELD a08
				CALL dsp_img(m_rec2[arr_curr()].i08, m_rec3[arr_curr()].v08, m_rec4[arr_curr()].f08)
			BEFORE FIELD a09
				CALL dsp_img(m_rec2[arr_curr()].i09, m_rec3[arr_curr()].v09, m_rec4[arr_curr()].f09)
			BEFORE FIELD a10
				CALL dsp_img(m_rec2[arr_curr()].i10, m_rec3[arr_curr()].v10, m_rec4[arr_curr()].f10)

			BEFORE ROW
				DISPLAY "in BEFORE ROW 1"
				DISPLAY DIALOG.getCurrentItem() TO img_name
				DISPLAY BY NAME m_rec2[arr_curr()].i01
				DISPLAY BY NAME m_rec2[arr_curr()].i02
				DISPLAY BY NAME m_rec2[arr_curr()].i03
				DISPLAY BY NAME m_rec2[arr_curr()].i04
				DISPLAY BY NAME m_rec2[arr_curr()].i05
				DISPLAY BY NAME m_rec2[arr_curr()].i06
				DISPLAY BY NAME m_rec2[arr_curr()].i07
				DISPLAY BY NAME m_rec2[arr_curr()].i08
				DISPLAY BY NAME m_rec2[arr_curr()].i09
				DISPLAY BY NAME m_rec2[arr_curr()].i10

				DISPLAY BY NAME m_rec3[arr_curr()].v01
				DISPLAY BY NAME m_rec3[arr_curr()].v02
				DISPLAY BY NAME m_rec3[arr_curr()].v03
				DISPLAY BY NAME m_rec3[arr_curr()].v04
				DISPLAY BY NAME m_rec3[arr_curr()].v05
				DISPLAY BY NAME m_rec3[arr_curr()].v06
				DISPLAY BY NAME m_rec3[arr_curr()].v07
				DISPLAY BY NAME m_rec3[arr_curr()].v08
				DISPLAY BY NAME m_rec3[arr_curr()].v09
				DISPLAY BY NAME m_rec3[arr_curr()].v10
				DISPLAY "in BEFORE ROW 2"
		END DISPLAY
		BEFORE DIALOG
			DISPLAY "In BEFORE DIALOG 1"
			CALL dsp_img(m_rec2[arr_curr()].i01, m_rec3[arr_curr()].v01, m_rec4[arr_curr()].f01)
			DISPLAY "In BEFORE DIALOG 2"

		ON ACTION clearfilter
			LET l_filter = NULL
			CALL load_arr3(l_filter)
			NEXT FIELD l_filter
		ON ACTION about
			CALL g2_about.g2_about()
		ON ACTION quit
			EXIT DIALOG
		ON ACTION close
			EXIT DIALOG
	END DIALOG
END MAIN
--------------------------------------------------------------------------------
FUNCTION dsp_img(l_nam STRING, l_id STRING, l_font STRING)
	LET m_img = l_nam
	DISPLAY l_nam || " (" || l_id || ")" TO img_name
	DISPLAY l_font TO font_name
	DISPLAY l_nam TO img
	DISPLAY l_nam TO img2
END FUNCTION
--------------------------------------------------------------------------------
FUNCTION load_arr()
	DEFINE l_file STRING
	DEFINE l_st   base.StringTokenizer
	LET l_st = base.StringTokenizer.create(fgl_getEnv("FGLIMAGEPATH"), os.path.pathSeparator())
	WHILE l_st.hasMoreTokens()
		LET l_file = l_st.nextToken()
		IF l_file MATCHES "*.txt" THEN
			CALL load_arr2(l_file)
		END IF
	END WHILE
END FUNCTION
--------------------------------------------------------------------------------
FUNCTION load_arr2(l_file)
	DEFINE l_file STRING
	DEFINE c      base.channel
	DEFINE l_rec RECORD
		fld1 STRING,
		fld2 STRING
	END RECORD
	DEFINE x SMALLINT
	--DISPLAY SFMT("Adding: %1", l_file)
	LET c = base.channel.create()
--	CALL c.openFile( fgl_getEnv("FGLDIR")||"/lib/image2font.txt","r")
	CALL c.openFile(l_file, "r")
	CALL c.setDelimiter("=")
	CALL m_rec.clear()
	WHILE NOT c.isEOF()
		IF c.read([l_rec.*]) THEN
			IF l_rec.fld1.getCharAt(1) = "#" THEN
				CONTINUE WHILE
			END IF
			CALL m_rec.appendElement()
			LET m_rec[m_rec.getLength()].img  = l_rec.fld1
			LET m_rec[m_rec.getLength()].nam  = l_rec.fld1
			LET x                             = l_rec.fld2.getIndexOf(":", 1)
			LET m_rec[m_rec.getLength()].font = l_rec.fld2.subString(1, x - 1)
			LET m_rec[m_rec.getLength()].val  = l_rec.fld2.subString(x + 1, l_rec.fld2.getLength())
			--	DISPLAY "file:",l_file," fld1:",l_rec.fld1," fld2:",l_rec.fld2
		END IF
	END WHILE
	CALL c.close()
	CALL load_arr3(NULL)
END FUNCTION
--------------------------------------------------------------------------------
-- Set the arrays for displaying
FUNCTION load_arr3(l_filter STRING)
	DEFINE x     SMALLINT
	DEFINE l_rec DYNAMIC ARRAY OF t_rec
	CALL m_rec2.clear()
	CALL m_rec3.clear()
	CALL m_rec4.clear()
	CALL m_rec.copyTo(l_rec)
	IF l_filter IS NOT NULL THEN
		FOR x = l_rec.getLength() TO 1 STEP -1
			--DISPLAY "Img:", l_rec[x].img
			IF NOT l_rec[x].img MATCHES l_filter THEN
				CALL l_rec.deleteElement(x)
			END IF
		END FOR
	END IF
--  MESSAGE SFMT("Loading array using filter: %1", l_filter)
	FOR x = 1 TO l_rec.getLength() STEP 10
		CALL m_rec2.appendElement()
		CALL m_rec3.appendElement()
		CALL m_rec4.appendElement()
		LET m_rec2[m_rec2.getLength()].i01 = l_rec[x].img
		LET m_rec2[m_rec2.getLength()].i02 = l_rec[x + 1].img
		LET m_rec2[m_rec2.getLength()].i03 = l_rec[x + 2].img
		LET m_rec2[m_rec2.getLength()].i04 = l_rec[x + 3].img
		LET m_rec2[m_rec2.getLength()].i05 = l_rec[x + 4].img
		LET m_rec2[m_rec2.getLength()].i06 = l_rec[x + 5].img
		LET m_rec2[m_rec2.getLength()].i07 = l_rec[x + 6].img
		LET m_rec2[m_rec2.getLength()].i08 = l_rec[x + 7].img
		LET m_rec2[m_rec2.getLength()].i09 = l_rec[x + 8].img
		LET m_rec2[m_rec2.getLength()].i10 = l_rec[x + 9].img
		LET m_rec3[m_rec3.getLength()].v01 = l_rec[x].val
		LET m_rec3[m_rec3.getLength()].v02 = l_rec[x + 1].val
		LET m_rec3[m_rec3.getLength()].v03 = l_rec[x + 2].val
		LET m_rec3[m_rec3.getLength()].v04 = l_rec[x + 3].val
		LET m_rec3[m_rec3.getLength()].v05 = l_rec[x + 4].val
		LET m_rec3[m_rec3.getLength()].v06 = l_rec[x + 5].val
		LET m_rec3[m_rec3.getLength()].v07 = l_rec[x + 6].val
		LET m_rec3[m_rec3.getLength()].v08 = l_rec[x + 7].val
		LET m_rec3[m_rec3.getLength()].v09 = l_rec[x + 8].val
		LET m_rec3[m_rec3.getLength()].v10 = l_rec[x + 9].val
		LET m_rec4[m_rec4.getLength()].f01 = l_rec[x].font
		LET m_rec4[m_rec4.getLength()].f02 = l_rec[x + 1].font
		LET m_rec4[m_rec4.getLength()].f03 = l_rec[x + 2].font
		LET m_rec4[m_rec4.getLength()].f04 = l_rec[x + 3].font
		LET m_rec4[m_rec4.getLength()].f05 = l_rec[x + 4].font
		LET m_rec4[m_rec4.getLength()].f06 = l_rec[x + 5].font
		LET m_rec4[m_rec4.getLength()].f07 = l_rec[x + 6].font
		LET m_rec4[m_rec4.getLength()].f08 = l_rec[x + 7].font
		LET m_rec4[m_rec4.getLength()].f09 = l_rec[x + 8].font
		LET m_rec4[m_rec4.getLength()].f10 = l_rec[x + 9].font
	END FOR

END FUNCTION
