IMPORT util -- only used to show JSON conversion.
IMPORT FGL fgldialog
&include "schema.inc"
MAIN
	DEFINE l_rec DYNAMIC ARRAY OF RECORD LIKE stock.*
	DEFINE i INTEGER = 0
	DISPLAY "FGLIMAGEPATH=", fgl_getEnv("FGLIMAGEPATH")
-- Open and display form to the default 'screen' window.
	OPEN FORM f FROM "table"
	DISPLAY FORM f
-- Connent to database
	TRY
		DATABASE DBNAME
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
{		BEFORE ROW -- show the row as XML and JSON on stdout
			DISPLAY base.TypeInfo.create(l_rec[ arr_curr() ]).toString() -- turn row into XML
			DISPLAY util.JSON.stringify(l_rec[ arr_curr() ]) -- turn row into JSON string.
	END DISPLAY}
	IF int_flag THEN -- did they cancel or accept the display array ?
		CALL fgldialog.fgl_winMessage("Aborted","Selection Cancelled","exclamation")
	ELSE
		CALL fgldialog.fgl_winMessage("Choosen",SFMT("You selected %1 - %2" ,l_rec[arr_curr()].stock_code CLIPPED, l_rec[arr_curr()].description),"exclamation")
	END IF
END MAIN
