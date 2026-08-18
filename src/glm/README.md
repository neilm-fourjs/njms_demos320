# glm

The generic-maintenance engine. The `glm` package builds the form, the SQL, and
the dialog at runtime from a table name and a key field, so no per-table code is
necessary.

Two programs use it: `dynMaint` in [`../gl_dynMaint/`](../gl_dynMaint/README.md)
and `dm_stock` in [`../app/`](../app/README.md). The type definitions come from
`gl_dynMaint/dynMaint.inc`.

## Modules

| Module | Description |
|--------|-------------|
| glm_mkForm.4gl | Builds the form at runtime — reads the column list, splits the fields across folder pages, and applies the field properties (hidden, no-entry, widget, combo-box callback). |
| glm_sql.4gl | Builds and runs the dynamic SQL — select with an optional `WHERE`, row fetch, insert, update, delete, and the `dbsync` audit columns. |
| glm_ui.4gl | Drives the dialog — action menu, `CONSTRUCT` for the find, `INPUT` for insert and update, field validation, the JSON record, and the result list. |

## Call sequence

```
glm_sql.glm_mkSQL()      read the column list for <db> <table>
glm_mkForm.init_form()   build the form from the columns and the field properties
glm_ui.glm_menu()        action menu:
  find    glm_constrct()  -> glm_mkSQL() -> glm_getRow(SQL_FIRST)
  list    glm_findList()  -> glm_mkSQL() -> glm_getRow(SQL_FIRST)
  nav     glm_getRow(SQL_FIRST | SQL_PREV | SQL_NEXT | SQL_LAST)
  insert  glm_inpt(TRUE)  -> glm_SQLinsert()
  update  glm_inpt(FALSE) -> glm_SQLupdate()
  delete  glm_SQLdelete()
```
