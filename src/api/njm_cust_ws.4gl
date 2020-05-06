
IMPORT FGL ws_lib
IMPORT FGL njm_cust_db

DEFINE m_customers t_customers
--------------------------------------------------------------------------------
#+ GET <server>/ws/r/njm/customers/list/<token>
#+ result: An array of customers
PUBLIC FUNCTION list(l_token STRING ATTRIBUTE(WSParam)) ATTRIBUTES(
    WSPath = "/list/{l_token}",
    WSGet,
    WSDescription = "Get a list of Customers")
  RETURNS (t_customers ATTRIBUTES(WSMedia = 'application/json'))
	CALL m_customers.arr.clear()
  IF ws_lib.checkToken( l_token ) THEN
    CALL m_customers.getCustomersDB()
  ELSE
		IF l_token = "testcase" THEN
    	LET m_customers.message = "Ticket#104318 — Returns -"
		ELSE
    	LET m_customers.message = "Invalid Token."
		END IF
  END IF
  RETURN m_customers.*
END FUNCTION