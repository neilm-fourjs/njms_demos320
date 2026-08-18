# ws

REST web service for stock-inventory queries. Contains both the server-side service and a generated client library. The `Makefile` automates compilation and regenerates the client from the OpenAPI spec via `fglrestful`.

## Modules

| Module | Description |
|--------|-------------|
| cli_stockQuery.4gl | Auto-generated REST client wrapping HTTP calls to the stockQuery endpoint. |
| stockQuery.4gl | REST service implementation: stock list/item queries and service control endpoints. |
| stockQuery_main.4gl | Service entry point — initialises the database and starts the web service. |
| test_stockQuery.4gl | Test program that invokes the generated client to fetch stock item `FR01`. |

## Build

`Makefile` compiles the service and regenerates `cli_stockQuery.4gl` from the running endpoint's OpenAPI document.
