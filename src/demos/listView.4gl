IMPORT util
IMPORT os

IMPORT FGL g2_lib.*

CONSTANT C_PRGVER = "3.1"
CONSTANT C_PRGDESC = "List View Demo"
CONSTANT C_PRGAUTH = "Neil J.Martin"
CONSTANT C_PRGICON = "logo_dark"

CONSTANT C_IMGPATH = "got"

TYPE t_contactList RECORD
  cont_name STRING,
  details STRING,
  img STRING
END RECORD

TYPE t_contact RECORD
  cont_id SMALLINT,
  cont_name STRING,
  house STRING,
  bio STRING,
  img STRING
END RECORD

DEFINE m_conts DYNAMIC ARRAY OF t_contact
DEFINE m_contList DYNAMIC ARRAY OF t_contactList
MAIN

  CALL g2_core.m_appInfo.progInfo(C_PRGDESC, C_PRGAUTH, C_PRGVER, C_PRGICON)
  CALL g2_core.g2_init(ARG_VAL(1), "default")

  CALL load_contacts()

--	DISPLAY util.JSON.stringify(m_conts)

  OPEN FORM f FROM "listView"
  DISPLAY FORM f

  CALL disp_contacts()

END MAIN
--------------------------------------------------------------------------------
FUNCTION load_contacts()
  CALL m_conts.clear()
  CALL m_contList.clear()
  CALL add_contact("Tyrion Lannister", "Brainy one, with scar, short.")
  CALL add_contact("Jamie Lannister", "Pretty boy, one arm, tall")
  CALL add_contact("Cersei Lannister", "Evil")
  CALL add_contact("Joffrey Baratheon", "Annoying little runt")
  CALL add_contact("Daenerys Targaryen", "Mother of Dragons, blah blah")
  CALL add_contact("Sansa Stark", "Vain")
  CALL add_contact("Arya Stark", "Cute, turning evil?")
  CALL add_contact("Bran Stark", "Crippled and strange!")
  CALL add_contact("Jon Snow", "Bastard and brooding")
  CALL add_contact("Margaery Tyrell", "")
  CALL add_contact("Theon Greyjoy", "")
END FUNCTION
--------------------------------------------------------------------------------
FUNCTION add_contact(l_name STRING, l_bio STRING)
  DEFINE l_nam, l_house, l_img STRING
  DEFINE x SMALLINT
  LET x = l_name.getIndexOf(" ", 1)
  LET l_nam = l_name.subString(1, x - 1).toLowerCase()
  LET l_house = l_name.subString(x + 1, l_name.getLength())
  IF l_house = "Snow" THEN
    LET l_house = "Stark"
  END IF
  CALL m_conts.appendElement()

  LET l_img = os.path.join(C_IMGPATH, l_nam) || ".jpg"
--	DISPLAY "Img:",l_img," - ",os.path.join(getImagePath(),l_img)
  IF NOT os.path.exists(os.path.join(getImagePath(), l_img)) THEN
    LET l_img = os.path.join(C_IMGPATH, l_house)
  END IF

  LET m_conts[m_conts.getLength()].cont_id = m_conts.getLength()
  LET m_conts[m_conts.getLength()].cont_name = l_name
  LET m_conts[m_conts.getLength()].house = l_house
  LET m_conts[m_conts.getLength()].bio = l_bio
  LET m_conts[m_conts.getLength()].img = l_img

  CALL m_contList.appendElement()
  LET m_contList[m_contList.getLength()].cont_name = l_name
  LET m_contList[m_contList.getLength()].details = "House:", l_house
  LET m_contList[m_contList.getLength()].img = l_img
END FUNCTION
--------------------------------------------------------------------------------
FUNCTION disp_contacts()
	DEFINE l_info, l_img STRING
	DISPLAY ARRAY m_contList TO arr.* ATTRIBUTES(ACCEPT = FALSE, CANCEL = FALSE)
		BEFORE ROW
			LET l_img = os.path.join(C_IMGPATH, m_conts[DIALOG.getCurrentRow("arr")].house)
			DISPLAY BY NAME m_conts[DIALOG.getCurrentRow("arr")].*
			DISPLAY l_img TO himg
			LET l_info = SFMT("Image path '%1'", l_img)
		ON ACTION show_info ATTRIBUTES( ROWBOUND, TEXT="Show", IMAGE="fa-info" )
			CALL g2_core.g2_winMessage("Imagel",l_info,"information")
		ON UPDATE
			CALL g2_core.g2_winMessage("Imagel","Update not support yet!","information")
		ON ACTION close
			EXIT DISPLAY
		ON ACTION quit
			EXIT DISPLAY
		ON ACTION about
			CALL g2_about.g2_about(g2_core.m_appInfo)
	END DISPLAY

END FUNCTION
--------------------------------------------------------------------------------
FUNCTION getImagePath()
  DEFINE l_path STRING
  DEFINE l_st base.StringTokenizer
  LET l_st = base.StringTokenizer.create(fgl_getEnv("FGLIMAGEPATH"), os.path.pathSeparator())
  WHILE l_st.hasMoreTokens()
    LET l_path = l_st.nextToken()
    IF os.path.isDirectory(l_path) THEN
      RETURN l_path
    END IF
  END WHILE
  RETURN "."
END FUNCTION
