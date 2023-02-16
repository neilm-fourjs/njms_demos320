IMPORT FGL wizard_common
GLOBALS "wizard_glob.inc"
FUNCTION wizard_ui_mrs()
	DIALOG ATTRIBUTE(UNBUFFERED)
		INPUT BY NAME currtable ATTRIBUTE(WITHOUT DEFAULTS)
			ON CHANGE currtable
				CALL on_change_currTable()
		END INPUT
		DISPLAY ARRAY lfields TO l.*
			ON ACTION right
				CALL mv_right(DIALOG)
			ON ACTION allright
				CALL all_right()
		END DISPLAY
		DISPLAY ARRAY rfields TO r.*
			ON ACTION left
				CALL mv_left(DIALOG)
			ON ACTION allleft
				CALL all_left()
		END DISPLAY
		BEFORE DIALOG
			CALL DIALOG.setSelectionMode("l", TRUE)
			CALL DIALOG.setSelectionMode("r", TRUE)
		ON ACTION canlwiz
			EXIT DIALOG
		ON ACTION finiwiz
			ACCEPT DIALOG
	END DIALOG
END FUNCTION
