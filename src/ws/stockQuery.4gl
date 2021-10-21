IMPORT com
IMPORT util
IMPORT FGL g2_lib.*

&include "schema.inc"

CONSTANT c_stockItemsPerPage = 15

PUBLIC DEFINE g2_log g2_logging.logger

----------------------------------------------------------------------------------------------------
-- Initialize the service: Start the log, connect to database and start the service
PUBLIC FUNCTION init()
  DEFINE l_db g2_db.dbInfo
  CALL g2_log.init(NULL, NULL, "log", "TRUE")
  LET g2_core.m_isWS = TRUE
  WHENEVER ANY ERROR CALL g2_core.g2_error
  LET g2_ws.m_server = g2_util.g2_getHostname()
  CALL l_db.g2_connect(NULL)
--  RUN "env | sort > /tmp/gas.env"
  CALL g2_log.logIt("Service Initialized.")
  CALL g2_ws.start("stockQuery", "stockQuery", g2_log)
END FUNCTION

----------------------------------------------------------------------------------------------------
-- WEB SERVICE FUNCTIONS
----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
-- get a stock listing
PUBLIC FUNCTION listStock(
    l_pgno SMALLINT ATTRIBUTES(WSParam))
    ATTRIBUTES(WSGet, WSPath = "/listStock/{l_pgno}", WSDescription = "Get Stock List")
    RETURNS STRING
  DEFINE l_arr DYNAMIC ARRAY OF RECORD
    stock_code LIKE stock.stock_code,
    description LIKE stock.description,
    price LIKE stock.price,
    stock LIKE stock.free_stock
  END RECORD
  DEFINE x, y SMALLINT
  DECLARE stkcur SCROLL CURSOR FOR SELECT stock_code, description, price, free_stock FROM stock
  IF l_pgno IS NULL THEN
    LET l_pgno = 1
  END IF
  OPEN stkcur
  LET y = 1
  LET x = ((l_pgno - 1) * c_stockItemsPerPage) + 1
  WHILE STATUS != NOTFOUND
    DISPLAY "Row:", x
    FETCH ABSOLUTE x stkcur INTO l_arr[y].*
    LET y = y + 1
    LET x = x + 1
    IF y = c_stockItemsPerPage THEN
      EXIT WHILE
    END IF
  END WHILE
  CLOSE stkcur

  RETURN service_reply(0, util.JSONArray.fromFGL(l_arr).toString())
END FUNCTION
----------------------------------------------------------------------------------------------------
-- get a stock record
PUBLIC FUNCTION getStockItem(
    l_itemCode STRING ATTRIBUTES(WSParam))
    ATTRIBUTES(WSGet, WSPath = "/getStockItem/{l_itemCode}", WSDescription = "Get a Stock Item")
    RETURNS STRING
  DEFINE l_sql g2_sql.sql
  CALL l_sql.g2_SQLinit("stock", "*", "stock_code", SFMT("%1 = '%2'", "stock_code", l_itemCode))
  CALL l_sql.g2_SQLgetRow(1, FALSE)
  IF l_sql.rows_count = 0 THEN
    RETURN service_reply(100, SFMT("Stock item '%1' not found.", l_itemCode))
  END IF
  CALL l_sql.g2_SQLrec2Json()
  DISPLAY "JSON:", l_sql.json_rec.toString()
  RETURN service_reply(0, l_sql.json_rec.toString())
END FUNCTION
----------------------------------------------------------------------------------------------------
-- Just exit the service
PUBLIC FUNCTION exit(
    ) ATTRIBUTES(WSGet, WSPath = "/exit", WSDescription = "Exit the service")
    RETURNS STRING
  CALL g2_log.logIt("Server stopped by 'exit' call")
  RETURN service_reply(0, "Service Stopped.")
END FUNCTION
