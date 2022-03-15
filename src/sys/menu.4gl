-- A Simple demo program with a login and menu system.

IMPORT FGL g2_lib.*

IMPORT FGL lib_login
IMPORT FGL menuLib
IMPORT FGL new_acct

&include "../schema.inc"
&include "app.inc"

CONSTANT C_PRGVER = "3.2"
CONSTANT C_PRGDESC = "Demos Menu System v3"
CONSTANT C_PRGAUTH = "Neil J.Martin"
CONSTANT C_PRGICON = "logo"

CONSTANT C_TITLE = "'Genero' Demos"
CONSTANT C_SPLASH = "logo"

MAIN

  CALL g2_core.m_appInfo.progInfo(C_PRGDESC, C_PRGAUTH, C_PRGVER, C_PRGICON)
	CALL g2_init.g2_init( ARG_VAL(1), "default")
  WHENEVER ANY ERROR CALL g2_core.g2_error
  CALL ui.Interface.setText(C_PRGDESC)

	RUN "env | sort > /tmp/njmdemo_"||fgl_getPID()||".env"

  CLOSE WINDOW SCREEN

  IF g2_core.m_mdi = "M" THEN
    LET g2_core.m_mdi = "C"
  END IF -- if MDI container set so child programs are children

  IF do_dbconnect_and_login() THEN
    CALL g2_gdcUpdate.g2_gdcUpate()
    CALL menuLib.do_menu(C_SPLASH)
  END IF
  CALL g2_core.g2_exitProgram(0, % "Program Finished")
END MAIN
--------------------------------------------------------------------------------
-- Connect to the database to do the login process
FUNCTION do_dbconnect_and_login() RETURNS BOOLEAN
	DEFINE l_user STRING
	DEFINE l_user_id INTEGER

  IF g2_core.m_mdi = "S" THEN
    CALL g2_core.g2_splash(0, C_SPLASH, 243, 53) -- open splash
  END IF

  CALL g2_db.m_db.g2_connect(NULL)

  IF g2_core.m_mdi = "S" THEN
		DISPLAY CURRENT," SLEEP 2"
    CALL g2_core.g2_sleep(2)
    CALL g2_core.g2_splash(-1, NULL, 0, 0) -- close splash
  END IF

  LET lib_login.m_logo_image = C_SPLASH
  LET lib_login.m_new_acc_func = FUNCTION new_acct.new_acct

-- For quick testing only
  IF ARG_VAL(1) = "test@test.com" THEN
    LET l_user = ARG_VAL(1)
  ELSE
    LET l_user = lib_login.login(C_TITLE, C_PRGVER)
  END IF
  IF l_user = "Cancelled" THEN
    RETURN FALSE
  END IF

  SELECT user_key INTO l_user_id FROM sys_users WHERE email = l_user

  LET menuLib.m_args = g2_core.m_mdi, " ", l_user_id

  RETURN TRUE
END FUNCTION
--------------------------------------------------------------------------------
