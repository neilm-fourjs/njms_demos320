#+ Web Order Entry Demo - by N.J.Martin neilm@4js.com
#+
IMPORT FGL g2_init
IMPORT FGL g2_core
IMPORT FGL g2_about
IMPORT FGL g2_db

IMPORT FGL oe_lib
IMPORT FGL oeweb_lib

&include "app.inc"
&include "ordent.inc"
CONSTANT C_PRGVER  = "3.2"
CONSTANT C_PRGDESC = "Web Ordering Demo #2"
CONSTANT C_PRGAUTH = "Neil J.Martin"
CONSTANT C_PRGICON = "logo_dark"

DEFINE m_dialog ui.Dialog
DEFINE m_fields DYNAMIC ARRAY OF RECORD
	name STRING,
	type STRING
END RECORD

MAIN
	DEFINE l_win  ui.Window
	DEFINE l_form ui.Form
	DEFINE l_cat  SMALLINT

	CALL g2_core.m_appInfo.progInfo(C_PRGDESC, C_PRGAUTH, C_PRGVER, C_PRGICON)
	CALL g2_init.g2_init(ARG_VAL(1), "weboe")

	WHENEVER ANY ERROR CALL g2_core.g2_error
	CALL g2_db.m_db.g2_connect(NULL)

	CALL ui.Interface.setText(C_PRGDESC)

	OPEN FORM weboe FROM "webOE2"
	DISPLAY FORM weboe

	LET l_win  = ui.Window.getCurrent()
	LET l_form = l_win.getForm()

	CALL oeweb_lib.initAll()
	CALL oeweb_lib.logaccess(FALSE, g_cust.email)
	DISPLAY "Customer:", g_custname
	DISPLAY g_custname TO custname

	CALL oeweb_lib.build_sqls()
	CALL oeweb_lib.get_categories()
	CALL oeweb_lib.build_cats(l_form)

	LET l_cat = 1
	WHILE l_cat > 0
		CALL oeweb_lib.getItems(m_stock_cats[l_cat].id)
		LET l_cat = dynDiag()
	END WHILE
	CALL g2_core.g2_exitProgram(0, "Program Finished")
END MAIN
--------------------------------------------------------------------------------
FUNCTION dynDiag() RETURNS SMALLINT
	DEFINE x     SMALLINT
	DEFINE l_evt STRING

	CALL recalcOrder()

	CALL m_fields.clear()
	LET m_fields[m_fields.getLength() + 1].name = "img1"
	LET m_fields[m_fields.getLength()].type     = "STRING"
	LET m_fields[m_fields.getLength() + 1].name = "det1"
	LET m_fields[m_fields.getLength()].type     = "STRING"
	LET m_fields[m_fields.getLength() + 1].name = "qty1"
	LET m_fields[m_fields.getLength()].type     = "INTEGER"

	CALL ui.Dialog.setDefaultUnbuffered(TRUE)
	LET m_dialog = ui.Dialog.createInputArrayFrom(m_fields, "items")

	CALL m_dialog.addTrigger("ON ACTION close")
	CALL m_dialog.addTrigger("ON ACTION add1")
	CALL m_dialog.addTrigger("ON ACTION viewb")
	CALL m_dialog.addTrigger("ON ACTION signin")
	CALL m_dialog.addTrigger("ON ACTION gotoco")
	CALL m_dialog.addTrigger("ON ACTION about")
	CALL m_dialog.addTrigger("ON ACTION cancel")
	CALL m_dialog.addTrigger("ON ACTION detlnk1")

	FOR x = 1 TO m_items.getLength()
		CALL m_dialog.setCurrentRow("items", x)
		CALL m_dialog.setFieldValue("items.qty1", m_items[x].qty1)
		CALL m_dialog.setFieldValue("items.img1", m_items[x].img1)
		CALL m_dialog.setFieldValue("items.det1", m_items[x].desc1)
		DISPLAY "Desc1", x, ":", m_items[x].desc1
	END FOR
	CALL m_dialog.setCurrentRow("items", 1)
	FOR x = 1 TO m_stock_cats.getLength()
		CALL m_dialog.addTrigger("ON ACTION cat" || x)
	END FOR
	IF g_ordHead.total_qty > 1 THEN
		CALL m_dialog.setActionActive("viewb", TRUE)
		CALL m_dialog.setActionActive("gotoco", TRUE)
	ELSE
		CALL m_dialog.setActionActive("viewb", FALSE)
		CALL m_dialog.setActionActive("gotoco", FALSE)
	END IF
	CALL oeweb_lib.setSignInAction()
	LET int_flag = FALSE
	WHILE TRUE
		LET l_evt = m_dialog.nextEvent()
		LET x     = m_dialog.getCurrentRow("items")
		DISPLAY "Event:", l_evt, " Row:", x

		IF l_evt MATCHES "ON ACTION cat*" THEN
			CALL m_dialog.accept()
			RETURN l_evt.subString(14, l_evt.getLength())
		END IF

		IF l_evt MATCHES "ON ACTION detlnk1" THEN
			CALL detLnk(m_items[x].stock_code1, m_items[x].desc1, m_items[x].img1, m_items[x].qty1)
		END IF

		IF l_evt MATCHES "ON CHANGE qty*" OR l_evt MATCHES "AFTER FIELD qty*" THEN
			CALL detLine(m_items[x].stock_code1, m_dialog.getFieldValue("qty1"))
		END IF

		CASE l_evt
			WHEN "ON ACTION add1"
				LET m_items[x].qty1 = m_items[x].qty1 + 1
				CALL detLine(m_items[x].stock_code1, m_items[x].qty1)
				CALL m_dialog.setFieldValue("qty1", m_items[x].qty1)

			WHEN "ON ACTION close"
				LET int_flag = TRUE
				EXIT WHILE

			WHEN "ON ACTION cancel"
				LET int_flag = TRUE
				EXIT WHILE

			WHEN "ON ACTION signin"
				CALL oeweb_lib.signin()

			WHEN "ON ACTION viewb"
				CALL oeweb_lib.viewb()
			WHEN "ON ACTION gotoco"
				CALL gotoco()
			WHEN "ON ACTION about"
				CALL g2_about.g2_about()
		END CASE
	END WHILE
	IF int_flag THEN
		LET int_flag = FALSE
	END IF
	RETURN 0
END FUNCTION
