GLOBALS "wizard_glob.inc"
FUNCTION wizard_ui_mrs()
  DIALOG ATTRIBUTE(UNBUFFERED)
    INPUT BY NAME currTable ATTRIBUTE(WITHOUT DEFAULTS)
      ON CHANGE currtable
        CALL on_change_currTable()
    END INPUT
    DISPLAY ARRAY lFields TO l.*
      ON ACTION right
        CALL right(DIALOG)
      ON ACTION allright
        CALL allright()
    END DISPLAY
    DISPLAY ARRAY rFields TO r.*
      ON ACTION left
        CALL left(DIALOG)
      ON ACTION allleft
        CALL allleft()
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
