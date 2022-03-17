IMPORT os
IMPORT util
IMPORT FGL fglgallery
IMPORT FGL g2_lib.*
CONSTANT C_PRGVER  = "1.0"
CONSTANT C_PRGDESC = "WC Gallery Demo"
CONSTANT C_PRGAUTH = "Neil J.Martin"
CONSTANT C_PRGICON = "logo_dark"

DEFINE m_rec RECORD
	gallery_type INTEGER,
	gallery_size INTEGER,
	aspect_ratio DECIMAL(5, 2),
	multi_sel    BOOLEAN,
	current      INTEGER,
	gallery_wc   STRING
END RECORD
DEFINE struct_value fglgallery.t_struct_value
CONSTANT C_MAX_IMAGES = 50
DEFINE m_base STRING
DEFINE m_pics_info DYNAMIC ARRAY OF RECORD
	imgnam STRING,
	pth    STRING,
	nam    STRING,
	mod    STRING,
	siz    STRING,
	typ    STRING,
	rwx    STRING
END RECORD
MAIN
	DEFINE l_rec RECORD
		fileName STRING,
		richtext STRING,
		fld2     STRING,
		info     STRING
	END RECORD
	DEFINE l_tmp STRING
	DEFINE l_ret SMALLINT

	CALL g2_core.m_appInfo.progInfo(C_PRGDESC, C_PRGAUTH, C_PRGVER, C_PRGICON)
	CALL g2_init.g2_init(ARG_VAL(1), "default")

	DISPLAY "FGLSERVER:", fgl_getenv("FGLSERVER")
	DISPLAY "FGLIMAGEPATH:", fgl_getenv("FGLIMAGEPATH")
	DISPLAY "PWD:", os.path.pwd()
	LET m_base = checkBase(ARG_VAL(3))
	DISPLAY "Base:", m_base

	CALL getImages("(svg|jpg|png|gif)")
	DISPLAY "Image Found:", m_pics_info.getLength()

	CALL gallery()

END MAIN
-------------------------------------------------------------------------------
FUNCTION gallery()
	DEFINE id SMALLINT
	DEFINE x  SMALLINT
	OPTIONS INPUT WRAP, FIELD ORDER FORM
	OPEN FORM f1 FROM "wc_gallery"
	DISPLAY FORM f1

	CALL fglgallery.initialize()
	LET id = fglgallery.create("formonly.gallery_wc")

	-- URLs
	CALL fglgallery.addImage(
			id, "http://freebigpictures.com/wp-content/uploads/2009/09/mountain-ridge.jpg", "Mountain ridge")
	CALL fglgallery.addImage(
			id, "http://freebigpictures.com/wp-content/uploads/2009/09/mountain-horse.jpg", "Horse in field")
	CALL fglgallery.addImage(
			id, "http://freebigpictures.com/wp-content/uploads/forest-in-spring-646x433.jpg", "Forest in spring")
	CALL fglgallery.addImage(
			id, "http://freebigpictures.com/wp-content/uploads/2009/09/mountain-waterfall.jpg", "Montain waterfall")
	CALL fglgallery.addImage(
			id, "http://freebigpictures.com/wp-content/uploads/2009/09/summer-river-646x432.jpg", "River in summer")
	CALL fglgallery.addImage(
			id, "http://freebigpictures.com/wp-content/uploads/2009/09/reservoir-lake.jpg", "Reservoir lake")

	FOR x = 1 TO m_pics_info.getLength()
		CALL fglgallery.addImage(
				id, image_path(m_pics_info[x].nam), SFMT("%1 ( %2kb )", m_pics_info[x].imgnam, m_pics_info[x].siz))
	END FOR

	LET m_rec.gallery_type = FGLGALLERY_TYPE_THUMBNAILS
	LET m_rec.gallery_size = FGLGALLERY_SIZE_NORMAL
	LET m_rec.aspect_ratio = 0.0
	CALL fglgallery.setImageAspectRatio(id, m_rec.aspect_ratio)
	LET m_rec.multi_sel = TRUE
	CALL fglgallery.setMultipleSelection(id, m_rec.multi_sel)
	LET struct_value.current = 1
	LET m_rec.current        = struct_value.current
	LET m_rec.gallery_wc     = util.JSON.stringify(struct_value)
	CALL fglgallery.setMultipleSelection(id, TRUE)
	CALL fglgallery.display(id, m_rec.gallery_type, m_rec.gallery_size)

	INPUT BY NAME m_rec.* ATTRIBUTES(UNBUFFERED, WITHOUT DEFAULTS, CANCEL = FALSE, ACCEPT = FALSE)

		ON CHANGE gallery_type
			CALL fglgallery.display(id, m_rec.gallery_type, m_rec.gallery_size)

		ON CHANGE gallery_size
			CALL fglgallery.display(id, m_rec.gallery_type, m_rec.gallery_size)

		ON CHANGE aspect_ratio
			CALL fglgallery.setImageAspectRatio(id, m_rec.aspect_ratio)
			CALL fglgallery.display(id, m_rec.gallery_type, m_rec.gallery_size)

		ON CHANGE multi_sel
			CALL fglgallery.setMultipleSelection(id, m_rec.multi_sel)

		ON ACTION set_current ATTRIBUTES(TEXT = "Set current", IMAGE = "fa-check-square-o")
			LET struct_value.current = m_rec.current
			LET m_rec.gallery_wc     = util.JSON.stringify(struct_value)

		ON ACTION image_selection ATTRIBUTES(DEFAULTVIEW = NO)
			CALL util.JSON.parse(m_rec.gallery_wc, struct_value)
			LET m_rec.current = struct_value.current

		ON ACTION disable_wc ATTRIBUTES(TEXT = "Disable", IMAGE = "fa-circle-o")
			CALL DIALOG.setFieldActive("gallery_wc", FALSE)
		ON ACTION enable_wc ATTRIBUTES(TEXT = "Enable", IMAGE = "fa-dot-circle-o")
			CALL DIALOG.setFieldActive("gallery_wc", TRUE)

		ON ACTION clean ATTRIBUTES(TEXT = "Clean", IMAGE = "fa-square-o")
			CALL fglgallery.clean(id)
			LET m_rec.current = NULL

		ON ACTION about
			CALL g2_about.g2_about()

		ON ACTION quit
			EXIT INPUT

		ON ACTION close
			EXIT INPUT

	END INPUT

	CALL fglgallery.destroy(id)
	CALL fglgallery.finalize()

END FUNCTION
-------------------------------------------------------------------------------
FUNCTION image_path(path)
	DEFINE path STRING
	RETURN ui.Interface.filenameToURI(path)
END FUNCTION
-------------------------------------------------------------------------------
FUNCTION display_type_init(cb)
	DEFINE cb ui.ComboBox
	CALL cb.addItem(FGLGALLERY_TYPE_MOSAIC, "Mosaic")
	CALL cb.addItem(FGLGALLERY_TYPE_LIST, "List")
	CALL cb.addItem(FGLGALLERY_TYPE_THUMBNAILS, "Thumbnails")
	CALL cb.addItem(FGLGALLERY_TYPE_SLIDESHOW, "Slideshow")
END FUNCTION
-------------------------------------------------------------------------------
FUNCTION display_size_init(cb)
	DEFINE cb ui.ComboBox
	CALL cb.addItem(FGLGALLERY_SIZE_XSMALL, "X-Small")
	CALL cb.addItem(FGLGALLERY_SIZE_SMALL, "Small")
	CALL cb.addItem(FGLGALLERY_SIZE_NORMAL, "Normal")
	CALL cb.addItem(FGLGALLERY_SIZE_LARGE, "Large")
	CALL cb.addItem(FGLGALLERY_SIZE_XLARGE, "X-Large")
END FUNCTION
-------------------------------------------------------------------------------
FUNCTION aspect_ratio_init(cb)
	DEFINE cb ui.ComboBox
	-- Use strings for value to match DECIMAL(5,2) formatting
	CALL cb.addItem("0.00", "none")
	CALL cb.addItem("1.00", "1:1")
	CALL cb.addItem("1.77", "16:9")
	CALL cb.addItem("1.50", "3:2")
	CALL cb.addItem("1.33", "4:3")
	CALL cb.addItem("1.25", "5:4")
	CALL cb.addItem("0.56", "9:16")
	CALL cb.addItem("0.80", "4:5")
END FUNCTION
--------------------------------------------------------------------------------
FUNCTION getImages(p_ext STRING)
	DEFINE l_ext, l_path STRING
	DEFINE d, l_imgSize  INTEGER
	DEFINE x             SMALLINT
	CALL os.Path.dirSort("name", 1)
	LET d = os.Path.dirOpen(m_base)
	IF d > 0 THEN
		WHILE TRUE
			LET l_path = os.Path.dirNext(d)
			IF l_path IS NULL THEN
				EXIT WHILE
			END IF

			IF os.path.isDirectory(l_path) THEN
				--DISPLAY "Dir:",path
				CONTINUE WHILE
			ELSE
				--DISPLAY "Fil:",path
			END IF

			LET l_ext = os.path.extension(l_path)
			IF l_ext IS NULL OR NOT (l_ext.matches(p_ext)) THEN
				CONTINUE WHILE
			END IF

			IF l_path.subString(1, 6) = "banner" THEN
				CONTINUE WHILE
			END IF
			IF l_path.subString(1, 6) = "FourJs" THEN
				CONTINUE WHILE
			END IF
			IF l_path.subString(1, 6) = "Genero" THEN
				CONTINUE WHILE
			END IF
			IF l_path.subString(2, 2) = "_" THEN
				CONTINUE WHILE
			END IF
			IF l_path.subString(3, 3) = "_" THEN
				CONTINUE WHILE
			END IF
			IF l_path.subString(3, 3) = "." THEN
				CONTINUE WHILE
			END IF
			LET x                     = m_pics_info.getLength() + 1
			LET m_pics_info[x].imgnam = l_path
			LET m_pics_info[x].nam    = os.Path.rootName(l_path)
			LET m_pics_info[x].pth    = m_base
			LET m_pics_info[x].mod    = os.Path.mtime(m_pics_info[x].imgnam)
			LET l_imgSize             = os.Path.size(m_base || l_path)
			LET m_pics_info[x].siz    = l_imgSize USING "<<,<<<,<<<"
			LET m_pics_info[x].pth    = m_base
			LET m_pics_info[x].typ    = l_ext
			LET m_pics_info[x].rwx    = os.Path.rwx(m_base || l_path)
			--DISPLAY m_pics.getLength(),": File:",path," Ext:",l_ext
			IF m_pics_info.getLength() = C_MAX_IMAGES THEN
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
