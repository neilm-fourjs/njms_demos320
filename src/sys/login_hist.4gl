-- A Simple demo program with a login and menu system.
IMPORT os
IMPORT FGL g2_lib.*

IMPORT FGL lib_login
IMPORT FGL new_acct

&include "../schema.inc"
&include "../app/app.inc"

CONSTANT C_PRGDESC = "Login History"
CONSTANT C_PRGAUTH = "Neil J.Martin"
CONSTANT C_PRGVER  = "3.2"
CONSTANT C_PRGICON = "demo_icon"
CONSTANT C_SPLASH  = "logo_dark"

MAIN

	CALL g2_core.m_appInfo.progInfo(C_PRGDESC, C_PRGAUTH, C_PRGVER, C_PRGICON)
	CALL g2_init.g2_init(ARG_VAL(1), "default")
	CALL ui.Interface.setText(C_PRGDESC)

	OPEN FORM login_hist FROM "login_hist"
	DISPLAY FORM login_hist

	CALL g2_db.m_db.g2_connect(NULL)

	CALL login_hist()

	CALL g2_core.g2_exitProgram(0, %"Program Finished")
END MAIN
--------------------------------------------------------------------------------
FUNCTION login_hist()
	DEFINE l_arr DYNAMIC ARRAY OF RECORD LIKE sys_login_hist.*
	DECLARE cur CURSOR FOR SELECT * FROM sys_login_hist
	FOREACH cur INTO l_arr[l_arr.getLength() + 1].*
	END FOREACH
	CALL l_arr.deleteElement(l_arr.getLength())
	MESSAGE SFMT(%"%1 Rows found.", l_arr.getLength())
	DISPLAY ARRAY l_arr TO scr_arr.* ATTRIBUTES(ACCEPT = FALSE, CANCEL = FALSE)
		ON ACTION quit
			EXIT DISPLAY
		ON ACTION close
			EXIT DISPLAY
		ON ACTION about
			CALL g2_about.g2_about()
	END DISPLAY
END FUNCTION
