
IMPORT FGL ws_lib

&include "../schema.inc"

TYPE t_customers RECORD
	arr DYNAMIC ARRAY OF RECORD LIKE customer.*,
	curr_row INTEGER,
	message STRING
END RECORD
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
--------------------------------------------------------------------------------
#+ Get the customers from the database.
PUBLIC FUNCTION (this t_customers) getCustomersDB()
	DECLARE cust_cur CURSOR FOR SELECT * FROM customer
	LET this.curr_row = 1
	CALL m_customers.arr.clear()
	FOREACH cust_cur INTO this.arr[this.curr_row].*
		LET this.curr_row = this.curr_row + 1
	END FOREACH
	IF this.arr[this.curr_row].customer_code IS NULL THEN
		CALL this.arr.deleteElement( this.curr_row )
		LET this.curr_row = this.curr_row - 1
	END IF
	IF this.arr.getLength() = 0 THEN
		LET this.message = "No rows found."
	ELSE
    LET this.message = SFMT( "Found %1 Customrs", this.curr_row )
	END IF
END FUNCTION