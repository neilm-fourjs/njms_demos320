IMPORT FGL g2_lib

CONSTANT C_PRGVER  = "3.1"
CONSTANT C_PRGDESC = "Table Expenses Demo"
CONSTANT C_PRGAUTH = "Neil J.Martin"
CONSTANT C_PRGICON = "logo_dark"

TYPE t_d DECIMAL(10, 2)
DEFINE m_arr DYNAMIC ARRAY OF RECORD
	dte        DATE,
	desc       STRING,
	dept       STRING,
	milage     t_d,
	stationery t_d,
	travel     t_d,
	hotels     t_d,
	entertain  t_d,
	tel_net    t_d,
	cloud      t_d,
	other      t_d,
	nett       t_d,
	vat_code   SMALLINT,
	vat        t_d,
	gross      t_d
END RECORD
DEFINE m_vat DYNAMIC ARRAY OF RECORD
	vat_code  SMALLINT,
	nett      t_d,
	vat_value t_d
END RECORD
MAIN
	DEFINE x SMALLINT

	CALL g2_lib.m_appInfo.progInfo(C_PRGDESC, C_PRGAUTH, C_PRGVER, C_PRGICON)
	CALL g2_lib.g2_init(ARG_VAL(1), "default")

	CALL add(0, "Rackspace", "C", 0, 0, 0, 0, 0, 0, 95.79, 0, 38)
	CALL add(0, "Google Main", "C", 0, 0, 0, 0, 0, 18.31, 18.31, 0, 38)
	CALL add(0, "Amazon", "C", 0, 0, 0, 0, 0, 40.48, 0, 0, 1)
	CALL add(0, "Printer Ink", "S", 0, 12.8, 0, 0, 0, 0, 0, 0, 1)
	CALL vat_table()
	OPEN FORM f FROM "expenses"
	DISPLAY FORM f
	DIALOG ATTRIBUTE(UNBUFFERED)
		INPUT ARRAY m_arr FROM scr_arr.* ATTRIBUTES(WITHOUT DEFAULTS = TRUE)
			BEFORE ROW
				LET x = arr_curr()

			ON ACTION clone
				CALL m_arr.insertElement(x)
				LET m_arr[x].* = m_arr[x+1].*
				CALL DIALOG.setCurrentRow("scr_arr",x+1)

			BEFORE INSERT
				LET x = arr_curr()
				DISPLAY "X: ",x
				IF m_arr[x].dte IS NULL THEN
					CALL add(x, "", "?", 0, 0, 0, 0, 0, 0, 0, 0, NULL)
				END IF

			ON CHANGE milage, stationery, travel, hotels, tel_net, cloud, other, vat_code
				LET m_arr[x].nett =
						m_arr[x].milage + m_arr[x].stationery + m_arr[x].travel + m_arr[x].hotels + m_arr[x].tel_net
								+ m_arr[x].cloud + m_arr[x].other
				LET m_arr[x].vat   = vat_perc(m_arr[x].vat_code, m_arr[x].nett)
				LET m_arr[x].gross = m_arr[x].nett + m_arr[x].vat
				CALL vat_table()

		END INPUT
		DISPLAY ARRAY m_vat TO vat_arr.*
		END DISPLAY
		ON ACTION close
			EXIT DIALOG
	END DIALOG
END MAIN
--------------------------------------------------------------------------------------------------------------
FUNCTION add(
		l_row SMALLINT, l_desc STRING, l_dept CHAR(1), l_m t_d, l_s t_d, l_t t_d, l_h t_d, l_e t_d, l_i t_d, l_c t_d,
		l_o   t_d, l_vc t_d)
	DEFINE x SMALLINT
	IF l_row = 0 THEN
		LET x = m_arr.getLength() + 1
	ELSE
		LET x = l_row
	END IF
	LET m_arr[x].dte        = TODAY
	LET m_arr[x].desc       = l_desc
	LET m_arr[x].dept       = l_dept
	LET m_arr[x].milage     = l_m
	LET m_arr[x].stationery = l_s
	LET m_arr[x].travel     = l_t
	LET m_arr[x].hotels     = l_h
	LET m_arr[x].entertain  = l_e
	LET m_arr[x].tel_net    = l_i
	LET m_arr[x].cloud      = l_c
	LET m_arr[x].other      = l_o
	LET m_arr[x].vat_code   = l_vc
	LET m_arr[x].nett       = l_m + l_s + l_t + l_h + l_i + l_c + l_o
	LET m_arr[x].vat        = vat_perc(l_vc, m_arr[x].nett)
	LET m_arr[x].gross      = m_arr[x].nett + m_arr[x].vat
END FUNCTION
--------------------------------------------------------------------------------------------------------------
FUNCTION vat_perc(l_vc SMALLINT, l_nett t_d) RETURNS t_d
	DEFINE l_va t_d
	DEFINE l_vp DECIMAL(5, 2)
	CASE l_vc
		WHEN 0
			LET l_vp = 0
		OTHERWISE
			LET l_vp = 0.2
	END CASE
	LET l_va = l_nett * l_vp
	RETURN l_va
END FUNCTION
--------------------------------------------------------------------------------------------------------------
FUNCTION vat_table()
	DEFINE x, z  SMALLINT
	DEFINE l_got BOOLEAN
	CALL m_vat.clear()
	FOR z = 1 TO m_arr.getLength()
		IF m_arr[z].vat_code IS NULL THEN
			CONTINUE FOR
		END IF
		LET l_got = FALSE
		FOR x = 1 TO m_vat.getLength()
			IF m_vat[x].vat_code = m_arr[z].vat_code THEN
				LET m_vat[x].nett      = m_vat[x].nett + m_arr[z].nett
				LET m_vat[x].vat_value = m_vat[x].vat_value + m_arr[z].vat
				LET l_got              = TRUE
			END IF
		END FOR
		IF NOT l_got THEN
			LET x                  = m_vat.getLength() + 1
			LET m_vat[x].vat_code  = m_arr[z].vat_code
			LET m_vat[x].nett      = m_arr[z].nett
			LET m_vat[x].vat_value = m_arr[z].vat
		END IF
	END FOR
END FUNCTION
