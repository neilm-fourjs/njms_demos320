&include "../schema.inc"

PUBLIC TYPE t_customers RECORD
	arr      DYNAMIC ARRAY OF RECORD LIKE customer.*,
	curr_rec RECORD LIKE customer.*,
	curr_row INTEGER,
	message  STRING
END RECORD

--------------------------------------------------------------------------------
#+ Get the customers from the database.
PUBLIC FUNCTION (this t_customers) getCustomersDB()
	DECLARE cust_cur CURSOR FOR SELECT * FROM customer
	LET this.curr_row = 1
	CALL this.arr.clear()
	INITIALIZE this.curr_rec TO NULL
	FOREACH cust_cur INTO this.arr[this.curr_row].*
		LET this.curr_row = this.curr_row + 1
	END FOREACH
	IF this.arr[this.curr_row].customer_code IS NULL THEN
		CALL this.arr.deleteElement(this.curr_row)
		LET this.curr_row = this.curr_row - 1
	END IF
	IF this.arr.getLength() = 0 THEN
		LET this.message = "No rows found."
	ELSE
		LET this.message = SFMT("Found %1 Customrs", this.curr_row)
	END IF
END FUNCTION
--------------------------------------------------------------------------------
#+ Get the customers from the database.
PUBLIC FUNCTION (this t_customers) getCustomerDB(l_acc LIKE customer.customer_code)
	SELECT * INTO this.curr_rec.* FROM customer WHERE customer_code = l_acc
	IF STATUS = NOTFOUND THEN
		LET this.message = SFMT("Record '%1' not found.", l_acc)
		INITIALIZE this.curr_rec TO NULL
	ELSE
		LET this.curr_row = 1
		LET this.message  = SFMT("Found Customer '%1'", l_acc)
	END IF
END FUNCTION
