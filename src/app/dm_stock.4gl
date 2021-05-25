-- A Basic dynamic stock maintenance program.
-- Does: find, update, insert, delete
-- To Do: locking, sample, listing report

IMPORT util
-- Core libraries
IMPORT FGL g2_lib
IMPORT FGL g2_about
IMPORT FGL g2_db
IMPORT FGL app_lib
-- Dynamic Maintenance Libraries
IMPORT FGL glm_mkForm
IMPORT FGL glm_sql
IMPORT FGL glm_ui
&include "dynMaint.inc"
-- Schema / App
&include "schema.inc"
&include "app.inc"
-- Program Info
CONSTANT C_PRGVER  = "3.1"
CONSTANT C_PRGDESC = "Dynamic Stock Maintenance Demo"
CONSTANT C_PRGAUTH = "Neil J.Martin"
CONSTANT C_PRGICON = "logo_dark"

CONSTANT C_FIELDS_PER_PAGE = 14
DEFINE m_dbname         STRING
DEFINE m_allowedActions CHAR(6)
DEFINE m_db             g2_db.dbInfo
MAIN

	CALL g2_lib.m_appInfo.progInfo(C_PRGDESC, C_PRGAUTH, C_PRGVER, C_PRGICON)
	CALL g2_lib.g2_init(ARG_VAL(1), "default")

	LET m_allowedActions = "YYYYYY"
-- Connect to DB
	CALL m_db.g2_connect(NULL)
-- Setup the SQL
	LET glm_sql.m_tab       = "stock"
	LET glm_sql.m_key_nam   = "stock_code"
	LET glm_sql.m_key_fld   = 0
	LET glm_sql.m_row_cur   = 0
	LET glm_sql.m_row_count = 0
	CALL glm_sql.glm_mkSQL("*", "1=2") -- not fetching any data.
-- Generate the form
	CALL glm_mkForm.init_form(
			m_dbname, glm_sql.m_tab, glm_sql.m_key_fld, C_FIELDS_PER_PAGE, glm_sql.m_fields,
			"main2") -- C_FIELDS_PER_PAGE fields by folder page
	CALL ui.window.getCurrent().setText(C_PRGDESC)
	CALL g2_lib.g2_loadToolBar("dynmaint")
	CALL g2_lib.g2_loadTopMenu("dynmaint")
-- Setup Callback functions
	LET glm_ui.m_before_inp_func = FUNCTION my_before_inp
	LET glm_ui.m_after_inp_func = FUNCTION my_after_inp
-- start UI
	CALL glm_ui.glm_menu(m_allowedActions, m_appInfo)
-- All Done
	CALL g2_lib.g2_exitProgram(0, %"Program Finished")
END MAIN
--------------------------------------------------------------------------------
-- Initialize the form by setting the defaults and comboboxes.
FUNCTION custom_form_init()
--TODO: fix this
	DEFINE f_init_cb t_init_cb
	LET f_init_cb = FUNCTION init_cb
	CALL glm_mkForm.setComboBox("stock_cat", f_init_cb)
	CALL glm_mkForm.setComboBox("supp_code", f_init_cb)
	CALL glm_mkForm.setComboBox("disc_code", f_init_cb)
	CALL glm_mkForm.setComboBox("colour_code", f_init_cb)
	CALL glm_mkForm.setWidgetProps("pack_flag", "CheckBox", "P", "", "")
	CALL glm_mkForm.setWidgetProps("long_desc", "TextEdit", "2", "40", "both")
	CALL glm_mkForm.hideField("cost")
	CALL glm_mkForm.noEntryField("free_stock")
	CALL glm_mkForm.noEntryField("physical_stock")
	CALL glm_mkForm.noEntryField("allocated_stock")
END FUNCTION
--------------------------------------------------------------------------------
-- Initialize the comboboxs
FUNCTION init_cb(l_cb ui.ComboBox)
	DEFINE l_sql, l_key, l_desc STRING
	IF l_cb IS NULL THEN
		DISPLAY "init_cb passed NULL!"
		RETURN
	END IF
	CASE l_cb.getColumnName()
		WHEN "stock_cat"
			LET l_sql = "SELECT catid, cat_name FROM stock_cat ORDER BY cat_name"
		WHEN "colour_code"
			LET l_sql = "SELECT colour_key, colour_name FROM colours ORDER BY colour_name"
		WHEN "supp_code"
			LET l_sql = "SELECT supp_code, supp_name FROM supplier ORDER BY supp_name"
		WHEN "disc_code"
			LET l_sql = "SELECT UNIQUE stock_disc FROM disc ORDER BY stock_disc"
	END CASE
	IF l_sql IS NOT NULL THEN
		DISPLAY "Loading ComboBox for: ", l_cb.getColumnName()
		DECLARE cb_cur CURSOR FROM l_sql
		FOREACH cb_cur INTO l_key, l_desc
			IF l_key.trim().getLength() > 0 THEN
				--DISPLAY "Key:",l_key.trim()," Desc:",l_desc.trim()
				CALL l_cb.addItem(l_key.trim(), l_desc.trim())
			END IF
		END FOREACH
	END IF
END FUNCTION
--------------------------------------------------------------------------------
-- Callback function: called from the dynamic input code as a 'before input'.
-- @param l_new is this a new record or updating an existing record.
FUNCTION my_before_inp(l_new BOOLEAN, l_d ui.Dialog)
	DISPLAY "BEFORE INPUT : ", IIF(l_new, " Insert", " Update")
END FUNCTION
--------------------------------------------------------------------------------
-- Callback function: called from the dynamic input code as an 'after input'.
-- @param l_new is this a new record or updating an existing record.
FUNCTION my_after_inp(l_new BOOLEAN, l_d ui.Dialog) RETURNS BOOLEAN
	DEFINE l_stk RECORD LIKE stock.*
	DISPLAY "AFTER INPUT : ", IIF(l_new, " Insert", " Update")
	CALL util.JSON.parse(glm_mkForm.m_json_rec.toString(), l_stk) -- turn generic record back into stock record
	IF l_stk.price < 0.10 THEN
		ERROR "Stock price can't be less than 0.10!"
		CALL l_d.nextField("price")
		RETURN FALSE
	END IF
	RETURN TRUE
END FUNCTION