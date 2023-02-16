IMPORT FGL wizard_common
GLOBALS "wizard_glob.inc"
FUNCTION wizard_ui_md()
	DIALOG ATTRIBUTE(UNBUFFERED)
		INPUT BY NAME currtable ATTRIBUTE(WITHOUT DEFAULTS) -- Combobox
			ON CHANGE currtable
				CALL on_change_currTable()
		END INPUT
		DISPLAY ARRAY lfields TO l.* -- Left field list
			ON ACTION right
				CALL mv_right(DIALOG)
		END DISPLAY
		DISPLAY ARRAY rfields TO r.* -- Right selected field list
			ON ACTION left
				CALL mv_left(DIALOG)
		END DISPLAY
		ON ACTION allright
			CALL all_right()
		ON ACTION allleft
			CALL all_left()
		ON ACTION canlwiz
			EXIT DIALOG
		ON ACTION finiwiz
			ACCEPT DIALOG
	END DIALOG
END FUNCTION
