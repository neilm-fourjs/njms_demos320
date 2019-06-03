#+ A simple restfull api for stock queries
#+ neilm@4js.com

-- The web service functions
IMPORT FGL stockQuery

MAIN

  IF NOT stockQuery.init() THEN
    EXIT PROGRAM
  END IF

  CALL stockQuery.start()

END MAIN
