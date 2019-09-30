IMPORT util
IMPORT FGL g2_lib
IMPORT FGL g2_appInfo
IMPORT FGL g2_about

CONSTANT C_PRGVER = "3.1"
CONSTANT C_PRGDESC = "WC Test Demo"
CONSTANT C_PRGAUTH = "Neil J.Martin"
CONSTANT C_PRGICON = "logo_dark"

DEFINE m_appInfo g2_appInfo.appInfo
MAIN
  DEFINE l_debug BOOLEAN
	DEFINE l_wc INTEGER

  CALL m_appInfo.progInfo(C_PRGDESC, C_PRGAUTH, C_PRGVER, C_PRGICON)
  CALL g2_lib.g2_init(ARG_VAL(1), "default")

-- Is the WC debug feature enabled?
  CALL ui.Interface.frontCall("standard", "getenv", ["QTWEBENGINE_REMOTE_DEBUGGING"], l_debug)
  DISPLAY "DEBUG:", l_debug

  OPEN FORM f FROM "wc_gauge"
  DISPLAY FORM f

	LET l_wc = 50
	INPUT BY NAME l_wc ATTRIBUTES(UNBUFFERED, WITHOUT DEFAULTS)
		ON ACTION plus5
			LET l_wc = l_wc + 5
		ON ACTION minus5
			LET l_wc = l_wc - 5
		ON ACTION quit EXIT INPUT
	END INPUT

  CALL g2_lib.g2_exitProgram(0, % "Program Finished")
END MAIN