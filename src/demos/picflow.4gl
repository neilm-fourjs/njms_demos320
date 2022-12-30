IMPORT os

IMPORT FGL g2_lib.*

CONSTANT C_PRGVER  = "3.1"
CONSTANT C_PRGDESC = "picFlow Demo"
CONSTANT C_PRGAUTH = "Neil J.Martin"
CONSTANT C_PRGICON = "logo_dark"

DEFINE max_images SMALLINT

DEFINE m_pics DYNAMIC ARRAY OF RECORD
	pic STRING
END RECORD
DEFINE m_pics_info DYNAMIC ARRAY OF RECORD
	pth STRING,
	nam STRING,
	mod STRING,
	siz STRING,
	typ STRING,
	rwx STRING
END RECORD
DEFINE m_base, html_start, html_end STRING

MAIN
	DEFINE frm ui.Form
	DEFINE n om.DomNode
	DEFINE l_c INT
	CALL g2_core.m_appInfo.progInfo(C_PRGDESC, C_PRGAUTH, C_PRGVER, C_PRGICON)
	CALL g2_init.g2_init(base.Application.getArgument(1), "picflow")

	DISPLAY "FGLSERVER:", fgl_getenv("FGLSERVER")
	DISPLAY "FGLIMAGEPATH:", fgl_getenv("FGLIMAGEPATH")
	DISPLAY "PWD:", os.Path.pwd()

	LET m_base = checkBase(base.Application.getArgument(3))
	DISPLAY "Base:", m_base

	OPEN FORM picf FROM "picflow"
	DISPLAY FORM picf

	LET max_images = 50
	CALL getImages("svg", "png")

	DISPLAY "Image Found:", m_pics.getLength()
	IF m_pics.getLength() = 0 THEN
		CALL g2_core.g2_winMessage("Error", SFMT("Not found any images in '%1'", m_base), "exclamation")
		EXIT PROGRAM
	END IF

	LET html_start = "<P ALIGN=\"CENTER\">"
	LET html_end   = "<\P>"

	LET l_c = 1
	DIALOG ATTRIBUTE(UNBUFFERED)
		DISPLAY ARRAY m_pics TO pics.*
			BEFORE ROW
				LET l_c = arr_curr()
				CALL refresh(DIALOG)
--		ON IDLE 5
--			LET c = c + 1
--			IF c > m_pics.getLength() THEN LET c = 1 END IF
--			CALL DIALOG.setCurrentRow( "pics", c )
		END DISPLAY

		INPUT l_c FROM c
			ON CHANGE c
				CALL DIALOG.setCurrentRow("pics", l_c)
				CALL refresh(DIALOG)
		END INPUT

		BEFORE DIALOG
			LET frm = DIALOG.getForm()
			LET n   = frm.findNode("FormField", "formonly.c")
			LET n   = n.getFirstChild()
			CALL n.setAttribute("valueMax", m_pics.getLength())

		ON ACTION quit
			EXIT DIALOG

		ON ACTION firstrow
			LET l_c = 1
			CALL DIALOG.setCurrentRow("pics", l_c)
			CALL refresh(DIALOG)
		ON ACTION lastrow
			LET l_c = m_pics.getLength()
			CALL DIALOG.setCurrentRow("pics", l_c)
			CALL refresh(DIALOG)
		ON ACTION nextrow
			IF l_c < m_pics.getLength() THEN
				CALL DIALOG.setCurrentRow("pics", (l_c + 1))
				CALL refresh(DIALOG)
			END IF
		ON ACTION prevrow
			IF l_c > 1 THEN
				CALL DIALOG.setCurrentRow("pics", (l_c - 1))
				CALL refresh(DIALOG)
			END IF
		ON ACTION about
			CALL g2_about.g2_about()

		ON ACTION close
			EXIT DIALOG
	END DIALOG
	CALL g2_core.g2_exitProgram(0, %"Program Finished")
END MAIN
--------------------------------------------------------------------------------
FUNCTION refresh(l_d ui.Dialog)
	DEFINE l_c INTEGER
	LET l_c = l_d.getCurrentRow("pics")

	CALL l_d.setActionActive("firstrow", NOT l_c=1)
	CALL l_d.setActionActive("prevrow", NOT l_c=1)
	CALL l_d.setActionActive("lastrow", NOT l_c=m_pics.getLength())
	CALL l_d.setActionActive("nextrow", NOT l_c=m_pics.getLength())
	DISPLAY html_start || m_pics_info[l_c].nam || html_end TO nam
	DISPLAY "Arr:", l_c, ":", m_pics[l_c].pic
	DISPLAY l_c TO cur
	DISPLAY m_pics.getLength() TO max
	DISPLAY m_pics[l_c].pic TO img
	IF os.Path.exists(m_pics[l_c].pic) THEN
		DISPLAY "Found:", m_pics[l_c].pic
	ELSE
		DISPLAY "Not Found:", m_pics[l_c].pic
	END IF
	DISPLAY m_pics_info[l_c].nam TO d1
	DISPLAY m_pics_info[l_c].typ TO d2
	DISPLAY m_pics_info[l_c].pth TO d3
	DISPLAY m_pics_info[l_c].siz TO d4
	DISPLAY m_pics_info[l_c].mod TO d5
	DISPLAY m_pics_info[l_c].rwx TO d6

	CALL ui.Interface.refresh()
END FUNCTION
--------------------------------------------------------------------------------
FUNCTION getImages(p_ext STRING, p_ext2 STRING)
	DEFINE l_ext    STRING
	DEFINE l_dirobj STRING
	DEFINE l_file   STRING
	DEFINE l_dir    INTEGER
	CALL os.Path.dirSort("name", 1)
	LET l_dir = os.Path.dirOpen(m_base)
	IF l_dir > 0 THEN
		WHILE TRUE
			LET l_dirobj = os.Path.dirNext(l_dir)
			IF l_dirobj IS NULL THEN
				EXIT WHILE
			END IF

			IF os.Path.isDirectory(l_dirobj) THEN
				--DISPLAY "Dir:",path
				CONTINUE WHILE
			ELSE
				--DISPLAY "Fil:",path
			END IF

			LET l_ext = os.Path.extension(l_dirobj)
			IF l_ext IS NULL OR (p_ext != l_ext AND p_ext2 != l_ext) THEN
				CONTINUE WHILE
			END IF

			IF l_dirobj.subString(1, 6) = "banner" THEN
				CONTINUE WHILE
			END IF
			IF l_dirobj.subString(1, 6) = "FourJs" THEN
				CONTINUE WHILE
			END IF
			IF l_dirobj.subString(1, 6) = "Genero" THEN
				CONTINUE WHILE
			END IF
			IF l_dirobj.subString(2, 2) = "_" THEN
				CONTINUE WHILE
			END IF
			IF l_dirobj.subString(3, 3) = "_" THEN
				CONTINUE WHILE
			END IF
			IF l_dirobj.subString(3, 3) = "." THEN
				CONTINUE WHILE
			END IF

			LET l_file                              = os.Path.join(m_base, l_dirobj)
			LET m_pics[m_pics.getLength() + 1].pic  = l_dirobj
			LET m_pics_info[m_pics.getLength()].nam = os.Path.rootName(l_dirobj)
			LET m_pics_info[m_pics.getLength()].pth = m_base
			LET m_pics_info[m_pics.getLength()].mod = os.Path.mtime(l_file)
			LET m_pics_info[m_pics.getLength()].siz = (os.Path.size(l_file) USING "<<,<<<,<<<")
			LET m_pics_info[m_pics.getLength()].pth = m_base
			LET m_pics_info[m_pics.getLength()].typ = l_ext
			LET m_pics_info[m_pics.getLength()].rwx = os.Path.rwx(l_file)
			--DISPLAY SFMT("%1: File: %2 Ext: %3 Size: %4",	m_pics.getLength(), l_file, l_ext, m_pics_info[m_pics.getLength()].siz)
			IF m_pics.getLength() = max_images THEN
				EXIT WHILE
			END IF
		END WHILE
	END IF

END FUNCTION
--------------------------------------------------------------------------------
FUNCTION checkBase(l_base STRING) RETURNS STRING
	IF l_base IS NULL OR l_base.getLength() < 1 THEN
		LET l_base = g2_core.g2_getImagePath()
	END IF
	RETURN l_base
END FUNCTION
--------------------------------------------------------------------------------
