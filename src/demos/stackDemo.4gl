

IMPORT FGL g2_lib.*

&include "schema.inc"

CONSTANT C_PRGVER = "3.1"
CONSTANT C_PRGDESC = "Stack Demo"
CONSTANT C_PRGAUTH = "Neil J.Martin"
CONSTANT C_PRGICON = "logo_dark"

DEFINE m_appInfo g2_appInfo.appInfo
DEFINE m_db g2_db.dbInfo
MAIN
	DEFINE l_stk RECORD LIKE stock.*

  CALL m_appInfo.progInfo(C_PRGDESC, C_PRGAUTH, C_PRGVER, C_PRGICON)
  CALL g2_init.g2_init(ARG_VAL(1), "default")

  CALL m_db.g2_connect(NULL)

	OPEN FORM f FROM "stackDemo"
	DISPLAY FORM f

	INPUT BY NAME l_stk.*

END MAIN
