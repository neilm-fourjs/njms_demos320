IMPORT util
IMPORT FGL wc_c3chartApi
IMPORT FGL wc_common
IMPORT FGL fgldialog

PRIVATE DEFINE
	mr_chart wc_c3chartApi.tChart,
	m_chart  STRING,
	ma_columns DYNAMIC ARRAY OF RECORD
		col_type STRING,
		data1    STRING,
		data2    STRING,
		data3    STRING,
		data4    STRING,
		data5    STRING,
		data6    STRING,
		data7    STRING
	END RECORD

MAIN
	DEFINE l_element wc_c3chartApi.tElement

	IF NOT wc_check("c3charts") THEN
		CALL fgldialog.fgl_winMessage("Error", "Can't find WebComponent 'c3charts'", "exclamation")
		EXIT PROGRAM
	END IF

	-- Init
	CALL mr_chart.New("formonly.chart")
	LET mr_chart.title     = "Power Profile"
	LET mr_chart.narrative = "Results of Standing Starts"
	LET l_element.id       = NULL

	-- Load some content & defaults
	CALL dataLoad(mr_chart, l_element)
	LET mr_chart.doc.data.type    = "spline"
	LET mr_chart.doc.axis.x.label = "Effort"
	LET mr_chart.doc.axis.y.label = "Watts"

	-- Open screen and display initial
	OPEN FORM wc_c3charts FROM "wc_c3charts"
	DISPLAY FORM wc_c3charts
	CALL combo_List("type", "CHART_TYPE")
	CALL combo_List("x_type", "AXIS_TYPE")
	CALL combo_List("y_type", "AXIS_TYPE")
	CALL combo_List("legend_position", "POSITION")
	CALL combo_List("col_type", "CHART_TYPE")
	CALL mr_chart.Set()
	CALL dataTrans("SET")

	DIALOG ATTRIBUTES(UNBUFFERED)
		SUBDIALOG chart_Head
		SUBDIALOG chart_Data
		SUBDIALOG chart_Columns

		ON ACTION select ATTRIBUTE(DEFAULTVIEW = NO)
			-- Get the element that was selected
			CALL l_element.Get(m_chart)

			-- Load next set of data based on user selected element & Refresh
			MESSAGE SFMT("Fetch data for: %1", m_chart)
			CALL dataLoad(mr_chart, l_element)
			CALL mr_chart.Set()
			CALL dataTrans("SET")
		ON ACTION quit
			EXIT DIALOG
		ON ACTION close
			EXIT DIALOG
	END DIALOG

END MAIN
--------------------------------------------------------------------------------------------------------------
PRIVATE FUNCTION combo_List(l_field STRING, l_type STRING)
	DEFINE
		l_combo ui.ComboBox,
		l_list  DYNAMIC ARRAY OF STRING,
		idx     INTEGER

	-- Get list of items
	CALL wc_c3chartApi.Domain(l_type) RETURNING l_list

	-- load combobox
	LET l_combo = ui.ComboBox.forName(l_field)
	FOR idx = 1 TO l_list.getLength()
		CALL l_combo.addItem(l_list[idx], l_list[idx])
	END FOR

END FUNCTION
--------------------------------------------------------------------------------------------------------------
PUBLIC FUNCTION dataLoad(r_chart wc_c3chartApi.tChart INOUT, r_element wc_c3chartApi.tElement INOUT)
	DEFINE p_max, i, j INTEGER

	CASE
		WHEN r_element.id IS NULL
			LET i = 0
			-- Set data using JSONarray strings, just to show that we can
			CALL r_chart.doc.data.Set(i := i + 1, '["Alpha","0","50","100","150","200","250"]')
			CALL r_chart.doc.data.Set(i := i + 1, '["Beta","30","200","100","400","150","250"]')
			CALL r_chart.doc.data.Set(i := i + 1, '["Gamma","50","20","10","40","15","25"]')
			CALL r_chart.doc.data.Set(i := i + 1, '["Delta","150","180","200","300","240","350"]')
			CALL r_chart.doc.data.Set(i := i + 1, '["Epsilon","80","200","150","290","110","220"]')
		OTHERWISE
			-- Simulate fetching data for selected element, load some random data
			LET p_max = 500
			FOR j = 1 TO 5
				FOR i = 2 TO 7
					LET r_chart.doc.data.columns[j, i] = util.Math.rand(p_max)
				END FOR
			END FOR
	END CASE

END FUNCTION
--------------------------------------------------------------------------------------------------------------
PUBLIC FUNCTION dataTrans(l_direction STRING)
	DEFINE idx INTEGER

	-- Clear column types
	CALL mr_chart.doc.data.types.clear()

	CASE l_direction.toUpperCase()
		WHEN "SET"
			-- Load data to Table from Chart
			FOR idx = 1 TO mr_chart.doc.data.columns.getLength()
				LET ma_columns[idx].data1 = mr_chart.doc.data.columns[idx, 1]
				LET ma_columns[idx].data2 = mr_chart.doc.data.columns[idx, 2]
				LET ma_columns[idx].data3 = mr_chart.doc.data.columns[idx, 3]
				LET ma_columns[idx].data4 = mr_chart.doc.data.columns[idx, 4]
				LET ma_columns[idx].data5 = mr_chart.doc.data.columns[idx, 5]
				LET ma_columns[idx].data6 = mr_chart.doc.data.columns[idx, 6]
				LET ma_columns[idx].data7 = mr_chart.doc.data.columns[idx, 7]

				-- Check if column type defined
				IF mr_chart.doc.data.types.contains(ma_columns[idx].data1) THEN
					LET ma_columns[idx].col_type = mr_chart.doc.data.types[ma_columns[idx].data1]
				END IF
			END FOR

		WHEN "GET"
			-- Clear column types
			CALL mr_chart.doc.data.types.clear()

			-- Fetch data from Table to Chart
			FOR idx = 1 TO ma_columns.getLength()
				LET mr_chart.doc.data.columns[idx, 1] = ma_columns[idx].data1
				LET mr_chart.doc.data.columns[idx, 2] = ma_columns[idx].data2
				LET mr_chart.doc.data.columns[idx, 3] = ma_columns[idx].data3
				LET mr_chart.doc.data.columns[idx, 4] = ma_columns[idx].data4
				LET mr_chart.doc.data.columns[idx, 5] = ma_columns[idx].data5
				LET mr_chart.doc.data.columns[idx, 6] = ma_columns[idx].data6
				LET mr_chart.doc.data.columns[idx, 7] = ma_columns[idx].data7

				-- Any column type override?
				IF ma_columns[idx].col_type.getLength() THEN
					LET mr_chart.doc.data.types[ma_columns[idx].data1] = ma_columns[idx].col_type
				END IF
			END FOR
	END CASE

END FUNCTION
--------------------------------------------------------------------------------------------------------------
PRIVATE DIALOG chart_Head()

	INPUT mr_chart.title, mr_chart.narrative, mr_chart.showfocus, mr_chart.doc.axis.rotated, mr_chart.doc.axis.x.type,
			mr_chart.doc.axis.x.label, mr_chart.doc.axis.y.type, mr_chart.doc.axis.y.label, mr_chart.doc.grid.x.show,
			mr_chart.doc.grid.y.show, mr_chart.doc.legend.show, mr_chart.doc.legend.position, mr_chart.doc.tooltip.show,
			mr_chart.doc.tooltip.grouped, mr_chart.doc.tooltip.format, m_chart
			FROM hdr.*, axes.*, chart ATTRIBUTES(WITHOUT DEFAULTS)
		ON CHANGE title, narrative, showfocus, rotated, x_type, x_label, y_type, y_label, x_grid, y_grid, legend_show,
				legend_position, tooltip_show, tooltip_grouped, tooltip_format
			CALL mr_chart.Set()
	END INPUT

END DIALOG
--------------------------------------------------------------------------------------------------------------
PRIVATE DIALOG chart_Data()

	INPUT mr_chart.doc.data.type, mr_chart.doc.data.x, mr_chart.doc.data.xFormat, mr_chart.doc.data.y,
			mr_chart.doc.data.xFormat
			FROM data.* ATTRIBUTES(WITHOUT DEFAULTS)
		ON CHANGE type, x, y, xFormat, yFormat
			CALL mr_chart.Set()
	END INPUT

END DIALOG
--------------------------------------------------------------------------------------------------------------
PRIVATE DIALOG chart_Columns()

	INPUT ARRAY ma_columns FROM columns.* ATTRIBUTES(WITHOUT DEFAULTS)
		ON CHANGE col_type, data1, data2, data3, data4, data5, data6, data7
			CALL dataTrans("GET")
			CALL mr_chart.Set()
	END INPUT

END DIALOG
