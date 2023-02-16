IMPORT FGL wizard_common
GLOBALS "wizard_glob.inc"
FUNCTION wizard_ui_sd(l_state STRING)
	CALL upd_left()
	CALL upd_right()
	WHILE l_state != "exit" AND l_state != "accept"
		CASE l_state
			WHEN "combo"
				LET l_state = "left"
				INPUT BY NAME currTable WITHOUT DEFAULTS ATTRIBUTES(UNBUFFERED) -- Combobox
					ON CHANGE currTable
						CALL on_change_currTable()
						CALL upd_left()
					ON ACTION goleft
						LET l_state = "left"
						EXIT INPUT
					ON ACTION goright
						LET l_state = "right"
						EXIT INPUT
					ON ACTION canlwiz
						LET l_state = "exit"
						EXIT INPUT
					ON ACTION finiwiz
						LET l_state = "accept"
						EXIT INPUT
				END INPUT
			WHEN "left"
				LET l_state = "right"
				DISPLAY ARRAY lFields TO l.* ATTRIBUTES(UNBUFFERED) -- Left field list
					ON ACTION right
						CALL mv_right(DIALOG)
						CALL upd_right()
					ON ACTION allright
						CALL all_right()
						CALL upd_right()
					ON ACTION allleft
						CALL all_left()
						CALL upd_left()
					ON ACTION gocombo
						LET l_state = "combo"
						EXIT DISPLAY
					ON ACTION goright
						LET l_state = "right"
						EXIT DISPLAY
					ON ACTION canlwiz
						LET l_state = "exit"
						EXIT DISPLAY
					ON ACTION finiwiz
						LET l_state = "accept"
						EXIT DISPLAY
				END DISPLAY
			WHEN "right"
				LET l_state = "combo"
				DISPLAY ARRAY rFields TO r.* ATTRIBUTES(UNBUFFERED) -- Right selected field list
					ON ACTION left
						CALL mv_left(DIALOG)
						CALL upd_left()
					ON ACTION allleft
						CALL all_left()
						CALL upd_left()
					ON ACTION allright
						CALL all_right()
						CALL upd_right()
					ON ACTION gocombo
						LET l_state = "combo"
						EXIT DISPLAY
					ON ACTION goleft
						LET l_state = "left"
						EXIT DISPLAY
					ON ACTION canlwiz
						LET l_state = "exit"
						EXIT DISPLAY
					ON ACTION finiwiz
						LET l_state = "accept"
						EXIT DISPLAY
				END DISPLAY
		END CASE
	END WHILE
END FUNCTION
--------------------------------------------------------------------------------
FUNCTION upd_left()
	DISPLAY ARRAY lFields TO l.*
		BEFORE DISPLAY
			EXIT DISPLAY
	END DISPLAY
END FUNCTION
--------------------------------------------------------------------------------
FUNCTION upd_right()
	DISPLAY ARRAY rFields TO r.*
		BEFORE DISPLAY
			EXIT DISPLAY
	END DISPLAY
END FUNCTION
--------------------------------------------------------------------------------
