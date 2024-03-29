IMPORT util
IMPORT FGL g2_core
IMPORT FGL g2_db
IMPORT FGL g2_secure
IMPORT FGL mk_db_lib
&include "../schema.inc"

CONSTANT C_DEF_USER_EMAIL  = "test@test.com"
CONSTANT C_DEF_USER_PASSWD = "T3st.T3st"

DEFINE m_mkey, m_ukey, m_rkey INTEGER
DEFINE m_file                 STRING
--------------------------------------------------------------------------------
FUNCTION insert_system_data(l_db STRING)

	CALL mkdb_progress("Loading system users / menus ...")

	LET m_ukey = 1
	CALL mk_demo_account()

	LET m_rkey = 1
	CALL addRole("S", "Login")
	CALL addRole("S", "Operator")
	CALL addRole("M", "System Admin")
	CALL addRole("M", "Order Entry")
	CALL addRole("M", "Order Edit")
	CALL addRole("S", "Invoice Printing")
	CALL addRole("M", "Enquiries")
	CALL addRole("M", "Customer Management")
	CALL addRole("M", "Stock Management")
	CALL addRole("M", "System Admin Update")
	CALL addRole("M", "Delete")

	INSERT INTO sys_user_roles VALUES(1, 1, "Y")
	INSERT INTO sys_user_roles VALUES(1, 2, "Y")
	INSERT INTO sys_user_roles VALUES(1, 3, "Y")
	INSERT INTO sys_user_roles VALUES(1, 4, "Y")
	INSERT INTO sys_user_roles VALUES(1, 5, "Y")
	INSERT INTO sys_user_roles VALUES(1, 6, "Y")
	INSERT INTO sys_user_roles VALUES(1, 10, "Y")

	LET m_mkey = 1
	CALL addMenu("main", "", "T", "Main Menu", "", "")
	CALL addMenu("main", "", "M", "Demo Programs", "demo", "")
	CALL addMenu("main", "", "M", "Web Component Demos", "wcdemo", "")
	CALL addMenu("main", "", "M", "Wizard - Dialog Demos", "wizard", "")
	CALL addMenu("main", "", "M", "Desktop Applications", "desktop", "")
	CALL addMenu("main", "", "M", "Web Applications", "webapp", "")
	CALL addMenu("main", "", "M", "System Maintenance", "sys", "")
	CALL addMenu("main", "", "M", "Utilities", "util", "")

	CALL addMenu("desktop", "main", "T", "Desktop Applcations", "", "")
	CALL addMenu("desktop", "main", "M", "Enquiry Programs", "enq", "")
	CALL addMenu("desktop", "main", "M", "Maintenance Programs", "mnt", "")
	CALL addMenu("desktop", "main", "M", "Order Entry", "oe", "")

	CALL addMenu("demo", "main", "T", "UI Demo Programs", "", "")
	CALL addMenu("demo", "main", "F", "Widgets Demo", "widgets", "")
	CALL addMenu("demo", "main", "F", "ipodTree Demo", "ipodTree", "")
	--CALL addMenu("demo", "main", "F", "picFlow Demo", "picFlow", "")
	CALL addMenu("demo", "main", "F", "Display Array Demo 1", "dispArr A", "")
	CALL addMenu("demo", "main", "F", "Display Array Demo 2", "dispArr B", "")
	CALL addMenu("demo", "main", "F", "Input Array Expenses Demo", "expenses", "")
	CALL addMenu("demo", "main", "F", "Multi Cell Select", "multi_cell_sel", "")
	CALL addMenu("demo", "main", "F", "Table - List View - GBC / AwesomeUR Only", "listView", "")
	CALL addMenu("demo", "main", "F", "Stack Demo - GBC / UR Only!", "stackDemo", "")

	CALL addMenu("wizard", "demo", "T", "Wizard - Dialog Demos", "", "")
	CALL addMenu("wizard", "demo", "F", "Wizard SD", "wizard_sd", "")
	CALL addMenu("wizard", "demo", "F", "Wizard MD", "wizard_md", "")
	CALL addMenu("wizard", "demo", "F", "Wizard MRS", "wizard_mrs", "")
	CALL addMenu("wizard", "demo", "F", "Wizard DnD", "wizard_dnd", "")

	CALL addMenu("wcdemo", "demo", "T", "Web Component Demos", "", "")
	CALL addMenu("wcdemo", "demo", "F", "GoogleMaps", "wc_googleMaps", "")
	CALL addMenu("wcdemo", "demo", "F", "AmCharts", "wc_amCharts", "")
	CALL addMenu("wcdemo", "demo", "F", "D3Charts", "wc_d3Charts", "")
	CALL addMenu("wcdemo", "demo", "F", "Gauge / Pie", "wc_gauge", "")
	CALL addMenu("wcdemo", "demo", "F", "Kite Colourizer", "wc_kite", "")
	CALL addMenu("wcdemo", "demo", "F", "Aircraft", "wc_aircraft", "")
	CALL addMenu("wcdemo", "demo", "F", "Remote Music Player", "wc_music", "")
	CALL addMenu("wcdemo", "demo", "F", "Calendar", "wc_calendar_demo", "")
	CALL addMenu("wcdemo", "demo", "F", "Richtext", "wc_richtext", "")
	CALL addMenu("wcdemo", "demo", "F", "Gallery", "wc_gallery", "")

	CALL addMenu("webapp", "main", "T", "Web Application Demos", "", "")
	CALL addMenu("webapp", "main", "F", "Customers", "custs", "")
	CALL addMenu("webapp", "main", "F", "Products", "prods", "")
	CALL addMenu("webapp", "main", "F", "Quotes", "quotes", "")

	CALL addMenu("sys", "main", "T", "System Maintenance", "", "")
	CALL addMenu("sys", "main", "F", "User/Role Maintenance", "user_mnt", "")
	CALL addMenu("sys", "main", "F", "Menu/Role Maintenance", "menu_mnt", "")
	CALL addMenu("sys", "main", "F", "View Login History", "login_hist", "")

	CALL addMenu("enq", "main", "T", "Enquiry Programs", "", "")
	CALL addMenu("enq", "main", "F", "Customer Enquiry", "cust_mnt YYNNNN", "")
	CALL addMenu("enq", "main", "F", "Stock Enquiry (dynMaint)", "dynMaint " || l_db || " stock stock_code YYNNNN", "")
	CALL addMenu(
			"enq", "main", "F", "Supplier Enquiry (dynMaint)", "dynMaint " || l_db || " supplier supp_code YYNNNN", "")

	CALL addMenu("mnt", "main", "T", "Maintenance Programs", "", "")
	CALL addMenu("mnt", "main", "F", "Customer Maintenance", "cust_mnt", "")
	CALL addMenu("mnt", "main", "F", "Stock Maintenance", "dm_stock", "")
	CALL addMenu("mnt", "main", "F", "Stock Cat Maintenance", "dynMaint " || l_db || " stock_cat catid", "")
	CALL addMenu("mnt", "main", "F", "Supplier Maintenance", "dynMaint " || l_db || " supplier supp_code", "")
	CALL addMenu("mnt", "main", "F", "Colours Maintenance", "dynMaint " || l_db || " colours colour_key", "")
	CALL addMenu("mnt", "main", "F", "Countries Maintenance", "dynMaint " || l_db || " countries country_code", "")

	CALL addMenu("oe", "main", "T", "Order Entry", "", "")
	CALL addMenu("oe", "main", "F", "Order Entry", "orderEntry ", "")
	CALL addMenu("oe", "main", "F", "Web Order Entry #1", "webOE ", "")
	CALL addMenu("oe", "main", "F", "Web Order Entry #2", "webOE2 ", "")
	CALL addMenu("oe", "main", "M", "Invoicing Reports", "oeprn", "")
	CALL addMenu("oeprn", "oe", "T", "Invoicing Reports", "", "")
	CALL addMenu("oeprn", "oe", "F", "Print Invoices ASK", "printInvoices 0 ordent ASK preview", "")
	CALL addMenu("oeprn", "oe", "F", "Print Invoices PDF", "printInvoices 0 ordent PDF preview", "")
	CALL addMenu("oeprn", "oe", "F", "Print Picking Notes", "printInvoices picklist", "")

	CALL addMenu("util", "main", "T", "Utilities", "", "")
	CALL addMenu("util", "main", "F", "Material Design Test", "matDesTest", "")
	CALL addMenu("util", "main", "P", "Font Viewer: FontAwesome", "../utils/fontAwesome.sh def", "")
	CALL addMenu("util", "main", "P", "Font Viewer: FontAwesome 5", "../utils/fontAwesome.sh fa5", "")
	CALL addMenu("util", "main", "P", "Font Viewer: Material Design Icons", "../utils/fontAwesome.sh mdi", "")
	CALL addMenu("util", "main", "S", "GRE Test 4RP", "gre_test4rp", "")
	CALL addMenu("util", "main", "S", "Reset Database", "mk_db", "")
	CALL mkdb_progress("Done.")

END FUNCTION
--------------------------------------------------------------------------------
FUNCTION mk_demo_account()
	DEFINE l_user     RECORD LIKE sys_users.*
	DEFINE l_jsonData TEXT
	DEFINE l_juser DYNAMIC ARRAY OF RECORD
		salutation STRING,
		forenames  STRING,
		surname    STRING
	END RECORD
	DEFINE x        SMALLINT
	DEFINE l_passwd LIKE sys_users.login_pass
	CALL mkdb_progress(SFMT("Creating test account: %1 / %2", C_DEF_USER_EMAIL, C_DEF_USER_PASSWD))

	SELECT * FROM sys_users WHERE email = C_DEF_USER_EMAIL
	IF STATUS = 0 THEN
		RETURN
	END IF

	LET l_user.salutation  = "Mr"
	LET l_user.forenames   = "Fred"
	LET l_user.surname     = "Bloggs"
	LET l_user.position    = "Tester"
	LET l_user.email       = C_DEF_USER_EMAIL
	LET l_user.comment     = "A test account"
	LET l_user.acct_type   = 0
	LET l_user.active      = 1
	LET l_user.forcepwchg  = "N"
	LET l_user.hash_type   = g2_secure.g2_getHashType()
	LET l_user.login_pass  = "not stored"
	LET l_user.salt        = g2_secure.g2_genSalt(l_user.hash_type)
	LET l_user.pass_hash   = g2_secure.g2_genPasswordHash(C_DEF_USER_PASSWD, l_user.salt, l_user.hash_type)
	LET l_user.pass_expire = TODAY + 365
	LET l_user.gbc_theme   = NULL
	LET l_user.photo_uri   = NULL
	TRY
		INSERT INTO sys_users VALUES l_user.*
		CALL mkdb_progress(
				SFMT("Test Account Inserted: %1 / %2 with %3 hash.", C_DEF_USER_EMAIL, C_DEF_USER_PASSWD, l_user.hash_type))
	CATCH
		CALL mkdb_progress("Insert test account failed!\n" || STATUS || ":" || SQLERRMESSAGE)
		EXIT PROGRAM
	END TRY

	CALL mkdb_progress("Creating 'guest' account ...")
	LET l_user.salutation = ""
	LET l_user.forenames  = "Guest"
	LET l_user.surname    = "Guest"
	LET l_user.position   = "Guest"
	LET l_user.email      = "guest"
	LET l_user.comment    = "A Guest account"
	LET l_user.login_pass = "guest"
	LET l_user.salt       = g2_secure.g2_genSalt(l_user.hash_type)
	LET l_user.pass_hash  = g2_secure.g2_genPasswordHash("guest", l_user.salt, l_user.hash_type)
	TRY
		INSERT INTO sys_users VALUES l_user.*
		CALL mkdb_progress("'Guest' Account guest/guest Inserted.")
	CATCH
		CALL mkdb_progress("Insert 'Guest' account failed!\n" || STATUS || ":" || SQLERRMESSAGE)
		EXIT PROGRAM
	END TRY

	LOCATE l_jsonData IN MEMORY
	LET m_file = mk_db_lib.mkdb_chkFile("sys_users.json")
	CALL l_jsonData.readFile(m_file)
	CALL util.JSON.parse(l_jsonData, l_juser)
	CALL mkdb_progress(SFMT("Inserting %1 test users ...", l_juser.getLength()))
	FOR x = 1 TO l_juser.getLength()
		LET l_user.salutation = l_juser[x].salutation
		LET l_user.forenames  = l_juser[x].forenames
		LET l_user.surname    = l_juser[x].surname
		LET l_passwd          = g2_secure.g2_genPassword()
		LET l_user.email      = DOWNSHIFT(l_user.forenames[1] || "." || l_user.surname CLIPPED || "@njmdemos.com")
		DISPLAY "User:", l_user.salutation, " ", l_user.forenames, " ", l_user.surname, " ", l_passwd, " ", l_user.email
		LET l_user.salt      = g2_secure.g2_genSalt(l_user.hash_type)
		LET l_user.pass_hash = g2_secure.g2_genPasswordHash(l_passwd, l_user.salt, l_user.hash_type)
		INSERT INTO sys_users VALUES l_user.*
	END FOR
END FUNCTION
--------------------------------------------------------------------------------
FUNCTION addRole(l_type CHAR, l_name VARCHAR(30))
	DEFINE l_role RECORD LIKE sys_roles.*
	LET l_role.active    = "Y"
	LET l_role.role_key  = 0
	LET l_role.role_name = l_name
	LET l_role.role_type = l_type

	INSERT INTO sys_roles VALUES l_role.*

	LET m_rkey = m_rkey + 1
END FUNCTION
--------------------------------------------------------------------------------
FUNCTION addMenu(
		l_id VARCHAR(6), l_pid VARCHAR(6), l_type CHAR(1), l_text VARCHAR(40), l_item VARCHAR(80), l_passw VARCHAR(8))
	DEFINE l_menu RECORD LIKE sys_menus.*

	LET l_menu.m_id     = l_id
	LET l_menu.m_item   = l_item
	LET l_menu.m_passw  = l_passw
	LET l_menu.m_pid    = l_pid
	LET l_menu.m_text   = l_text
	LET l_menu.m_type   = l_type
	LET l_menu.menu_key = 0

	INSERT INTO sys_menus VALUES l_menu.*

	LET m_mkey = m_mkey + 1
END FUNCTION
