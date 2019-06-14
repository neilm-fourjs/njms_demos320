
export FGLPROFILE=../../etc/wsprofile
export FGLWSDEBUG=3

all: test_stockQuery.42m

cli_stockQuery.4gl: 
	fglrestful -o cli_stockQuery.4gl https://generodemos.dynu.net/f/ws/r/ws_demo/stockQuery?openapi.json

cli_stockQuery.42m: cli_stockQuery.4gl
	fglcomp $^

test_stockQuery.42m: test_stockQuery.4gl cli_stockQuery.42m
	fglcomp test_stockQuery.4gl

