# Core rest service program for njm_demo database access
IMPORT com
IMPORT FGL g2_lib.*
IMPORT FGL ws_lib
IMPORT FGL njm_cust_ws -- imported to ensure it's compiled.

&include "../../g2_lib/g2_lib/g2_debug.inc"

MAIN
--	DEFINE l_config config
	DEFINE l_db g2_db.dbInfo
{	IF NOT l_config.initConfigFile(NULL) THEN
		CALL fgl_winMessage("Error", l_config.message,"exclamation")
		EXIT PROGRAM
	END IF
	GL_DBGMSG(0,l_config.message)}
	CALL l_db.g2_connect(NULL)

	GL_DBGMSG(0, SFMT("%1 Server started", base.Application.getProgramName()))

-- Services
	CALL com.WebServiceEngine.RegisterRestService("njm_cust_ws", "customers")

	CALL com.WebServiceEngine.Start()
	WHILE ws_lib.ws_ProcessServices_stat(com.WebServiceEngine.ProcessServices(-1))
	END WHILE
	GL_DBGMSG(0, SFMT("%1 Server stopped", base.Application.getProgramName()))
END MAIN
