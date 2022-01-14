
IMPORT os

IMPORT FGL g2_init
IMPORT FGL g2_core
IMPORT FGL g2_appInfo
IMPORT FGL g2_about
CONSTANT C_PRGVER = "3.1"
CONSTANT C_PRGDESC = "WC Richtext Demo"
CONSTANT C_PRGAUTH = "Neil J.Martin"
CONSTANT C_PRGICON = "logo_dark"
CONSTANT C_DEF
    = '<p>This is a test 2<br/>Of <strong><u>RICHTEXT !!</u></strong><br/><strong style="color:#0066cc"><u>Something Blue</u></strong><br/></p>'
DEFINE m_appInfo g2_appInfo.appInfo
TYPE t_rec RECORD
    fileName STRING,
    richtext STRING,
    fld2 STRING,
    info STRING
  END RECORD
 DEFINE m_rec t_rec
MAIN
  DEFINE l_tmp STRING
  DEFINE l_ret SMALLINT

  CALL m_appInfo.progInfo(C_PRGDESC, C_PRGAUTH, C_PRGVER, C_PRGICON)
  CALL g2_init.g2_init(ARG_VAL(1), "default")

  LET m_rec.fileName = "text.html"
  LET m_rec.richtext = C_DEF
  LET m_rec.info = "Default Text"

  OPTIONS INPUT WRAP, FIELD ORDER FORM
	CLOSE WINDOW SCREEN
  OPEN WINDOW w0 WITH FORM "wc_richtext"

  INPUT BY NAME m_rec.* ATTRIBUTES(UNBUFFERED, WITHOUT DEFAULTS, ACCEPT = FALSE, CANCEL = FALSE)

		ON ACTION dialogtest
			CALL doDialogTest()

    ON ACTION myCopy
      DISPLAY "Copy"
      CALL ui.Interface.frontCall(
          "standard", "cbset", DIALOG.getFieldValue(DIALOG.getCurrentItem()), l_ret)

    ON ACTION myPaste
      DISPLAY "Paste"
      CALL ui.Interface.frontCall("standard", "cbPaste", "", l_ret)

    ON ACTION clear
      LET m_rec.richtext = NULL
      LET m_rec.info = % "Text cleared."

    ON ACTION autosave ATTRIBUTES(DEFAULTVIEW = NO)
      IF saveText("autosave.html", m_rec.richtext) THEN
        LET m_rec.info = CURRENT HOUR TO SECOND, % ":Auto Saved"
        DISPLAY m_rec.info
      ELSE
        LET m_rec.info = CURRENT HOUR TO SECOND, % ":No text!"
        DISPLAY m_rec.info
      END IF

    ON ACTION deftext
      LET m_rec.richtext = C_DEF
      LET m_rec.info = "Default Text"
      DISPLAY m_rec.info

    ON ACTION savetext
      IF saveText(m_rec.fileName, m_rec.richtext) THEN
        LET m_rec.info = SFMT(% "Text saved to '%1'", m_rec.fileName)
        DISPLAY m_rec.info
      END IF

    ON ACTION loadText
      LET l_tmp = loadText(m_rec.fileName)
      IF l_tmp IS NOT NULL THEN
        LET m_rec.richtext = l_tmp
        LET m_rec.info = SFMT(% "Text loaded from '%1'", m_rec.fileName)
        DISPLAY m_rec.info
      END IF

    AFTER FIELD fld2
      LET l_tmp = loadText(m_rec.fileName)
      DISPLAY " l_tmp contains ", l_tmp
      IF l_tmp IS NOT NULL THEN
        LET m_rec.richtext = l_tmp
        LET m_rec.info = SFMT(% "Text loaded from '%1'", m_rec.fileName)
        DISPLAY m_rec.info
      END IF
      DISPLAY " m_rec.richtext contains ", m_rec.richtext

    ON ACTION set_focus_to_fn
      NEXT FIELD filename

    ON ACTION set_focus_to_test
      NEXT FIELD fld2

    ON ACTION set_focus_to_wc
      NEXT FIELD richtext
    ON ACTION about
			CALL g2_about.g2_about(m_appInfo)
    ON ACTION close
      EXIT PROGRAM
    ON ACTION quit
      EXIT PROGRAM
  END INPUT
	CLOSE WINDOW w0
  CALL g2_core.g2_exitProgram(0, % "Program Finished")
END MAIN
--------------------------------------------------------------------------------
FUNCTION loadText(l_fileName STRING) RETURNS STRING
  DEFINE l_txt TEXT
  IF NOT os.path.exists(l_fileName) THEN
    ERROR "File Not Found!"
    RETURN NULL
  END IF
  LOCATE l_txt IN MEMORY
  CALL l_txt.readFile(l_fileName)
  RETURN l_txt
END FUNCTION
--------------------------------------------------------------------------------
FUNCTION saveText(l_fileName STRING, l_html STRING) RETURNS BOOLEAN
  DEFINE l_txt TEXT
  IF l_html.getLength() = 0 THEN
    RETURN FALSE
  END IF
  LOCATE l_txt IN FILE l_fileName
  LET l_txt = l_html
  RETURN TRUE
END FUNCTION
--------------------------------------------------------------------------------
FUNCTION getDVMVer()
  RETURN "Genero: " || fgl_getversion()
END FUNCTION
--------------------------------------------------------------------------------
FUNCTION doDialogTest()
  OPEN WINDOW w1 WITH FORM "wc_richtext_d"
  INPUT BY NAME m_rec.* ATTRIBUTES(UNBUFFERED, WITHOUT DEFAULTS)
	CLOSE WINDOW w1
END FUNCTION
