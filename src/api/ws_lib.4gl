IMPORT FGL g2_lib.*

&include "../../g2_lib/g2_lib/g2_debug.inc"

DEFINE m_host STRING

FUNCTION ws_ProcessServices_stat(l_stat INT) RETURNS BOOLEAN
	CASE l_stat
		WHEN 0
			GL_DBGMSG(0, "Request processed.")
		WHEN -1
			GL_DBGMSG(0, "Timeout reached.")
		WHEN -2
			GL_DBGMSG(0, "Disconnected from application server.")
			RETURN FALSE
		WHEN -3
			GL_DBGMSG(0, "Client Connection lost.")
		WHEN -4
			GL_DBGMSG(0, "Server interrupted with Ctrl-C.")
		WHEN -5
			GL_DBGMSG(0, SFMT("BadHTTPHeader: %1", SQLCA.SQLERRM))
		WHEN -9
			GL_DBGMSG(0, "Unsupported operation.")
		WHEN -10
			GL_DBGMSG(0, "Internal server error.")
		WHEN -23
			GL_DBGMSG(0, "Deserialization error.")
		WHEN -35
			GL_DBGMSG(0, "No such REST operation found.")
		WHEN -36
			GL_DBGMSG(0, "Missing REST parameter.")
		OTHERWISE
			GL_DBGMSG(0, "Unexpected server error " || l_stat || ".")
			RETURN FALSE
	END CASE
	RETURN TRUE
END FUNCTION
--------------------------------------------------------------------------------------------------------------
FUNCTION getHostName()
	DEFINE c      base.Channel
	DEFINE l_host STRING
	IF m_host.getLength() > 1 THEN
		RETURN m_host
	END IF
	LET l_host = fgl_getenv("HOSTNAME")
	IF l_host.getLength() < 2 THEN
		LET c = base.Channel.create()
		CALL c.openPipe("hostname -f", "r")
		LET l_host = c.readLine()
		CALL c.close()
	END IF
	IF l_host.getLength() < 2 THEN
		LET l_host = "Unknown!"
	END IF
	LET m_host = l_host
	RETURN l_host
END FUNCTION
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------
FUNCTION checkToken(l_token STRING) RETURNS BOOLEAN
	IF l_token.getLength() < 10 THEN
		RETURN FALSE
	END IF
--TODO: actually check the token
	RETURN TRUE
END FUNCTION
