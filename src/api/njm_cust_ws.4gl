
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
   	LET m_customers.message = "Invalid Token."
  END IF
  RETURN m_customers.*
END FUNCTION
--------------------------------------------------------------------------------
#+ GET <server>/ws/r/njm/customers/get/<l_key>/<token>
#+ result: An array of customers
PUBLIC FUNCTION get(l_key STRING ATTRIBUTE(WSParam), l_token STRING ATTRIBUTE(WSParam)) ATTRIBUTES(
    WSPath = "/get/{l_key}/{l_token}",
    WSGet,
    WSDescription = "Get a Customers")
  RETURNS (t_customers ATTRIBUTES(WSMedia = 'application/json'))
	CALL m_customers.arr.clear()
  IF ws_lib.checkToken( l_token ) THEN
    CALL m_customers.getCustomerDB(l_key)
  ELSE
   	LET m_customers.message = "Invalid Token."
  END IF
  RETURN m_customers.*
END FUNCTION