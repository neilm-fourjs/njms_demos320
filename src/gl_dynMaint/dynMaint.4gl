-- A Basic dynamic maintenance program.
-- Does: find, update, insert, delete
-- To Do: locking, sample, listing report

-- Command Args:
-- 1: MDI / SDI
-- 2: Database name
-- 3: Table name
-- 4: Primary Key name
-- 5: Allowed actions: Y/N > Find / Update / Insert / Delete / Sample / List  -- eg: YNNNNN = enquiry only.

IMPORT FGL g2_lib.*
IMPORT FGL app_lib

IMPORT FGL glm_mkForm
IMPORT FGL glm_sql
IMPORT FGL glm_ui
&include "dynMaint.inc"

&include "../schema.inc"
&include "../app/app.inc"

CONSTANT C_PRGVER  = "3.1"
CONSTANT C_PRGDESC = "Dynamic Maintenance Demo"
CONSTANT C_PRGAUTH = "Neil J.Martin"
CONSTANT C_PRGICON = "logo_dark"

CONSTANT C_FIELDS_PER_PAGE = 16
DEFINE m_dbname         STRING
DEFINE m_allowedActions CHAR(6)
DEFINE m_userKey        INTEGER
DEFINE m_user           STRING
MAIN
	CALL g2_core.m_appInfo.progInfo(C_PRGDESC, C_PRGAUTH, C_PRGVER, C_PRGICON)
	CALL g2_init.g2_init(base.Application.getArgument(1), "default")
-- setup database / table / key field information
	CALL init_args()
-- Connect to DB
	CALL g2_db.m_db.g2_connect(m_dbname)

-- njm_demo400 specific SQL!
--	SELECT email INTO m_user FROM sys_users WHERE user_key = m_userKey
--	LET glm_sql.m_user = m_user

-- Setup SQL
	LET glm_sql.m_key_fld   = 0
	LET glm_sql.m_row_cur   = 0
	LET glm_sql.m_row_count = 0
	CALL glm_sql.glm_mkSQL("*", "1=2") -- not fetching any data.
-- Create Form
	CALL glm_mkForm.init_form(
			g2_db.m_db.name, glm_sql.m_tab, glm_sql.m_key_fld, C_FIELDS_PER_PAGE, glm_sql.m_fields, "main2")
	CALL ui.Window.getCurrent().setText(C_PRGDESC)
	CALL g2_core.g2_loadToolBar("dynmaint")
	CALL g2_core.g2_loadTopMenu("dynmaint")
-- start UI
	CALL glm_ui.glm_menu(m_allowedActions)
-- All Done
	CALL g2_core.g2_exitProgram(0, %"Program Finished")
END MAIN
--------------------------------------------------------------------------------
FUNCTION init_args()
	LET m_userKey         = base.Application.getArgument(2)
	LET m_dbname          = base.Application.getArgument(3)
	LET glm_sql.m_tab     = base.Application.getArgument(4)
	LET glm_sql.m_key_nam = base.Application.getArgument(5)
	LET m_allowedActions  = base.Application.getArgument(6)
	IF m_dbname IS NULL THEN
		CALL g2_core.g2_errPopup(SFMT(%"Invalid Database Name '%1'!", m_dbname))
		CALL g2_core.g2_exitProgram(1, %"invalid Database")
	END IF
	IF glm_sql.m_tab IS NULL THEN
		CALL g2_core.g2_errPopup(SFMT(%"Invalid Table '%1'!", glm_sql.m_tab))
		CALL g2_core.g2_exitProgram(1, %"invalid table")
	END IF
	IF glm_sql.m_key_nam IS NULL THEN
		CALL g2_core.g2_errPopup(SFMT(%"Invalid Key Name '%1'!", glm_sql.m_key_nam))
		CALL g2_core.g2_exitProgram(1, %"invalid key name")
	END IF
	IF m_allowedActions IS NULL THEN
		LET m_allowedActions = "YYYYYY"
	END IF
END FUNCTION
--------------------------------------------------------------------------------
FUNCTION custom_form_init()
END FUNCTION
