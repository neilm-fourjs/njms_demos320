IMPORT FGL wizard_common
GLOBALS "wizard_glob.inc"
DEFINE drag_source STRING
DEFINE dnd         ui.DragDrop
FUNCTION wizard_ui_dnd()
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
			ON DRAG_START(dnd)
				LET drag_source = "left"
			ON DRAG_ENTER(dnd)
				CALL drop_validate("right")
			ON DROP(dnd)
				CALL mv_left(DIALOG)
			ON DRAG_FINISHED(dnd)
				INITIALIZE drag_source TO NULL
		END DISPLAY
		DISPLAY ARRAY rFields TO r.*
			ON ACTION left
				CALL mv_left(DIALOG)
			ON ACTION allleft
				CALL all_left()
			ON DRAG_START(dnd)
				LET drag_source = "right"
			ON DRAG_ENTER(dnd)
				CALL drop_validate("left")
			ON DROP(dnd)
				CALL mv_right(DIALOG)
			ON DRAG_FINISHED(dnd)
				INITIALIZE drag_source TO NULL
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
--------------------------------------------------------------------------------
FUNCTION drop_validate(target)
	DEFINE target STRING
	IF drag_source = target THEN
		CALL dnd.setOperation("move")
		CALL dnd.setFeedback("insert")
	ELSE
		CALL dnd.setOperation(NULL)
	END IF
END FUNCTION
