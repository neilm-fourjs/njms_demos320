# applib

Shared application definitions. The `applib` package holds the code that the
demo programs use; the `.inc` files hold the constants, the schema statement,
and the table type definitions.

Modules compile with `-Iapplib`, so the includes resolve from any source folder.

## Modules

| Module | Description |
|--------|-------------|
| app_lib.4gl | User and role library — read the user record, build the full name, check role permissions, and enable actions from a six-character `allowedActions` string (find, list, update, insert, delete, same). |
| combos.4gl | Combo-box population functions for categories, suppliers, users, status, customers, colours, countries, and division. |

## Includes

| File | Description |
|------|-------------|
| app.inc | Application constants — version, name, description, splash image, icon, and the default test account. |
| schema.inc | `SCHEMA njm_demo400` for compile-time checks, plus the `DBNAME` define. |
| njm_demo400.inc | Table type definitions with primary-key and foreign-key constants. `mk_db` uses these with `reflect` to create the application tables. |
| ordent.inc | Order-entry globals — the detail-line type, VAT rate, and postage bands. |
