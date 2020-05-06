
IMPORT FGL ws_lib

&include "../schema.inc"

PUBLIC TYPE t_customers RECORD
	arr DYNAMIC ARRAY OF RECORD LIKE customer.*,
	curr_row INTEGER,
	message STRING
END RECORD

--------------------------------------------------------------------------------
#+ Get the customers from the database.
PUBLIC FUNCTION (this t_customers) getCustomersDB()
	DECLARE cust_cur CURSOR FOR SELECT * FROM customer
	LET this.curr_row = 1
	CALL this.arr.clear()
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