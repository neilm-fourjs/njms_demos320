IMPORT os
MAIN
	DISPLAY "Rendering: ", fgl_getResource("gui.rendering")
	DISPLAY "FGLGBCDIR: ", fgl_getEnv("FGLGBCDIR")
	DISPLAY "GBCNAME: ", fgl_getEnv("GBCNAME")
	DISPLAY "GBCDISTPATH: ", fgl_getEnv("GBCDISTPATH")

	DISPLAY ui.Interface.getUniversalClientName(), " ", ui.Interface.getUniversalClientVersion()
--	CALL ui.Interface.refresh()


	DISPLAY "FGLDIR: ", fgl_getEnv("FGLDIR")
	CALL showProfiles(fgl_getEnv("FGLPROFILE"))
	CALL showProfile(os.path.JOIN(os.path.join(fgl_getEnv("FGLDIR"), "etc"), "fglprofile"))
END MAIN
--------------------------------------------------------------------------------
FUNCTION showProfiles(l_profile STRING)
	DEFINE l_st   base.StringTokenizer
	DEFINE l_name STRING
	DISPLAY SFMT("FGLPROFILE=%1", l_profile)
	LET l_st = base.StringTokenizer.create(l_profile, os.Path.pathSeparator())
	WHILE l_st.hasMoreTokens()
		LET l_name = l_st.nextToken()
		IF l_name IS NOT NULL THEN
			CALL showProfile(l_name)
		END IF
	END WHILE
END FUNCTION
--------------------------------------------------------------------------------
FUNCTION showProfile(l_file STRING)
	DEFINE l_text STRING
	DEFINE c      base.Channel
	LET c = base.Channel.create()
	CALL c.openFile(l_file, "r")
	DISPLAY SFMT("\nFile: %1\n----------------------", l_file)
	WHILE NOT c.isEof()
		LET l_text = c.readLine()
		IF l_text IS NOT NULL AND l_text.trim().getCharAt(1) != "#" THEN
			DISPLAY l_text
		END IF
	END WHILE
	DISPLAY "\n----------------------"
END FUNCTION
