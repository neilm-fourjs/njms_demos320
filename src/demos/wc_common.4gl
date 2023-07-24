IMPORT os
FUNCTION wc_check( l_wcName STRING ) RETURNS BOOLEAN
	DEFINE l_imgPath STRING
	DEFINE l_imgPath2 STRING
	DEFINE l_tok base.StringTokenizer
	DEFINE l_ok BOOLEAN = FALSE
	LET l_tok = base.StringTokenizer.create( fgl_getenv("FGLIMAGEPATH"), ":")
	WHILE l_tok.hasMoreTokens()
		LET l_imgPath = l_tok.nextToken()
		LET l_imgPath = os.Path.join(l_imgPath, "webcomponents")
		IF os.Path.exists( l_imgPath ) THEN
			LET l_imgPath2 = os.Path.join(l_imgPath, l_wcName )
			IF os.Path.exists( l_imgPath2 ) THEN
				DISPLAY SFMT("Found: %1", l_imgPath2)
				LET l_imgPath = l_imgPath2
				LET l_imgPath2 = os.Path.join( l_imgPath2, SFMT("%1.html",l_wcName))
				IF os.Path.exists( l_imgPath2 ) THEN
					DISPLAY SFMT("Found: %1", l_imgPath2)
					LET l_ok = TRUE
				ELSE
					DISPLAY SFMT("Found: %1 but not found %2", l_imgPath, l_imgPath2)
				END IF
			ELSE
				DISPLAY SFMT("Found: %1 but not found %2", l_imgPath, l_imgPath2)
			END IF
		END IF
	END WHILE
	RETURN l_ok
END FUNCTION