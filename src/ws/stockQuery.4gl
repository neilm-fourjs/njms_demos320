

IMPORT com
IMPORT util
IMPORT FGL g2_lib
IMPORT FGL g2_logging
IMPORT FGL g2_db

SCHEMA njm_demo310
DEFINE ws_response RECORD
	status INTEGER,
	description STRING,
	server STRING,
	timestamp STRING
END RECORD
PUBLIC DEFINE g2_log g2_logging.logger
DEFINE m_server STRING
----------------------------------------------------------------------------------------------------
-- Initialize the service - Start the log and connect to database.
PUBLIC FUNCTION init()
  DEFINE l_db g2_db.dbInfo
  CALL g2_log.init(NULL, NULL, "log", "TRUE")
  WHENEVER ANY ERROR CALL g2_lib.g2_error
	LET m_server = g2_lib.g2_getHostname()
  CALL l_db.g2_connect(NULL)
  RUN "env | sort > /tmp/gas.env"
  CALL g2_log.logIt("Service Initialized.")
  RETURN TRUE
END FUNCTION
----------------------------------------------------------------------------------------------------
-- Start the service loop
PUBLIC FUNCTION start()
  DEFINE l_ret SMALLINT
  DEFINE l_msg STRING

  CALL com.WebServiceEngine.RegisterRestService("stockQuery", "stockQuery")

  LET l_msg = SFMT("Service started: %1.", CURRENT)
  CALL com.WebServiceEngine.Start()
  WHILE TRUE
    CALL g2_log.logIt(SFMT("Service: %1", l_msg))
    LET l_ret = com.WebServiceEngine.ProcessServices(-1)
    CASE l_ret
      WHEN 0
        LET l_msg = "Request processed."
      WHEN -1
        LET l_msg = "Timeout reached."
      WHEN -2
        LET l_msg = "Disconnected from application server."
        EXIT WHILE # The Application server has closed the connection
      WHEN -3
        LET l_msg = "Client Connection lost."
      WHEN -4
        LET l_msg = "Server interrupted with Ctrl-C."
      WHEN -9
        LET l_msg = "Unsupported operation."
      WHEN -10
        LET l_msg = "Internal server error."
      WHEN -23
        LET l_msg = "Deserialization error."
      WHEN -35
        LET l_msg = "No such REST operation found."
      WHEN -36
        LET l_msg = "Missing REST parameter."
      OTHERWISE
        LET l_msg = SFMT("Unexpected server error %1.", l_ret)
        EXIT WHILE
    END CASE
    IF int_flag != 0 THEN
      LET l_msg = "Service interrupted."
      LET int_flag = 0
      EXIT WHILE
    END IF
  END WHILE
  CALL g2_log.logIt(SFMT("Server stopped: %1", l_msg))
END FUNCTION
----------------------------------------------------------------------------------------------------
-- get a stock record
PUBLIC FUNCTION getStockItem( l_itemCode STRING ATTRIBUTES(WSParam) )
 ATTRIBUTES(WSGet, WSPath = "/getStockItem/{l_itemCode}", WSDescription = "Get a Stock Item") RETURNS STRING
	DEFINE l_stk RECORD LIKE stock.*
	SELECT * INTO l_stk.* FROM stock WHERE stock_code = l_itemCode
	IF STATUS = 100 THEN
		RETURN service_reply(100, SFMT("Stock item '%1' not found.",l_itemCode))
	END IF
	RETURN service_reply(0, util.JSON.stringify( l_stk ) )
END FUNCTION
----------------------------------------------------------------------------------------------------
-- Just exit the service
PUBLIC FUNCTION exit(
    ) ATTRIBUTES(WSGet, WSPath = "/exit", WSDescription = "Exit the service")
    RETURNS STRING
  CALL g2_log.logIt("Server stopped by 'exit' call")
  RETURN service_reply(0,"Service Stopped.")
END FUNCTION
----------------------------------------------------------------------------------------------------
-- Format the string reply from the service function
PRIVATE FUNCTION service_reply(l_stat INT, l_reply STRING) RETURNS STRING
	LET ws_response.description = l_reply
	LET ws_response.server = m_server
	LET ws_response.timestamp = CURRENT
	LET ws_response.status = l_stat
  RETURN util.json.stringify( ws_response )
END FUNCTION
