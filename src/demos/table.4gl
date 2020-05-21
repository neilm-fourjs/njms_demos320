IMPORT FGL fgldialog
SCHEMA njm_demo310
MAIN
	DEFINE l_rec DYNAMIC ARRAY OF RECORD LIKE stock.*
	DEFINE i INTEGER = 0
-- Open and display form
	OPEN FORM f FROM "table"
	DISPLAY FORM f
-- Connent to database
	TRY
		DATABASE njm_demo310
	CATCH
		CALL fgldialog.fgl_winMessage("Error",SQLERRMESSAGE,"exclamation")
		EXIT PROGRAM
	END TRY
-- Get the data
	DECLARE stk_cur CURSOR FOR SELECT * FROM stock
	FOREACH stk_cur INTO l_rec[ i := i + 1 ].*
	END FOREACH
	CALL l_rec.deleteElement( l_rec.getLength() ) -- delete last empty row
-- Display data
	DISPLAY ARRAY l_rec TO scrarr.*
		BEFORE ROW
			DISPLAY base.TypeInfo.create(l_rec[ arr_curr() ]).toString()
	END DISPLAY
	IF int_flag THEN
		CALL fgldialog.fgl_winMessage("Aborted","Selection Cancelled","exclamation")
	ELSE
		CALL fgldialog.fgl_winMessage("Choosen",SFMT("You selected %1 - %2" ,l_rec[arr_curr()].stock_code, l_rec[arr_curr()].description),"exclamation")
	END IF
END MAIN