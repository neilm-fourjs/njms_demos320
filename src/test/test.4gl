
MAIN
	DISPLAY "Rendering: ", fgl_getResource("gui.rendering")
	DISPLAY "FGLGBCDIR: ", fgl_getEnv("FGLGBCDIR")
	DISPLAY "GBCNAME: ", fgl_getEnv("GBCNAME")
	DISPLAY "GBCDISTPATH: ", fgl_getEnv("GBCDISTPATH")
	DISPLAY ui.Interface.getUniversalClientName()," ",ui.Interface.getUniversalClientVersion()
--	CALL ui.Interface.refresh()
END MAIN