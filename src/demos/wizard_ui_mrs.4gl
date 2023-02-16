IMPORT FGL wizard_common
GLOBALS "wizard_glob.inc"
FUNCTION wizard_ui_mrs()
	DIALOG ATTRIBUTE(UNBUFFERED)
		INPUT BY NAME currTable ATTRIBUTE(WITHOUT DEFAULTS)
			ON CHANGE currTable
				CALL on_change_currTable()
		END INPUT
		DISPLAY ARRAY lFields TO l.*
			ON ACTION right
				CALL mv_right(DIALOG)
			ON ACTION allright
				CALL all_right()
		END DISPLAY
		DISPLAY ARRAY rFields TO r.*
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
