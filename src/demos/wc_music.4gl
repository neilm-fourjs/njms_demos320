IMPORT util
IMPORT os

IMPORT FGL g2_init
IMPORT FGL g2_core
IMPORT FGL g2_appInfo
IMPORT FGL g2_about
IMPORT FGL g2_aui
CONSTANT C_PRGVER  = "3.1"
CONSTANT C_PRGDESC = "WC Music Demo"
CONSTANT C_PRGAUTH = "Neil J.Martin"
CONSTANT C_PRGICON = "logo_dark"
DEFINE m_base STRING
DEFINE m_songs DYNAMIC ARRAY OF RECORD
	genre  STRING,
	artist STRING,
	album  STRING,
	name   STRING,
	file   STRING
END RECORD
DEFINE m_tree DYNAMIC ARRAY OF RECORD
	id     STRING,
	pid    STRING,
	descr  STRING,
	genre  STRING,
	artist STRING,
	album  STRING,
	track  STRING,
	file   STRING,
	img    STRING
END RECORD
DEFINE m_songno SMALLINT

MAIN
	DEFINE l_data STRING
	CALL g2_core.m_appInfo.progInfo(C_PRGDESC, C_PRGAUTH, C_PRGVER, C_PRGICON)
	CALL g2_init.g2_init(ARG_VAL(1), "default")

	LET m_base = fgl_getenv("MUSICDIR")

	CALL get_music(TRUE)

	CLOSE WINDOW SCREEN
	OPEN WINDOW w WITH FORM "wc_music"

	LET m_songno = 1

	DIALOG ATTRIBUTES(UNBUFFERED)
		DISPLAY ARRAY m_tree TO arr.*
			ON ACTION accept
				LET m_songno = arr_curr()
				CALL change_song()
		END DISPLAY
		INPUT BY NAME l_data
		END INPUT
		ON ACTION quit
			EXIT DIALOG
		ON ACTION previous
			IF m_songno > 1 THEN
				LET m_songno = m_songno - 1
			END IF
			CALL change_song()
		ON ACTION next
			IF m_songno < m_songs.getLength() THEN
				LET m_songno = m_songno + 1
			END IF
			CALL change_song()
		ON ACTION close
			EXIT DIALOG
		ON ACTION refresh
			CALL get_music(FALSE)
		ON ACTION about
			CALL g2_about.g2_about()
	END DIALOG

	CALL g2_core.g2_exitProgram(0, %"Program Finished")
END MAIN
--------------------------------------------------------------------------------
#+ Change Song
FUNCTION change_song()
	CALL wc_setProp("mp3file", ui.Interface.filenameToURI(m_tree[m_songno].file))
	CALL wc_setProp("name", m_tree[m_songno].artist || " - " || m_tree[m_songno].album || " - " || m_tree[m_songno].track)
	DISPLAY ui.Interface.filenameToURI(m_tree[m_songno].file) TO fn
END FUNCTION
--------------------------------------------------------------------------------
#+ Set a Property in the AUI
FUNCTION wc_setProp(l_prop_name STRING, l_value STRING)
	DEFINE w ui.Window
	DEFINE n om.domNode
	LET w = ui.Window.getCurrent()
	LET n = w.findNode("Property", l_prop_name)
	IF n IS NULL THEN
		DISPLAY "can't find property:", l_prop_name
		RETURN
	END IF
	CALL n.setAttribute("value", l_value)
END FUNCTION
--------------------------------------------------------------------------------
#+ Build the tree array strucure
FUNCTION buildTree()
	DEFINE x, pid                                                       SMALLINT
	DEFINE l_prev_genre, l_prev_art, l_prev_alb, l_genre_pid, l_art_pid STRING
	LET x            = 1
	LET pid          = 0
	LET l_prev_genre = "."
	LET l_prev_art   = "."
	LET l_prev_alb   = "."
	CALL m_songs.sort("name",FALSE)
	CALL m_songs.sort("album",FALSE)
	CALL m_songs.sort("artist",FALSE)
	CALL m_songs.sort("genre",FALSE)
	CALL m_tree.clear()
	FOR m_songno = 1 TO m_songs.getLength()
		DISPLAY SFMT("%1 Genre: %2 Artist: %3 Album: %4 Name: %5",
					(m_songno USING "###&"), 
					m_songs[m_songno].genre, 
					m_songs[m_songno].artist, 
					m_songs[m_songno].album,
					m_songs[m_songno].name)
		IF m_songs[m_songno].genre != l_prev_genre THEN
			LET m_tree[x].id    = (x USING "&&&&&&")
			LET m_tree[x].pid   = "000"
			LET m_tree[x].descr = m_songs[m_songno].genre
			LET m_tree[x].img   = "smiley"
			LET pid             = x
			LET l_genre_pid     = (pid USING "&&&&&&")
			LET x               = x + 1
			LET l_prev_genre    = m_songs[m_songno].genre
		END IF
		IF m_songs[m_songno].artist != l_prev_art THEN
			LET m_tree[x].id    = (x USING "&&&&&&")
			LET m_tree[x].pid   = l_genre_pid
			LET m_tree[x].descr = m_songs[m_songno].artist
			LET m_tree[x].img   = "fa-user"
			LET pid             = x
			LET l_art_pid       = (pid USING "&&&&&&")
			LET x               = x + 1
			LET l_prev_art      = m_songs[m_songno].artist
		END IF
		IF m_songs[m_songno].album != l_prev_alb THEN
			LET m_tree[x].id    = (x USING "&&&&&&")
			LET m_tree[x].pid   = l_art_pid
			LET m_tree[x].descr = m_songs[m_songno].album
			LET m_tree[x].img   = "fa-folder"
			LET pid             = x
			LET x               = x + 1
			LET l_prev_alb      = m_songs[m_songno].album
		END IF
		LET m_tree[x].id     = (x USING "&&&&&&")
		LET m_tree[x].pid    = (pid USING "&&&&&&")
		LET m_tree[x].descr  = m_songs[m_songno].name
		LET m_tree[x].file   = m_songs[m_songno].file
		LET m_tree[x].track  = m_songs[m_songno].name
		LET m_tree[x].genre  = m_songs[m_songno].genre
		LET m_tree[x].artist = m_songs[m_songno].artist
		LET m_tree[x].album  = m_songs[m_songno].album
		LET m_tree[x].img    = "fa-music"
		LET x                = x + 1
	END FOR
END FUNCTION
--------------------------------------------------------------------------------
#+ Get a songs from $MUSICDIR/musiccache.json
FUNCTION loadCache(l_file STRING)
	DEFINE c          base.Channel
	DEFINE l_json_str STRING
	LET c = base.Channel.create()
	CALL c.openFile(l_file, "r")
	WHILE NOT c.isEof()
		LET l_json_str = l_json_str.append(c.readLine())
	END WHILE
	CALL c.close()
	CALL util.JSONArray.parse(l_json_str).toFGL(m_tree)
END FUNCTION
--------------------------------------------------------------------------------
#+ Save song list to $MUSICDIR/musiccache.json
FUNCTION saveCache(l_file STRING)
	DEFINE c          base.Channel
	DEFINE l_json     util.JSONArray
	DEFINE l_json_str STRING
	LET l_json     = util.JSONArray.fromFGL(m_tree)
	LET l_json_str = l_json.toString()
	LET c          = base.Channel.create()
	CALL c.openFile(l_file, "w")
	CALL c.writeLine(l_json_str)
	CALL c.close()
END FUNCTION
--------------------------------------------------------------------------------
#+ Get a songs from $MUSICDIR folder
FUNCTION get_music(l_useCache BOOLEAN)
	DEFINE l_path, l_cache STRING
	DEFINE d               INTEGER

	IF NOT os.path.exists(m_base) THEN
		ERROR SFMT("MUSICDIR '%1' Not Found!", m_base)
		CALL g2_core.g2_winMessage("Error", SFMT("MUSICDIR '%1' Not Found!", m_base), "exclamation")
		RETURN
	END IF

	LET l_cache = os.Path.join(m_base, "musiccache.json")
	DISPLAY "Getting Music from ", m_base, " Cache:", l_cache
	IF os.path.exists(l_cache) AND l_useCache THEN
		IF g2_core.m_mdi != "C" THEN
			CALL g2_aui.g2_winInfo(2, SFMT("Reading cache file %1", m_base), "")
		END IF
		CALL loadCache(l_cache)
		IF g2_core.m_mdi != "C" THEN
			CALL g2_aui.g2_winInfo(3, "", "")
		END IF
		RETURN
	END IF

	CALL g2_aui.g2_winInfo(1, SFMT("Getting Music Info from %1, please wait ...", m_base), "information")

	LET m_songno = 1
	CALL m_songs.clear()
	CALL os.Path.dirSort("name", 1)
	LET d = os.Path.dirOpen(m_base)
	IF d > 0 THEN
		WHILE TRUE
			LET l_path = os.Path.dirNext(d)
			IF l_path IS NULL THEN
				EXIT WHILE
			END IF

			IF l_path.getCharAt(1) = "_" OR l_path.getCharAt(1) = "." THEN
				CONTINUE WHILE
			END IF
			CALL g2_aui.g2_winInfo(2, "Getting Music Info, please wait ...\nDirectory: " || l_path, "")
			IF os.path.isDirectory(os.path.join(m_base, l_path)) THEN
				IF l_path.getCharAt(1) != "_" THEN
					LET m_songs[m_songno].genre = l_path
--				DISPLAY "Processing Dir:",l_path, " songno=",(m_songno USING "&&&&")," Artist:", m_songs[ m_songno ].artist
					CALL get_albums(os.path.join(m_base, l_path))
				END IF
			ELSE
--				DISPLAY "Skipping File:",l_path
			END IF
		END WHILE
	END IF
	CALL g2_aui.g2_winInfo(2, "Build Tree, please wait ...", "")
	CALL buildTree()

	CALL g2_aui.g2_winInfo(2, "Saving music tree cache, please wait ...", "")
	CALL saveCache(l_cache)
	CALL g2_aui.g2_winInfo(3, "", "")
END FUNCTION
--------------------------------------------------------------------------------
#+ Get a album folders
FUNCTION get_albums(l_path STRING)
	DEFINE d     INTEGER
	DEFINE l_dir STRING

	IF l_path.getCharAt(1) = "_" THEN
		DISPLAY SFMT("  Skipped _ folder %1", l_dir)
		RETURN
	END IF

	DISPLAY "  Getting Artists from ", l_path
	LET l_dir = l_path

	CALL os.Path.dirSort("name", 1)
	LET d = os.Path.dirOpen(l_dir)
	IF d > 0 THEN
		WHILE TRUE
			LET l_path = os.Path.dirNext(d)
			IF l_path IS NULL THEN
				EXIT WHILE
			END IF
			IF l_path.getCharAt(1) = "_" OR l_path.getCharAt(1) = "." THEN
				CONTINUE WHILE
			END IF
			DISPLAY "    Getting Albums from ", l_path
			CALL g2_aui.g2_winInfo(2, "Getting Music Info, please wait ...\nDirectory: " || l_path, "")
			IF os.path.isDirectory(os.path.join(l_dir, l_path)) THEN
				IF l_path.getCharAt(1) != "_" THEN
					LET m_songs[m_songno].artist = l_path
--				DISPLAY "Processing Dir:",l_path, " songno=",(m_songno USING "&&&&")," Artist:", m_songs[ m_songno ].artist
					CALL get_songs(os.path.join(l_dir, l_path))
				END IF
			ELSE
--				DISPLAY "Skipping File:",l_path
			END IF
		END WHILE
	END IF
END FUNCTION
--------------------------------------------------------------------------------
#+ Get a songs from $MUSICDIR folder
FUNCTION get_songs(l_path STRING)
	DEFINE l_ext, l_dir STRING
	DEFINE d            INTEGER

	LET l_dir = l_path
	IF l_dir.getCharAt(1) = "_" THEN
		DISPLAY SFMT("  Skipped _ folder %1", l_dir)
		RETURN
	END IF
	DISPLAY SFMT("      Getting Songs for Album %1", l_dir)
	CALL os.Path.dirSort("name", 1)
	LET d = os.Path.dirOpen(l_dir)
	IF d > 0 THEN
		WHILE TRUE
			LET l_path = os.Path.dirNext(d)
			IF l_path IS NULL THEN
				EXIT WHILE
			END IF

			IF l_path.getCharAt(1) = "_" OR l_path.getCharAt(1) = "." THEN
				CONTINUE WHILE
			END IF

			IF os.path.isDirectory(os.path.join(l_dir, l_path)) THEN
				LET m_songs[m_songno].album = l_path
				CALL get_songs(os.path.join(l_dir, l_path))
			END IF

			LET l_ext = os.path.extension(l_path)
			IF l_ext IS NULL OR (l_ext != "mp3" AND l_ext != "ogg") THEN
--				DISPLAY "Skipping File:",l_path
				CONTINUE WHILE
			END IF

			IF m_songs[m_songno].genre IS NULL THEN
				LET m_songs[m_songno].genre = m_songs[m_songno - 1].genre
			END IF
			IF m_songs[m_songno].artist IS NULL THEN
				LET m_songs[m_songno].artist = m_songs[m_songno - 1].artist
			END IF
			IF m_songs[m_songno].album IS NULL THEN
				IF m_songno > 1 THEN
					LET m_songs[m_songno].album = m_songs[m_songno - 1].album
				ELSE
					LET m_songs[m_songno].album = "Unknown"
				END IF
			END IF
			LET m_songs[m_songno].file = os.path.join(l_dir, l_path)
			LET m_songs[m_songno].name = os.path.rootName(l_path)
			DISPLAY SFMT("        Song: %1", l_path)
{			DISPLAY SFMT("Adding No: %1 Genre: %2 Artist: %3 Album: %4 File: %5 Name: %6",
					(m_songno USING "###&"), 
					m_songs[m_songno].genre, 
					m_songs[m_songno].artist, 
					m_songs[m_songno].album,
					m_songs[m_songno].file,
					m_songs[m_songno].name)}

			LET m_songno = m_songno + 1
		END WHILE
	ELSE
		DISPLAY "ERROR in Opening Dir!"
	END IF
END FUNCTION
