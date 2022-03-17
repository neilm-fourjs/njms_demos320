GLOBALS "wizard_glob.inc"
FUNCTION wizard_ui_md()
	DIALOG ATTRIBUTE(UNBUFFERED)

		INPUT BY NAME currTable ATTRIBUTE(WITHOUT DEFAULTS) -- Combobox
			ON CHANGE currtable
				CALL on_change_currTable()
		END INPUT

		DISPLAY ARRAY lFields TO l.* -- Left field list
			ON ACTION right
				CALL right(DIALOG)
		END DISPLAY

		DISPLAY ARRAY rFields TO r.* -- Right selected field list
			ON ACTION left
				CALL left(DIALOG)
		END DISPLAY

		ON ACTION allright
			CALL allright()
		ON ACTION allleft
			CALL allleft()
		ON ACTION canlwiz
			EXIT DIALOG
		ON ACTION finiwiz
			ACCEPT DIALOG

	END DIALOG
END FUNCTION
