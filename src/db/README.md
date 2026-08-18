# db

Database creation and demo-data loader. `mk_db` drops and recreates the tables,
then loads the roles, the menu, the users, and the demonstration business data.
It is on the Utilities menu as **Reset Database**, and deployed as
`njmdemodb.xcf`.

The program asks for confirmation before it deletes anything.

## Run

```bash
make db                     # from the project root
cd njm_app_bin600 && fglrun mk_db [ALL|SYS|APP|DROP]
```

| Argument | Action |
|----------|--------|
| `ALL` (default) | System tables and application tables — drop, create, and load. |
| `SYS` | System tables only: users, roles, menus, login history. |
| `APP` | Application tables only: customers, stock, orders, quotes. |
| `DROP` | Drop both sets of tables and stop. |

## Modules

| Module | Description |
|--------|-------------|
| mk_db.4gl | Main program — connects (and creates the database), lists the tables, confirms, then drives the create and load steps. |
| mk_db_lib.4gl | Progress reporting to the form and resource-file lookup through `FGLRESOURCEPATH`. |
| mk_db_sys_ifx.4gl | Creates the system tables (Informix syntax, used for all databases except SQLite). |
| mk_db_sys_sqt.4gl | Creates the system tables for SQLite. |
| mk_db_sys_data.4gl | Loads the roles, the complete menu tree, the `guest` and test accounts, and the test users from `sys_users.json`. |
| mk_db_app_ifx.4gl | Creates the application tables from the `njm_demo400.inc` types with `reflect` and `g2_createTable`. |
| mk_db_app_data.4gl | Generates the demo business data — countries, colours, suppliers, stock, packs, bar codes, orders, and quotes. |

## Form

`mk_db.per` shows an information line and a scrolling progress table.
