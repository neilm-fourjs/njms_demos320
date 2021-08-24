
MAIN
	DEFINE l_line STRING
	DEFINE l_c base.channel
	LET l_c = base.channel.create()
	CALL l_c.openFile("image2font3.txt","r")
	WHILE NOT l_c.isEof()
		LET l_line = l_c.readLine()
		IF l_line MATCHES("*Awesome.*") THEN
			DISPLAY "fa-"||l_line
		ELSE
			DISPLAY l_line
		END IF
	END WHILE
	CALL l_c.close()
	
END MAIN
