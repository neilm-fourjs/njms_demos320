#+ Genero Calendar library
#+
#+ This library implements a set of functions to create a calendar area in a WEBCOMPONENT field.
#+

IMPORT util
IMPORT FGL fglsvgcanvas
IMPORT FGL g2_calendar

PUBLIC TYPE t_isHoliday FUNCTION(l_dte DATE) RETURNS(BOOLEAN, STRING)

PUBLIC CONSTANT FGLCALENDAR_TYPE_DEFAULT = 1
PUBLIC CONSTANT FGLCALENDAR_TYPE_ICON    = 2
PUBLIC CONSTANT FGLCALENDAR_TYPE_TEXT    = 3
PUBLIC CONSTANT FGLCALENDAR_TYPE_DOTS    = 4

PUBLIC CONSTANT FGLCALENDAR_THEME_DEFAULT = 1
PUBLIC CONSTANT FGLCALENDAR_THEME_SAHARA  = 2
PUBLIC CONSTANT FGLCALENDAR_THEME_PACIFIC = 3
PUBLIC CONSTANT FGLCALENDAR_THEME_AMAZON  = 4
PUBLIC CONSTANT FGLCALENDAR_THEME_VIOLA   = 5
PUBLIC CONSTANT FGLCALENDAR_THEME_CHILI   = 6

PRIVATE TYPE t_calendar RECORD
	fglsvgcanvas      SMALLINT,
	field             STRING,
	cal_type          SMALLINT,
	color_theme       SMALLINT,
	draw_attr         DYNAMIC ARRAY OF SMALLINT,
	day_names         DYNAMIC ARRAY OF STRING,
	month_names       DYNAMIC ARRAY OF STRING,
	day_cell_color    STRING,
	daycur_cell_color STRING,
	dayout_cell_color STRING,
	dayoff_cell_color STRING,
	daysel_cell_color STRING,
	show_daynames     BOOLEAN,
	show_daynums      BOOLEAN,
	show_today        BOOLEAN,
	show_weeknums     BOOLEAN,
	text_size         SMALLINT,
	cell_width        SMALLINT,
	cell_height       SMALLINT,
	view_year         SMALLINT,
	view_month        SMALLINT,
	selected_dates    DYNAMIC ARRAY OF DATE
END RECORD

PRIVATE DEFINE initCount SMALLINT

PRIVATE DEFINE calendars DYNAMIC ARRAY OF t_calendar

PRIVATE CONSTANT
	CAL_GRID_DAYS SMALLINT  = 7,
	CAL_GRID_WEEKS SMALLINT = 6

PRIVATE DEFINE m_wc_node     om.DomNode
PRIVATE DEFINE m_month_combo BOOLEAN

PUBLIC DEFINE m_isHoliday t_isHoliday

DEFINE textar DICTIONARY OF STRING
#+ Library initialization function.
#+
#+ This function has to be called before using other functions of this module.
#+
PUBLIC FUNCTION initialize()
	--WHENEVER ERROR RAISE
	IF initCount = 0 THEN
		-- prepare resources
		CALL fglsvgcanvas.initialize()
	END IF
	LET initCount = initCount + 1
END FUNCTION

#+ Library finalization function.
#+
#+ This function has to be called when the library is not longer used.
#+
PUBLIC FUNCTION finalize()
	LET initCount = initCount - 1
	IF initCount = 0 THEN
		CALL calendars.clear()
		CALL fglsvgcanvas.finalize()
	END IF
END FUNCTION

PUBLIC FUNCTION setText(tmpdict DICTIONARY OF STRING)
	CALL textar.clear()
	CALL tmpdict.copyTo(textar)
END FUNCTION
#+ Create a new calendar web component and return its ID
#+
#+ This function create a new calendar object and returns its ID.
#+ The calendar ID will be used in other functions to identify a
#+ calendar object.
#+ The function requires the name of the form field defining the
#+ WEBCOMPONENT form item.
#+
#+ @code
#+ DEFINE id INTEGER
#+ LET id = fglcalendar.create("formonly.mycalendar")
#+
#+ @param name The name of the WEBCOMPONENT form field.
#+
#+ @returnType INTEGER
#+ @return The calendar object ID
#+
PUBLIC FUNCTION create(l_name STRING)
	DEFINE id, i INTEGER
	FOR i = 1 TO calendars.getLength()
		IF calendars[i].field IS NULL THEN
			LET id = i
		END IF
	END FOR
	IF id = 0 THEN
		LET id = calendars.getLength() + 1
	END IF
	LET calendars[id].fglsvgcanvas  = fglsvgcanvas.create(l_name)
	LET calendars[id].field         = l_name
	LET calendars[id].cal_type      = FGLCALENDAR_TYPE_DEFAULT
	LET calendars[id].show_daynames = TRUE
	LET calendars[id].show_daynums  = TRUE
	LET calendars[id].show_today    = TRUE
	LET calendars[id].show_weeknums = FALSE
	LET calendars[id].cell_width    = 20
	LET calendars[id].cell_height   = 20
	CALL setColorTheme(id, FGLCALENDAR_THEME_DEFAULT)
	RETURN id
END FUNCTION

#+ Destroy a calendar object
#+
#+ This function releases all resources allocated for the calendar.
#+
#+ @param id	The calendar id
PUBLIC FUNCTION destroy(id)
	DEFINE id SMALLINT
	CALL _check_id(id)
	CALL fglsvgcanvas.destroy(calendars[id].fglsvgcanvas)
	INITIALIZE calendars[id].* TO NULL
END FUNCTION

#+ Defines the view type of the calendar.
#+
#+ @param id	The calendar id
#+ @param type The view type, can be: FGLCALENDAR_TYPE_DEFAULT, FGLCALENDAR_TYPE_ICON, FGLCALENDAR_TYPE_TEXT, FGLCALENDAR_TYPE_DOTS
#+
PUBLIC FUNCTION setViewType(id SMALLINT, l_type SMALLINT)
	CALL _check_id(id)
	LET calendars[id].cal_type = l_type
END FUNCTION

#+ Defines the view type of the calendar.
#+
#+ @param id		The calendar id
#+ @param theme The color theme, can be: FGLCALENDAR_THEME_DEFAULT, FGLCALENDAR_THEME_SAHARA, FGLCALENDAR_THEME_PACIFIC, FGLCALENDAR_THEME_AMAZON, FGLCALENDAR_THEME_VIOLA, FGLCALENDAR_THEME_CHILI
#+
FUNCTION setColorTheme(id SMALLINT, theme SMALLINT)
	CALL _check_id(id)
	LET calendars[id].color_theme       = theme
	LET calendars[id].dayout_cell_color = "#BBBBA0"
	CASE theme
		WHEN FGLCALENDAR_THEME_DEFAULT
			LET calendars[id].day_cell_color    = "#AAFF99"
			LET calendars[id].daycur_cell_color = "#AA6655"
			LET calendars[id].dayoff_cell_color = "#FFAA99"
			LET calendars[id].daysel_cell_color = "#FFFF77"
		WHEN FGLCALENDAR_THEME_SAHARA
			LET calendars[id].day_cell_color    = "#FFD700"
			LET calendars[id].daycur_cell_color = "#FFFF00"
			LET calendars[id].dayoff_cell_color = "#CD9B1D"
			LET calendars[id].daysel_cell_color = "#FFA500"
		WHEN FGLCALENDAR_THEME_PACIFIC
			LET calendars[id].day_cell_color    = "#6495ED"
			LET calendars[id].daycur_cell_color = "#00AAFF"
			LET calendars[id].dayoff_cell_color = "#6C7B8B"
			LET calendars[id].daysel_cell_color = "#40E0D0"
		WHEN FGLCALENDAR_THEME_AMAZON
			LET calendars[id].day_cell_color    = "#90EE90"
			LET calendars[id].daycur_cell_color = "#54FF9F"
			LET calendars[id].dayoff_cell_color = "#6B8E23"
			LET calendars[id].daysel_cell_color = "#228033"
		WHEN FGLCALENDAR_THEME_VIOLA
			LET calendars[id].day_cell_color    = "#FFC0CB"
			LET calendars[id].daycur_cell_color = "#FF3E96"
			LET calendars[id].dayoff_cell_color = "#800080"
			LET calendars[id].daysel_cell_color = "#FF69B4"
		WHEN FGLCALENDAR_THEME_CHILI
			LET calendars[id].day_cell_color    = "#FF995B"
			LET calendars[id].daycur_cell_color = "#FFDEAD"
			LET calendars[id].dayoff_cell_color = "#C76114"
			LET calendars[id].daysel_cell_color = "#FF3400"
	END CASE
END FUNCTION

#+ Defines the relative size of calendar cells.
#+
#+ @param id	The calendar id
#+ @param rw	Relative width
#+ @param rh	Relative heiht
#+
PUBLIC FUNCTION setDayCellSize(id SMALLINT, rw SMALLINT, rh SMALLINT)
	CALL _check_id(id)
	IF rw < 1 OR rw > 15 OR rh < 1 OR rh > 15 THEN
		OPEN FORM _dummy_2_ FROM NULL -- force an error ?
	END IF
	LET calendars[id].cell_width  = rw * 10
	LET calendars[id].cell_height = rh * 10
END FUNCTION

#+ Defines if day names must be displayed in the calendar.
#+
#+ Default is TRUE.
#+
#+ @param id		The calendar id
#+ @param show	A boolean to indicate if day names must be displayed
#+
PUBLIC FUNCTION showDayNames(id SMALLINT, l_show BOOLEAN)
	CALL _check_id(id)
	LET calendars[id].show_daynames = l_show
END FUNCTION

#+ Defines if day numbers must be displayed in the calendar.
#+
#+ Default is TRUE.
#+
#+ @param id		The calendar id
#+ @param show	A boolean to indicate if day numbers must be displayed
#+
PUBLIC FUNCTION showDayNumbers(id SMALLINT, l_show BOOLEAN)
	CALL _check_id(id)
	LET calendars[id].show_daynums = l_show
END FUNCTION

#+ Defines if today must be rendered in the calendar.
#+
#+ Default is TRUE.
#+
#+ @param id		The calendar id
#+ @param show	A boolean to indicate if today must be rendered
#+
PUBLIC FUNCTION showToday(id SMALLINT, l_show BOOLEAN)
	CALL _check_id(id)
	LET calendars[id].show_today = l_show
END FUNCTION

#+ Defines if the calendar must show week numbers on the left.
#+
#+ Default is FALSE.
#+
#+ @param id		The calendar id
#+ @param show	A boolean to indicate if week numbers must be rendered
#+
PUBLIC FUNCTION showWeekNumbers(id SMALLINT, l_show BOOLEAN)
	CALL _check_id(id)
	LET calendars[id].show_weeknums = l_show
END FUNCTION

#+ Extracts selected date info from the web component field value.
#+
#+ This function can be called with the value of the web component field
#+ as parameter, after the selection action was fired, in order to get
#+ the last date selected by the user.
#+
#+ @code
#+ CALL getSelectedDateFromValue(id, value)
#+
#+ @param id		The calendar id
#+ @param value The JSON-formatted string value returned in the calendar web component field.
#+
PUBLIC FUNCTION getSelectedDateFromValue(id SMALLINT, l_value STRING)
	DEFINE
		l_rec RECORD
			id VARCHAR(50)
		END RECORD,
		l_dte DATE

	CALL _check_id(id)
	TRY
		CALL util.JSON.parse(l_value, l_rec)
	CATCH
		RETURN NULL
	END TRY

	DISPLAY "Got:", l_rec.id

	IF l_rec.id[1, 4] = "day_" THEN -- Formatted value is "day_YYYY-MM-DD"
		LET l_dte = MDY(l_rec.id[10, 11], l_rec.id[13, 14], l_rec.id[5, 8])
	END IF
	IF l_rec.id[1, 4] = "sel_" THEN -- Formatted value is "sel_YYYY-MM"
		LET calendars[id].view_year  = l_rec.id[5, 8]
		LET calendars[id].view_month = l_rec.id[10, 11]
		LET l_dte                    = MDY(l_rec.id[10, 11], "01", l_rec.id[5, 8])
	END IF

	RETURN l_dte
END FUNCTION

#+ Clears the list of selected dates for the given calendar
#+
#+ @param id		The calendar id
#+
PUBLIC FUNCTION clearSelectedDates(id SMALLINT)
	CALL _check_id(id)
	CALL calendars[id].selected_dates.clear()
END FUNCTION

#+ Adds a date to the selected dates of the given calendar
#+
#+ @param id		The calendar id
#+ @param value	A DATE value
#+
PUBLIC FUNCTION addSelectedDate(id SMALLINT, l_value DATE)
	DEFINE l SMALLINT
	CALL _check_id(id)
	IF calendars[id].selected_dates.search(NULL, l_value) == 0 THEN
		LET l                                   = calendars[id].selected_dates.getLength()
		LET calendars[id].selected_dates[l + 1] = l_value
	END IF
END FUNCTION

#+ Remove a date from the selected dates of the given calendar
#+
#+ @param id		The calendar id
#+ @param value	A DATE value
#+
PUBLIC FUNCTION removeSelectedDate(id SMALLINT, l_value DATE)
	DEFINE i SMALLINT
	CALL _check_id(id)
	LET i = calendars[id].selected_dates.search(NULL, l_value)
	IF i > 0 THEN
		CALL calendars[id].selected_dates.deleteElement(i)
	END IF
END FUNCTION

#+ Check if a date is selected for the given calendar
#+
#+ @param id		The calendar id
#+ @param value	A DATE value
#+
PUBLIC FUNCTION isSelectedDate(id SMALLINT, l_value DATE)
	CALL _check_id(id)
	RETURN (calendars[id].selected_dates.search(NULL, l_value) > 0)
END FUNCTION
--------------------------------------------------------------------------------
-- Raises an error that can be trapped in callers because of WHENEVER ERROR RAISE
PRIVATE FUNCTION _check_id(id SMALLINT)
	IF id >= 1 AND id <= calendars.getLength() THEN
		IF calendars[id].field IS NOT NULL THEN
			RETURN
		END IF
	END IF
	OPEN FORM _dummy_ FROM NULL
END FUNCTION
--------------------------------------------------------------------------------
--
PRIVATE FUNCTION _week_one(y SMALLINT)
	DEFINE
		d  DATE,
		wd SMALLINT
	LET d  = MDY(1, 4, y)
	LET wd = WEEKDAY(d)
	IF wd = 0 THEN
		LET wd = 7
	END IF
	RETURN (d + (1 - wd))
END FUNCTION
--------------------------------------------------------------------------------
-- Returns the ISO 8601 week number for a given date.
PRIVATE FUNCTION _week_number(l_date DATE)
	DEFINE
		y  SMALLINT,
		w1 DATE,
		wn SMALLINT
	LET y = YEAR(l_date)
	IF (l_date >= MDY(12, 29, y)) THEN
		LET w1 = _week_one(y + 1)
		IF l_date < w1 THEN
			LET w1 = _week_one(y)
		ELSE
			LET y = y + 1;
		END IF
	ELSE
		LET w1 = _week_one(y);
		IF l_date < w1 THEN
			LET w1 = _week_one(y := y - 1)
		END IF
	END IF
	LET wn = ((l_date - w1) / 7 + 1)
	RETURN wn
END FUNCTION
--------------------------------------------------------------------------------
#+ Defines the names for the days (for localization).
#+
#+ By default, texts are in English, using this function to define
#+ localized day names, in the character set of your choice.
#+ The list of day names must be provided as string contained a
#+ comma-separated names.
#+
#+ @code
#+ CALL setDayNames(id, "M|T|W|T|F|S|S")
#+
#+ @param id		The calendar id
#+ @param names The list of day names
#+
PUBLIC FUNCTION setDayNames(id SMALLINT, l_names STRING)
	DEFINE tok base.StringTokenizer
	DEFINE x   INTEGER
	CALL _check_id(id)
	LET tok = base.StringTokenizer.create(l_names, "|")
	LET x   = 0
	WHILE tok.hasMoreTokens()
		LET calendars[id].day_names[x := x + 1] = tok.nextToken()
	END WHILE
END FUNCTION
--------------------------------------------------------------------------------
#+ Defines the names for the months (for localization).
#+
#+ By default, texts are in English, using this function to define
#+ localized day names, in the character set of your choice.
#+ The list of day names must be provided as string contained a
#+ comma-separated names.
#+
#+ @code
#+ CALL setMonthNames(id, "Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec")
#+
#+ @param id		The calendar id
#+ @param names The list of month names
#+
PUBLIC FUNCTION setMonthNames(id SMALLINT, l_names STRING)
	DEFINE tok base.StringTokenizer
	DEFINE x   INTEGER
	CALL _check_id(id)
	LET tok = base.StringTokenizer.create(l_names, "|")
	LET x   = 0
	WHILE tok.hasMoreTokens()
		LET calendars[id].month_names[x := x + 1] = tok.nextToken()
	END WHILE
END FUNCTION
--------------------------------------------------------------------------------
#+ Defines the color for the day cells in the current month.
#+
#+ @param id		The calendar id
#+ @param color The color (#RRGGBB)
#+
PUBLIC FUNCTION setDayCellColor(id SMALLINT, l_color STRING)
	CALL _check_id(id)
	LET calendars[id].day_cell_color = l_color
END FUNCTION
--------------------------------------------------------------------------------
#+ Defines the color for the current day cell (today).
#+
#+ @param id		The calendar id
#+ @param color The color (#RRGGBB)
#+
PUBLIC FUNCTION setDayTodayCellColor(id SMALLINT, l_color STRING)
	CALL _check_id(id)
	LET calendars[id].daycur_cell_color = l_color
END FUNCTION
--------------------------------------------------------------------------------
#+ Defines the color for the days off (Sat / Sun)
#+
#+ @param id		The calendar id
#+ @param color The color (#RRGGBB)
#+
PUBLIC FUNCTION setDayOffCellColor(id SMALLINT, l_color STRING)
	CALL _check_id(id)
	LET calendars[id].dayoff_cell_color = l_color
END FUNCTION
--------------------------------------------------------------------------------
#+ Defines the color for the days out of current month
#+
#+ @param id		The calendar id
#+ @param color The color (#RRGGBB)
#+
PUBLIC FUNCTION setDayOutCellColor(id SMALLINT, l_color STRING)
	CALL _check_id(id)
	LET calendars[id].dayout_cell_color = l_color
END FUNCTION
--------------------------------------------------------------------------------
#+ Defines the color for the selected days
#+
#+ @param id		The calendar id
#+ @param color The color (#RRGGBB)
#+
PUBLIC FUNCTION setDaySelectedCellColor(id SMALLINT, l_color STRING)
	CALL _check_id(id)
	LET calendars[id].daysel_cell_color = l_color
END FUNCTION
--------------------------------------------------------------------------------
PRIVATE FUNCTION _week_day_name(id SMALLINT, n SMALLINT)
	DEFINE x SMALLINT
	CALL _check_id(id)
	IF calendars[id].day_names.getLength() = 0 THEN
		FOR x = 1 TO 7
			LET calendars[id].day_names[x] = g2_calendar.day_shortName(MDY(1, x, 2018))
		END FOR
	END IF
	RETURN calendars[id].day_names[n]
END FUNCTION
--------------------------------------------------------------------------------
PRIVATE FUNCTION _set_text_size(id SMALLINT)
	CASE calendars[id].cal_type
		WHEN FGLCALENDAR_TYPE_DEFAULT
			LET calendars[id].text_size = 10
		WHEN FGLCALENDAR_TYPE_ICON
			LET calendars[id].text_size = 10
		WHEN FGLCALENDAR_TYPE_TEXT
			LET calendars[id].text_size = 20
		WHEN FGLCALENDAR_TYPE_DOTS
			LET calendars[id].text_size = 20
	END CASE
END FUNCTION
--------------------------------------------------------------------------------
PRIVATE FUNCTION _create_styles(id SMALLINT, root_svg om.DomNode)
	DEFINE
		attr om.SaxAttributes,
		buf  base.StringBuffer,
		defs om.DomNode

	LET attr = om.SaxAttributes.create()
	LET buf  = base.StringBuffer.create()

	CALL attr.clear()
	CALL attr.addAttribute(fglsvgcanvas.SVGATT_FILL, "navy")
	CALL buf.append(fglsvgcanvas.styleDefinition(".grid", attr))
	CALL attr.clear()
	CALL attr.addAttribute(fglsvgcanvas.SVGATT_FONT_FAMILY, "Sans")
	CALL attr.addAttribute(fglsvgcanvas.SVGATT_FONT_SIZE, "0.5em")
--	CALL attr.addAttribute(SVGATT_FONT_WEIGHT,	"100" )
	CALL buf.append(fglsvgcanvas.styleDefinition(".text_style", attr))

	CASE calendars[id].cal_type

		WHEN FGLCALENDAR_TYPE_DEFAULT

			CALL attr.clear()
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_FONT_FAMILY, "Sans")
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_FONT_SIZE, "0.4em")
			CALL buf.append(fglsvgcanvas.styleDefinition(".grid_day_name", attr))
			CALL buf.append(fglsvgcanvas.styleDefinition(".grid_week_num", attr))

			CALL attr.clear()
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_FONT_FAMILY, "Sans")
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_FONT_SIZE, "0.3em")
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_FONT_WEIGHT, "600")
			CALL buf.append(fglsvgcanvas.styleDefinition(".grid_day_num", attr))

			CALL attr.clear()
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_FONT_FAMILY, "Sans")
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_FONT_SIZE, "0.3em")
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_FILL, "gray")
			CALL buf.append(fglsvgcanvas.styleDefinition(".grid_day_num_out", attr))

			CALL attr.clear()
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_FILL, calendars[id].day_cell_color)
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_FILL_OPACITY, "0.3")
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_STROKE, "gray")
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_STROKE_WIDTH, "0.5")
			CALL buf.append(fglsvgcanvas.styleDefinition(".grid_cell", attr))

			CALL attr.clear()
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_FILL, calendars[id].dayout_cell_color)
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_FILL_OPACITY, "0.3")
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_STROKE, "gray")
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_STROKE_WIDTH, "0.5")
			CALL buf.append(fglsvgcanvas.styleDefinition(".grid_cell_out", attr))

			CALL attr.clear()
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_FILL, calendars[id].daysel_cell_color)
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_FILL_OPACITY, "0.5")
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_STROKE, "red")
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_STROKE_WIDTH, "0.5")
			CALL buf.append(fglsvgcanvas.styleDefinition(".grid_cell_selected", attr))

			CALL attr.clear()
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_FILL, calendars[id].daycur_cell_color)
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_FILL_OPACITY, "0.7")
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_STROKE, "red")
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_STROKE_WIDTH, "0.2")
			CALL buf.append(fglsvgcanvas.styleDefinition(".grid_cell_today", attr))

			CALL attr.clear()
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_FILL, calendars[id].dayoff_cell_color)
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_FILL_OPACITY, "0.3")
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_STROKE, "gray")
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_STROKE_WIDTH, "0.5")
			CALL buf.append(fglsvgcanvas.styleDefinition(".grid_cell_off", attr))

		WHEN FGLCALENDAR_TYPE_ICON

			CALL attr.clear()
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_FONT_FAMILY, "Sans")
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_FONT_SIZE, "0.4em")
			CALL buf.append(fglsvgcanvas.styleDefinition(".grid_day_name", attr))
			CALL buf.append(fglsvgcanvas.styleDefinition(".grid_week_num", attr))

			CALL attr.clear()
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_FONT_FAMILY, "Sans")
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_FONT_SIZE, "0.3em")
			CALL buf.append(fglsvgcanvas.styleDefinition(".grid_day_num", attr))

			CALL attr.clear()
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_FONT_FAMILY, "Sans")
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_FONT_SIZE, "0.3em")
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_FILL, "gray")
			CALL buf.append(fglsvgcanvas.styleDefinition(".grid_day_num_out", attr))

			CALL attr.clear()
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_FILL, calendars[id].day_cell_color)
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_FILL_OPACITY, "1.0")
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_STROKE, "white")
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_STROKE_WIDTH, "4.0")
			CALL buf.append(fglsvgcanvas.styleDefinition(".grid_cell", attr))

			CALL attr.clear()
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_FILL, calendars[id].dayout_cell_color)
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_FILL_OPACITY, "1.0")
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_STROKE, "white")
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_STROKE_WIDTH, "4.0")
			CALL buf.append(fglsvgcanvas.styleDefinition(".grid_cell_out", attr))

			CALL attr.clear()
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_FILL, calendars[id].daysel_cell_color)
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_FILL_OPACITY, "1.0")
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_STROKE, "white")
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_STROKE_WIDTH, "4.0")
			CALL buf.append(fglsvgcanvas.styleDefinition(".grid_cell_selected", attr))

			CALL attr.clear()
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_FILL, calendars[id].daycur_cell_color)
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_FILL_OPACITY, "1.0")
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_STROKE, "white")
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_STROKE_WIDTH, "2.5")
			CALL buf.append(fglsvgcanvas.styleDefinition(".grid_cell_today", attr))

			CALL attr.clear()
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_FILL, calendars[id].dayoff_cell_color)
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_FILL_OPACITY, "1.0")
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_STROKE, "white")
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_STROKE_WIDTH, "4.0")
			CALL buf.append(fglsvgcanvas.styleDefinition(".grid_cell_off", attr))

		WHEN FGLCALENDAR_TYPE_TEXT

			CALL attr.clear()
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_FONT_FAMILY, "Sans")
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_FONT_SIZE, "0.6em")
			CALL buf.append(fglsvgcanvas.styleDefinition(".grid_day_name", attr))
			CALL buf.append(fglsvgcanvas.styleDefinition(".grid_week_num", attr))

			CALL attr.clear()
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_FONT_FAMILY, "Sans")
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_FONT_SIZE, "0.7em")
			CALL buf.append(fglsvgcanvas.styleDefinition(".grid_day_num", attr))

			CALL attr.clear()
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_FONT_FAMILY, "Sans")
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_FONT_SIZE, "0.7em")
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_FILL, "gray")
			CALL buf.append(fglsvgcanvas.styleDefinition(".grid_day_num_out", attr))

			CALL attr.clear()
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_FILL, calendars[id].day_cell_color)
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_FILL_OPACITY, "0.2")
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_STROKE_WIDTH, "0")
			CALL buf.append(fglsvgcanvas.styleDefinition(".grid_cell", attr))

			CALL attr.clear()
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_FILL, calendars[id].dayout_cell_color)
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_FILL_OPACITY, "0.2")
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_STROKE_WIDTH, "0")
			CALL buf.append(fglsvgcanvas.styleDefinition(".grid_cell_out", attr))

			CALL attr.clear()
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_FILL, calendars[id].daysel_cell_color)
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_FILL_OPACITY, "0.2")
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_STROKE, "black")
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_STROKE_WIDTH, "1.0")
			CALL buf.append(fglsvgcanvas.styleDefinition(".grid_cell_selected", attr))

			CALL attr.clear()
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_FILL, calendars[id].daycur_cell_color)
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_FILL_OPACITY, "0.2")
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_STROKE, "black")
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_STROKE_WIDTH, "1.0")
			CALL buf.append(fglsvgcanvas.styleDefinition(".grid_cell_today", attr))

			CALL attr.clear()
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_FILL, calendars[id].dayoff_cell_color)
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_FILL_OPACITY, "0.2")
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_STROKE_WIDTH, "0")
			CALL buf.append(fglsvgcanvas.styleDefinition(".grid_cell_off", attr))

		WHEN FGLCALENDAR_TYPE_DOTS

			CALL attr.clear()
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_FONT_FAMILY, "Sans")
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_FONT_SIZE, "0.6em")
			CALL buf.append(fglsvgcanvas.styleDefinition(".grid_day_name", attr))
			CALL buf.append(fglsvgcanvas.styleDefinition(".grid_week_num", attr))

			CALL attr.clear()
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_FONT_FAMILY, "Sans")
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_FONT_SIZE, "0.5em")
			CALL buf.append(fglsvgcanvas.styleDefinition(".grid_day_num", attr))

			CALL attr.clear()
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_FONT_FAMILY, "Sans")
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_FONT_SIZE, "0.5em")
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_FILL, "gray")
			CALL buf.append(fglsvgcanvas.styleDefinition(".grid_day_num_out", attr))

			CALL attr.clear()
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_FILL, calendars[id].day_cell_color)
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_FILL_OPACITY, "0.2")
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_STROKE_WIDTH, "0")
			CALL buf.append(fglsvgcanvas.styleDefinition(".grid_cell", attr))

			CALL attr.clear()
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_FILL, calendars[id].dayout_cell_color)
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_FILL_OPACITY, "0.2")
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_STROKE_WIDTH, "0")
			CALL buf.append(fglsvgcanvas.styleDefinition(".grid_cell_out", attr))

			CALL attr.clear()
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_FILL, calendars[id].daysel_cell_color)
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_FILL_OPACITY, "0.2")
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_STROKE, "black")
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_STROKE_WIDTH, "1.0")
			CALL buf.append(fglsvgcanvas.styleDefinition(".grid_cell_selected", attr))

			CALL attr.clear()
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_FILL, calendars[id].daycur_cell_color)
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_FILL_OPACITY, "0.2")
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_STROKE, "black")
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_STROKE_WIDTH, "1.0")
			CALL buf.append(fglsvgcanvas.styleDefinition(".grid_cell_today", attr))

			CALL attr.clear()
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_FILL, calendars[id].dayoff_cell_color)
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_FILL_OPACITY, "0.2")
			CALL attr.addAttribute(fglsvgcanvas.SVGATT_STROKE_WIDTH, "0")
			CALL buf.append(fglsvgcanvas.styleDefinition(".grid_cell_off", attr))

	END CASE

	LET defs = fglsvgcanvas.defs(NULL)
	CALL defs.appendChild(fglsvgcanvas.styleList(buf.toString()))
	CALL root_svg.appendChild(defs)

END FUNCTION
--------------------------------------------------------------------------------
#+ Returns the current year set for the last calendar display.
#+
#+ @param id		The calendar id
#+
FUNCTION getViewYear(id SMALLINT)
	CALL _check_id(id)
	RETURN calendars[id].view_year
END FUNCTION
--------------------------------------------------------------------------------
#+ Returns the current month set for the last calendar display.
#+
#+ @param id		The calendar id
#+
FUNCTION getViewMonth(id SMALLINT)
	CALL _check_id(id)
	RETURN calendars[id].view_month
END FUNCTION
--------------------------------------------------------------------------------
PRIVATE FUNCTION _draw_calendar(id SMALLINT, view_year SMALLINT, view_month SMALLINT)
	DEFINE
		root_svg om.DomNode,
		dx       SMALLINT,
		wb RECORD
			x, y, w, h SMALLINT
		END RECORD,
		addon_x, addon_y SMALLINT

	CALL _set_text_size(id)

	LET calendars[id].view_year  = view_year
	LET calendars[id].view_month = view_month
	LET wb.x                     = 0
	LET wb.y                     = 0
	LET addon_x                  = 0
	LET addon_y                  = (calendars[id].cell_height / 2)
	IF calendars[id].show_weeknums THEN
		LET dx      = (calendars[id].text_size * 1.5) + 2
		LET wb.x    = wb.x - dx
		LET addon_x = addon_x + (dx * 1.2)
	END IF
	IF calendars[id].show_daynames THEN
		LET wb.y    = wb.y - (calendars[id].text_size)
		LET addon_y = addon_y + (calendars[id].text_size * 1.3)
	END IF

	LET wb.w = (calendars[id].cell_width * CAL_GRID_DAYS) + addon_x
	LET wb.h = (calendars[id].cell_height * CAL_GRID_WEEKS) + addon_y

	CALL fglsvgcanvas.setCurrent(calendars[id].fglsvgcanvas)

	CALL fglsvgcanvas.clean(calendars[id].fglsvgcanvas)

	LET root_svg =
			fglsvgcanvas.setRootSVGAttributes(
					SFMT("calendar_%1", id), NULL, NULL, SFMT("%1 %2 %3 %4", wb.x, wb.y, wb.w, wb.h), "xMidYMid meet")
	CALL root_svg.setAttribute(fglsvgcanvas.SVGATT_CLASS, "root_svg")

	CALL _draw_calendar_grid(id, root_svg, view_year, view_month)

	CALL fglsvgcanvas.display(calendars[id].fglsvgcanvas)

END FUNCTION
--------------------------------------------------------------------------------
#+ Displays the calendar in the web component field
#+
#+ @param id	The calendar id
#+ @param cy	The current year (4 digits)
#+ @param cm	The current month (1-12)
#+
FUNCTION display(id SMALLINT, cy SMALLINT, cm SMALLINT)
	CALL _check_id(id)
	CALL _setMonthCombo(id)
	CALL _draw_calendar(id, cy, cm)
	CALL wc_setProp(id, "year", cy)
	CALL wc_setProp(id, "month", cm)
END FUNCTION
--------------------------------------------------------------------------------
PRIVATE FUNCTION isodec(v DECIMAL(32, 10)) -- Warning: must not produce exponent notation!
	-- FIXME: Need a utility function (FGL-4196)
	RETURN util.JSON.stringify(v)
END FUNCTION
--------------------------------------------------------------------------------
PRIVATE FUNCTION _prev_month(y SMALLINT, m SMALLINT)
	DEFINE d DATE
	LET d = MDY(m, 1, y)
	LET d = d - _month_length(y, m)
	RETURN YEAR(d), MONTH(d)
END FUNCTION
--------------------------------------------------------------------------------
PRIVATE FUNCTION _month_length(y SMALLINT, m SMALLINT)
	CASE m
		WHEN 1
			RETURN 31
		WHEN 2
			RETURN IIF(util.Date.isLeapYear(y), 29, 28)
		WHEN 3
			RETURN 31
		WHEN 4
			RETURN 30
		WHEN 5
			RETURN 31
		WHEN 6
			RETURN 30
		WHEN 7
			RETURN 31
		WHEN 8
			RETURN 31
		WHEN 9
			RETURN 30
		WHEN 10
			RETURN 31
		WHEN 11
			RETURN 30
		WHEN 12
			RETURN 31
	END CASE
	RETURN NULL
END FUNCTION
--------------------------------------------------------------------------------
PRIVATE FUNCTION _first_day_position(y SMALLINT, m SMALLINT)
	DEFINE l_date DATE
	LET l_date = MDY(m, 1, y)
	CASE (l_date USING "ddd")
		WHEN "Mon"
			RETURN 1
		WHEN "Tue"
			RETURN 2
		WHEN "Wed"
			RETURN 3
		WHEN "Thu"
			RETURN 4
		WHEN "Fri"
			RETURN 5
		WHEN "Sat"
			RETURN 6
		WHEN "Sun"
			RETURN 7
	END CASE
	RETURN NULL
END FUNCTION
--------------------------------------------------------------------------------
PRIVATE FUNCTION _draw_calendar_grid(id, root_svg, view_year, view_month)
	DEFINE
		id         SMALLINT,
		root_svg   om.DomNode,
		view_year  SMALLINT,
		view_month SMALLINT
	DEFINE
		sx, sy                                         DECIMAL,
		tx, ty                                         DECIMAL,
		tn, tc, grid, cells, selcl, dnums, decos, t, n om.DomNode,
		gcol, glin                                     SMALLINT,
		text_x_offset, text_y_offset                   DECIMAL,
		day_off, text_x_align, text_y_align            BOOLEAN,
		y, m, f, r                                     SMALLINT,
		month_len, prev_month_len                      SMALLINT,
		day_num                                        SMALLINT,
		day_date                                       DATE,
		dayn_class, cell_class, day_hover              STRING,
		sd                                             BOOLEAN

	CALL _create_styles(id, root_svg)

	LET grid = fglsvgcanvas.g("calendar_grid")
	CALL root_svg.appendChild(grid)

	CALL _prev_month(view_year, view_month) RETURNING y, m
	LET prev_month_len = _month_length(y, m)
	LET month_len      = _month_length(view_year, view_month)

	LET sx = calendars[id].cell_width
	LET sy = calendars[id].cell_height

	CASE calendars[id].cal_type
		WHEN FGLCALENDAR_TYPE_TEXT
			LET text_x_offset = sx / 2
			LET text_y_offset = sy / 2
			LET text_x_align  = TRUE
			LET text_y_align  = TRUE
		WHEN FGLCALENDAR_TYPE_DOTS
			LET text_x_offset = sx / 2
			LET text_y_offset = sy - (sy * 0.5)
			LET text_x_align  = TRUE
			LET text_y_align  = FALSE
		OTHERWISE
			LET text_x_offset = 1
			LET text_y_offset = 5
			LET text_x_align  = FALSE
			LET text_y_align  = FALSE
	END CASE

	LET f = _first_day_position(view_year, view_month)
	IF f < 5 THEN
		LET day_date = MDY(view_month, 1, view_year) - (f + 6)
	ELSE
		LET day_date = MDY(view_month, 1, view_year) - (f - 1)
	END IF

	IF calendars[id].show_daynames THEN
		FOR gcol = 1 TO CAL_GRID_DAYS
			LET tx = ((gcol - 1) * sx) + (sx / 2)
			LET ty = -5
			LET t  = fglsvgcanvas.text(tx, ty, _week_day_name(id, gcol), "grid_day_name")
			CALL t.setAttribute("text-anchor", "middle")
			CALL t.setAttribute("alignment-baseline", "central")
			CALL grid.appendChild(t)
		END FOR
	END IF

	LET dnums = fglsvgcanvas.g("calendar_dnums")
	CALL grid.appendChild(dnums)

	LET decos = fglsvgcanvas.g("calendar_decos")
	CALL grid.appendChild(decos)

	-- Draw clickable rectangles at the end
	LET cells = fglsvgcanvas.g("calendar_cells")
	CALL grid.appendChild(cells)
	-- To make selected cell borders appear on top of non-selected
	LET selcl = fglsvgcanvas.g("calendar_selcl")
	CALL grid.appendChild(selcl)

	FOR glin = 1 TO CAL_GRID_WEEKS

		IF calendars[id].show_weeknums THEN
			LET tx = -(calendars[id].text_size * 1.2)
			LET ty = ((glin - 1) * sy) + (sy / 2)
			LET t  = fglsvgcanvas.text(tx, ty, _week_number(day_date), "grid_week_num")
			CALL t.setAttribute("alignment-baseline", "central")
			CALL grid.appendChild(t)
		END IF

		FOR gcol = 1 TO CAL_GRID_DAYS

			LET tx = (gcol - 1) * sx
			LET ty = (glin - 1) * sy

			LET sd = isSelectedDate(id, day_date)

			LET day_num = DAY(day_date)

			IF MONTH(day_date) != view_month THEN
				LET dayn_class = "grid_day_num_out"
				LET cell_class = "grid_cell_out"
			ELSE
				LET dayn_class = "grid_day_num"
				LET cell_class = "grid_cell"
				IF m_isHoliday IS NOT NULL THEN
					CALL m_isHoliday(day_date) RETURNING day_off, day_hover
				END IF
				IF gcol > 5 OR day_off THEN
					LET cell_class = "grid_cell_off"
				END IF
			END IF

			IF sd AND calendars[id].cal_type != FGLCALENDAR_TYPE_DOTS THEN
				LET cell_class = "grid_cell_selected"
			END IF

			IF calendars[id].cal_type = FGLCALENDAR_TYPE_ICON AND MONTH(day_date) != view_month THEN
				LET cell_class = NULL
			END IF

			IF calendars[id].show_today AND day_date = TODAY THEN
				CASE
					WHEN calendars[id].cal_type = FGLCALENDAR_TYPE_DEFAULT
						#		LET n = fglsvgcanvas.rect( tx, ty, 8, 8, NULL, NULL )
						#		CALL n.setAttribute(SVGATT_CLASS,"grid_cell_today")
						#		CALL cells.appendChild(n)
					WHEN calendars[id].cal_type = FGLCALENDAR_TYPE_TEXT OR calendars[id].cal_type = FGLCALENDAR_TYPE_DOTS
						LET r = (sx / 2)
						LET n = fglsvgcanvas.circle(tx + r, ty + r, (sx * 0.45))
						CALL n.setAttribute(fglsvgcanvas.SVGATT_CLASS, "grid_cell_today")
						CALL cells.appendChild(n)
				END CASE
			END IF

			IF cell_class IS NOT NULL THEN
				IF calendars[id].show_daynums AND calendars[id].cal_type != FGLCALENDAR_TYPE_ICON THEN
					LET t = fglsvgcanvas.text(tx + text_x_offset, ty + text_y_offset, DAY(day_date), dayn_class)
					IF text_x_align THEN
						CALL t.setAttribute("text-anchor", "middle")
					END IF
					IF text_y_align THEN
						CALL t.setAttribute("alignment-baseline", "central")
					END IF
					CALL dnums.appendChild(t)
					IF textar.contains(day_date) THEN
						LET t = fglsvgcanvas.text(tx + (sx / 2), ty + (sy / 2), textar[day_date], "text_style")
						CALL t.setAttribute("text-anchor", "middle")
						CALL t.setAttribute("fill", "blue")
						CALL t.setAttribute("alignment-baseline", "central")
						CALL grid.appendChild(t)
					END IF
				END IF

				IF sd AND calendars[id].cal_type = FGLCALENDAR_TYPE_DOTS THEN
					LET n = fglsvgcanvas.circle(tx + (sx / 2), ty + (sy * 0.8), 2)
					CALL decos.appendChild(n)
				END IF

				LET n = fglsvgcanvas.rect(tx, ty, sx, sy, NULL, NULL)
				CALL n.setAttribute(fglsvgcanvas.SVGATT_CLASS, cell_class)
				CALL n.setAttribute("id", SFMT("day_%1", (day_date USING "yyyy-mm-dd")))
				CALL n.setAttribute("onclick", "elem_clicked(this)")

				IF day_hover IS NOT NULL THEN
					LET tn = n.createChild("title")
					LET tc = tn.createChild("@chars")
					CALL tc.setAttribute("@chars", day_hover)
					LET day_hover = NULL
				END IF
				#call tt.appendChild(SFMT("day_%1", (day_date USING "yyyy-mm-dd")))
				IF sd THEN
					CALL selcl.appendChild(n)
				ELSE
					CALL cells.appendChild(n)
				END IF

				IF calendars[id].show_today AND day_date = TODAY AND calendars[id].cal_type = FGLCALENDAR_TYPE_ICON THEN
					LET n =
							fglsvgcanvas.path(
									-- Triangle...
									SFMT("M%1 %2 L%3 %4 L%5 %6 Z",
											isodec(tx), isodec(ty), isodec(tx + 16), isodec(ty), isodec(tx), isodec(ty + 16)))
					CALL n.setAttribute("id", SFMT("day_%1", (day_date USING "yyyy-mm-dd")))
					CALL n.setAttribute("onclick", "elem_clicked(this)")
					CALL n.setAttribute(fglsvgcanvas.SVGATT_CLASS, "grid_cell_today")
					IF sd THEN
						CALL selcl.appendChild(n)
					ELSE
						CALL cells.appendChild(n)
					END IF
				END IF

			END IF
			LET day_date = day_date + 1

		END FOR

	END FOR
#DISPLAY root_svg.tostring()
END FUNCTION
--------------------------------------------------------------------------------
PRIVATE FUNCTION _setMonthCombo(id SMALLINT)
	DEFINE x SMALLINT
	IF m_month_combo THEN
		RETURN
	END IF
	IF calendars[id].month_names.getLength() = 0 THEN
		FOR x = 1 TO 12
			LET calendars[id].month_names[x] = g2_calendar.month_fullName_int(x)
		END FOR
	END IF

	LET m_month_combo = TRUE

	FOR x = 1 TO 12
		DISPLAY x, ":", calendars[id].month_names[x]
		CALL wc_setProp(id, "month" || (x USING "&&"), calendars[id].month_names[x])
	END FOR

END FUNCTION
--------------------------------------------------------------------------------
PRIVATE FUNCTION wc_setProp(id SMALLINT, l_prop STRING, l_val STRING)
	DEFINE l_n_pd, l_n_p om.DomNode
	DEFINE l_nl          om.NodeList
	DEFINE l_tagName     STRING
	DEFINE x             SMALLINT
	LET l_tagName = "Property"
	IF m_wc_node IS NULL THEN -- if node for wc not set, then set it.
		LET m_wc_node = ui.Window.getCurrent().getForm().findNode("FormField", calendars[id].field).getFirstChild()
	END IF
	IF m_wc_node IS NULL THEN -- if node for wc STILL not set then abort!
		RETURN
	END IF
	LET l_n_pd = m_wc_node.getFirstChild()
	IF l_n_pd IS NULL THEN
		LET l_n_pd = m_wc_node.createChild("PropertyDict")
	END IF
	LET l_nl = l_n_pd.selectByPath(SFMT("//%1[@name=\"%2\"]", l_tagName, l_prop))
	LET x    = l_nl.getLength()
	IF x > 0 THEN
		LET l_n_p = l_nl.item(x)
	ELSE
		LET l_n_p = l_n_pd.createChild(l_tagname)
		CALL l_n_p.setAttribute("name", l_prop)
	END IF
	CALL l_n_p.setAttribute("value", l_val)
END FUNCTION
--------------------------------------------------------------------------------
