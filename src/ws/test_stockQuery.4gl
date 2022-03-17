-- NOTE: The cli_stockQuery module was generated using:
-- fglrestful -o cli_stockQuery.4gl https://generodemos.dynu.net/f/ws/r/ws_demo/stockQuery?openapi.json

IMPORT FGL cli_stockQuery

MAIN
	DEFINE l_ret  INTEGER
	DEFINE l_resp STRING

	CALL cli_stockQuery.getStockItem("FR01") RETURNING l_ret, l_resp
	DISPLAY "Ret:", l_ret, " Resp:", l_resp

END MAIN
