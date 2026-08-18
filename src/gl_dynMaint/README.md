# gl_dynMaint

Generic dynamic maintenance framework. Generates a CRUD UI at runtime from a table name and key argument — no per-table forms required.

## Files

| File | Description |
|------|-------------|
| dynMaint.4gl | Generic maintenance program; takes a table/key and provides find, insert, update, delete, and navigation. |
| dynMaint.inc | Type definitions for field properties, form-init callbacks, and SQL constants for record navigation (`FIRST`/`PREV`/`NEXT`/`LAST`). |
