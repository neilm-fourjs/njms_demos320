#+ A simple restfull api for stock queries
#+ neilm@4js.com

-- The web service functions
IMPORT FGL stockQuery

MAIN

  CALL stockQuery.init()

END MAIN
