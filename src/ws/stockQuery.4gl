

IMPORT com
IMPORT util
IMPORT FGL g2_lib
IMPORT FGL g2_logging
IMPORT FGL g2_db
IMPORT FGL g2_sql
IMPORT FGL g2_ws

SCHEMA njm_demo310

PUBLIC DEFINE g2_log g2_logging.logger

----------------------------------------------------------------------------------------------------
-- Initialize the service: Start the log, connect to database and start the service
PUBLIC FUNCTION init()
  DEFINE l_db g2_db.dbInfo
  CALL g2_log.init(NULL, NULL, "log", "TRUE")
  WHENEVER ANY ERROR CALL g2_lib.g2_error
	LET g2_ws.m_server = g2_lib.g2_getHostname()
  CALL l_db.g2_connect(NULL)
--  RUN "env | sort > /tmp/gas.env"
  CALL g2_log.logIt("Service Initialized.")
  CALL g2_ws.start("stockQuery","stockQuery", g2_log)
END FUNCTION


----------------------------------------------------------------------------------------------------
-- WEB SERVICE FUNCTIONS
----------------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------------
-- get a stock record
PUBLIC FUNCTION listStock( )
 ATTRIBUTES(WSGet, WSPath = "/listStock", WSDescription = "Get Stock List") RETURNS STRING

	RETURN service_reply(0, "test" )
END FUNCTION
----------------------------------------------------------------------------------------------------
-- get a stock record
PUBLIC FUNCTION getStockItem( l_itemCode STRING ATTRIBUTES(WSParam) )
 ATTRIBUTES(WSGet, WSPath = "/getStockItem/{l_itemCode}", WSDescription = "Get a Stock Item") RETURNS STRING
	DEFINE l_sql g2_sql.sql
	CALL l_sql.g2_SQLinit("stock","*","stock_code", SFMT("%1 = '%2'","stock_code",l_itemCode))
	CALL l_sql.g2_SQLgetRow(1, FALSE)
	IF l_sql.rows_count = 0 THEN
		RETURN service_reply(100, SFMT("Stock item '%1' not found.",l_itemCode))
	END IF
	CALL l_sql.g2_SQLrec2Json()
	DISPLAY "JSON:", l_sql.json_rec.toString()
	RETURN service_reply(0, l_sql.json_rec.toString() )
END FUNCTION
----------------------------------------------------------------------------------------------------
-- Just exit the service
PUBLIC FUNCTION exit(
    ) ATTRIBUTES(WSGet, WSPath = "/exit", WSDescription = "Exit the service")
    RETURNS STRING
  CALL g2_log.logIt("Server stopped by 'exit' call")
  RETURN service_reply(0,"Service Stopped.")
END FUNCTION
