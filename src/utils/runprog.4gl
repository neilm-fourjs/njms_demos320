IMPORT FGL fgldialog
MAIN
	DEFINE l_prog STRING
	LET l_prog = base.Application.getArgument(1)
	IF NOT valid(l_prog) THEN
		CALL fgldialog.fgl_winMessage(%"Error", %"Invalid program name", "exclamation")
	ELSE
		RUN SFMT("fglrun %1", l_prog)
	END IF
END MAIN
--------------------------------------------------------------------------------
FUNCTION valid(l_prog STRING) RETURNS BOOLEAN
	DEFINE l_line STRING
	DEFINE i      SMALLINT
	DEFINE c      base.Channel
	DEFINE l_ok   BOOLEAN = FALSE
	IF l_prog IS NULL OR l_prog.getLength() < 2 THEN
		RETURN FALSE
	END IF
	LET c = base.Channel.create()
	TRY
		CALL c.openFile("../etc/progs.txt", "r")
	CATCH
		CALL fgldialog.fgl_winMessage(%"Error", %"Failed to read progs.txt file.", "exclamation")
		EXIT PROGRAM
	END TRY
	WHILE NOT c.isEof()
		LET l_line = c.readLine()
		IF l_line IS NOT NULL AND l_line.getLength() > 1 AND l_line.getCharAt(1) != "#" THEN
			IF l_line.trim() = l_prog.trim() THEN
				LET l_ok = TRUE
				EXIT WHILE
			END IF
		END IF
	END WHILE
	CALL c.close()
	RETURN l_ok
END FUNCTION
