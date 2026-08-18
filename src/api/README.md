# api

REST API for `njm_demo` database access. `njm_demoapi` is the service program;
it publishes the customer endpoints and runs the request loop. The service is
deployed as `njm.xcf`.

A separate stock-query service is in [`../ws/`](../ws/README.md).

## Modules

| Module | Description |
|--------|-------------|
| njm_demoapi.4gl | Service entry point — connects to the database, registers the customer service, and processes requests. |
| njm_cust_ws.4gl | Customer REST endpoints: `GET /list/{token}` and `GET /get/{key}/{token}`, both returning JSON. |
| njm_cust_db.4gl | Data access for the endpoints. Defines `t_customers` with the array, the current record, and the message. |
| ws_lib.4gl | Service helpers — request-status reporting, host name, and token validation. |

## Endpoints

```
GET <server>/ws/r/njm/customers/list/<token>
GET <server>/ws/r/njm/customers/get/<key>/<token>
```

A valid token is necessary. `ws_lib.checkToken()` does the check.
