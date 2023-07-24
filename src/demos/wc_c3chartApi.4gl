-- Genero API to c3 charting code - original code by MoHo
IMPORT util

#
# c3chart Type Def
#
PUBLIC TYPE
	tColumn DYNAMIC ARRAY OF STRING,
	tColumns DYNAMIC ARRAY OF tColumn,
	tTypes DICTIONARY OF STRING,
	tGroup DYNAMIC ARRAY OF STRING,
	tGroups DYNAMIC ARRAY OF tGroup,

	tData RECORD
		x       STRING,
		xFormat STRING,
		y       STRING,
		yFormat STRING,
		columns tColumns,
		type    STRING,
		types   tTypes,
		groups  tGroups,
		onclick STRING
	END RECORD,

	tAxisType RECORD
		type       STRING,
		label      STRING,
		categories DYNAMIC ARRAY OF STRING
	END RECORD,
	tAxis RECORD
		rotated BOOLEAN,
		x       tAxisType,
		y       tAxisType
	END RECORD,

	tGridLines RECORD
		show  BOOLEAN,
		lines DYNAMIC ARRAY OF STRING
	END RECORD,
	tGrid RECORD
		x tGridLines,
		y tGridLines
	END RECORD,

	tLegend RECORD
		position STRING,
		show     BOOLEAN
	END RECORD,

	tTooltip RECORD
		show    BOOLEAN,
		grouped BOOLEAN,
		format  STRING
	END RECORD,

	tPadding RECORD
		top    STRING,
		right  STRING,
		bottom STRING,
		left   STRING
	END RECORD,

	tColor RECORD
		pattern DYNAMIC ARRAY OF STRING
	END RECORD,

	tDoc RECORD
		data    tData,
		axis    tAxis,
		grid    tGrid,
		legend  tLegend,
		tooltip tTooltip,
		padding tPadding,
		color   tColor
	END RECORD,

	tChart RECORD
		field     STRING,
		title     STRING,
		narrative STRING,
		showfocus BOOLEAN,
		doc       tDoc
	END RECORD,

	tElement RECORD
		x     STRING,
		value STRING,
		id    STRING,
		index STRING,
		name  STRING
	END RECORD

PUBLIC DEFINE m_trace BOOLEAN = FALSE

#
#! Init
#+ Initialize
#+
#+ @code
#+ call wc_c3chart.Init()
#
PUBLIC FUNCTION Init()
	#% no longer needed, but for any other initializations
END FUNCTION
--------------------------------------------------------------------------------
#
#! Domain
#+ Returns list of possible values in a domain
#+
#+ @param p_domain    Domain to return possible values of
#+
#+ @code
#+ define a_list dynamic array of string
#+ call wc_c3chart.Domain("chart_type") returning a_list
#
PUBLIC FUNCTION Domain(p_domain STRING) RETURNS DYNAMIC ARRAY OF STRING
	DEFINE a_list DYNAMIC ARRAY OF STRING =
			["", "line", "spline", "step", "area", "area-spline", "area-step", "bar", "scatter", "pie", "donut", "gauge"]
	DEFINE b_list DYNAMIC ARRAY OF STRING = ["", "indexed", "category", "timeseries"]
	DEFINE c_list DYNAMIC ARRAY OF STRING = ["", "bottom", "right", "inset"]
	CASE p_domain.toUpperCase()
		WHEN "CHART_TYPE"
			RETURN a_list
		WHEN "AXIS_TYPE"
			RETURN b_list
		WHEN "POSITION"
			RETURN c_list
	END CASE
	RETURN NULL
END FUNCTION
--------------------------------------------------------------------------------
#
#! tChart.New
#+ Define a new instance of Chart
#+
#+ @param p_field     Form name of the field
#+
#+ @code
#+ define r_chart wc_c3chart.tChart
#+ call r_chart.New("formonly.p_chart")
#
PUBLIC FUNCTION (this tChart) New(p_field STRING)

	-- Field name of widget
	LET this.field = p_field

	-- Set defaults
	LET this.doc.axis.rotated = FALSE
	LET this.doc.legend.show  = TRUE
	LET this.doc.tooltip.show = TRUE

END FUNCTION
--------------------------------------------------------------------------------
#
#! tChart.Serialize
#+ Serialize a chart
#+
#+ @returnType string
#+ @return JSON string of tChart.doc structure
#+
#+ @code
#+ define r_chart wc_c3chart.tChart,
#+   p_json string
#+ let p_json = r_chart.Serialize()
#
PUBLIC FUNCTION (this tChart) Serialize() RETURNS STRING

	CALL trace(util.JSON.stringify(this))
	RETURN util.JSON.stringify(this)

END FUNCTION
--------------------------------------------------------------------------------
#
#! tChart.Set
#+ Set initial contents of widget
#+
#+ @code
#+ define r_chart tChart
#+ let r_chart.data.x = "x"
#+ ...
#+ call r_chart.Set()
#
PUBLIC FUNCTION (this tChart) Set()

	CALL ui.Interface.frontCall("webcomponent", "call", [this.field, "Set", this.Serialize()], [])

END FUNCTION
--------------------------------------------------------------------------------
#
#! tData.Set
#+ Set column of data from JSONArray string
#+
#+ @param p_json    JSON array of strings
#+
#+ @code
#+ define r_data tData
#+ call r_data.Set(1, '["alpha","100","180","240"]')
#
PUBLIC FUNCTION (this tData) Set(p_idx INTEGER, p_json STRING)

	CALL arraySet(this.columns[p_idx], p_json)

END FUNCTION
--------------------------------------------------------------------------------
#
#! tElement.Get
#+ DeSerialize a selected chart element from JSON string
#+
#+ @param p_json    JSON encoded element
#+ @returnType      tElement
#+ @return          Element record
#+
#+ @code
#+ define r_element tElement, p_json string
#+ call tElement.Get(p_json)
#
PUBLIC FUNCTION (this tElement) Get(p_json STRING)

	CALL trace(p_json)
	IF (p_json.getLength()) THEN
		CALL util.JSON.parse(p_json, this)
	END IF

END FUNCTION
--------------------------------------------------------------------------------
#
#! arraySet
#+ Set a dynamic array of strings from JSONarray string
#+
#+ @param pa_str        Dynamic array of strings
#+ @param p_json        String with JSONarray
#+
#+ @code
#+ define a_items dynamic array of string
#+ call str.ArraySet(a_items, '["Alpha","0","50","100","150","200","250"]')
#
PUBLIC FUNCTION arraySet(pa_str DYNAMIC ARRAY OF STRING, p_json STRING)
	DEFINE o_jArr util.JSONArray

	CALL trace(p_json)
	TRY
		LET o_jArr = util.JSONArray.parse(p_json)
		CALL o_jArr.toFGL(pa_str)
	CATCH
		DISPLAY "Failed to populate array!"
	END TRY

END FUNCTION
--------------------------------------------------------------------------------
-- PRIVATE
--------------------------------------------------------------------------------
#! trace
#+ Dump argument string as trace to output if trace enabled
#+
#+ @param     Data string to dump to output
#+
#+ @code
#+ call trace('here i am')
#
PRIVATE FUNCTION trace(p_data STRING)
	IF m_trace THEN
		DISPLAY SFMT("%1: %2",CURRENT, p_data)
	END IF
END FUNCTION
