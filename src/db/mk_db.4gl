IMPORT FGL g2_lib.*
IMPORT FGL mk_db_lib
IMPORT FGL mk_db_sys_data
IMPORT FGL mk_db_sys_ifx
IMPORT FGL mk_db_app_data
IMPORT FGL mk_db_app_ifx
&include "../schema.inc"

DEFINE m_sys_tabs DYNAMIC ARRAY OF STRING
DEFINE m_app_tabs DYNAMIC ARRAY OF STRING

MAIN
	DEFINE l_arg STRING
	DEFINE l_db  g2_db.dbInfo
	DEFINE x     SMALLINT

	CALL ui.Interface.loadStyles(SFMT("default_%1", ui.Interface.getFrontEndName()))
	OPEN FORM f FROM "mk_db"
	DISPLAY FORM f

	LET l_arg = arg_val(1)
	IF l_arg IS NULL OR l_arg = " " THEN
		LET l_arg = "ALL"
	END IF
	CALL mkdb_progress(SFMT("%1 running, Arg:%1", base.Application.getProgramName(), l_arg))

	LET l_db.create_db = TRUE
	CALL l_db.g2_connect(NULL)
	DISPLAY SFMT(%"Connected to %1 db '%2' okay", l_db.type, l_db.name) TO info
	CALL mkdb_progress(SFMT(%"Source: %1 Drv:%2 Dir:%3 Con:%4", l_db.source, l_db.driver, l_db.dir, l_db.connection))

	LET x                      = 0
	LET m_sys_tabs[x := x + 1] = "sys_users"
	LET m_sys_tabs[x := x + 1] = "sys_user_roles"
	LET m_sys_tabs[x := x + 1] = "sys_roles"
	LET m_sys_tabs[x := x + 1] = "sys_menus"
	LET m_sys_tabs[x := x + 1] = "sys_menu_roles"
	LET m_sys_tabs[x := x + 1] = "sys_login_hist"

	LET x                      = 0
	LET m_app_tabs[x := x + 1] = "countries"
	LET m_app_tabs[x := x + 1] = "addresses"
	LET m_app_tabs[x := x + 1] = "disc"
	LET m_app_tabs[x := x + 1] = "customer"
	LET m_app_tabs[x := x + 1] = "colours"
	LET m_app_tabs[x := x + 1] = "stock_cat"
	LET m_app_tabs[x := x + 1] = "supplier"
	LET m_app_tabs[x := x + 1] = "stock"
	LET m_app_tabs[x := x + 1] = "pack_items"
	LET m_app_tabs[x := x + 1] = "ord_head"
	LET m_app_tabs[x := x + 1] = "ord_detail"
	LET m_app_tabs[x := x + 1] = "ord_payment"
	LET m_app_tabs[x := x + 1] = "quote_detail"
	LET m_app_tabs[x := x + 1] = "quotes"

	CALL mkdb_checkTabs()

	IF g2_core.g2_winQuestion(
					"Confirm", "This will delete and recreate all the database tables!\n\nAre you sure you want to do this?",
					"No", "Yes|No", "question")
			= "Yes" THEN

		IF l_arg = "DROP" THEN
			CALL drop_sys()
			CALL drop_app()
		END IF

		IF l_arg = "SYS" OR l_arg = "ALL" THEN
			CALL drop_sys()
			CALL mk_db_sys_ifx.ifx_create_system_tables()
			CALL mk_db_sys_data.insert_system_data(l_db.name)
		END IF

		IF l_arg = "APP" OR l_arg = "ALL" THEN
			CALL drop_app()
			CALL mk_db_app_ifx.ifx_create_app_tables(l_db)
			CALL mk_db_app_data.insert_app_data()
		END IF
	END IF

	CALL mkdb_progress(SFMT("mk_db program finished Arg:%1", l_arg))
	CALL mkdb_showProgress()

END MAIN
--------------------------------------------------------------------------------
FUNCTION mkdb_checkTabs()
	DEFINE x      SMALLINT
	DEFINE l_stmt STRING
	FOR x = 1 TO m_sys_tabs.getLength()
		LET l_stmt = "SELECT COUNT(*) FROM " || m_sys_tabs[x]
		TRY
			EXECUTE IMMEDIATE l_stmt
			CALL mkdb_progress(SFMT("WARNING: %1 already exists.", m_sys_tabs[x]))
		CATCH
		END TRY
	END FOR
	FOR x = 1 TO m_app_tabs.getLength()
		LET l_stmt = "SELECT COUNT(*) FROM " || m_app_tabs[x]
		TRY
			EXECUTE IMMEDIATE l_stmt
			CALL mkdb_progress(SFMT("WARNING: %1 already exists.", m_app_tabs[x]))
		CATCH
		END TRY
	END FOR
END FUNCTION
--------------------------------------------------------------------------------
FUNCTION drop_sys()
	DEFINE x      SMALLINT
	DEFINE l_stmt STRING
	CALL mkdb_progress("Dropping system tables...")
	WHENEVER ERROR CONTINUE
	FOR x = 1 TO m_sys_tabs.getLength()
		LET l_stmt = "DROP TABLE " || m_sys_tabs[x]
		CALL mkdb_progress(l_stmt)
		EXECUTE IMMEDIATE l_stmt
	END FOR
	WHENEVER ERROR STOP
	CALL mkdb_progress("Done.")
END FUNCTION
--------------------------------------------------------------------------------
FUNCTION drop_app()
	DEFINE x      SMALLINT
	DEFINE l_stmt STRING
	CALL mkdb_progress("Dropping application tables...")
	WHENEVER ERROR CONTINUE
	FOR x = 1 TO m_app_tabs.getLength()
		LET l_stmt = "DROP TABLE " || m_app_tabs[x]
		CALL mkdb_progress(l_stmt)
		EXECUTE IMMEDIATE l_stmt
	END FOR
	WHENEVER ERROR STOP
	CALL mkdb_progress("Done.")
END FUNCTION
--------------------------------------------------------------------------------
