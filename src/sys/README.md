# sys

Core system modules: authentication, authorisation, and application navigation. Provides the login system, user/menu administration, and the central menu dispatcher that drives application launch.

## Modules

| Module | Description |
|--------|-------------|
| container.4gl | MDI container that manages child windows and enforces proper shutdown order. |
| lib_login.4gl | Login library with password validation, OpenID support, and session management. |
| login_hist.4gl | Read-only display of login-history audit records. |
| menu.4gl | Main menu driver; integrates login and builds the dynamic menu from the database. |
| menuLib.4gl | Menu library providing hierarchical navigation and program-execution dispatch. |
| menu_mnt.4gl | Menu maintenance UI for admins — configure menus and assign role-based access. |
| new_acct.4gl | Account-creation dialog with email validation, password generation, and expiry rules. |
| user_mnt.4gl | User maintenance with CRUD and drag-and-drop role assignment. |
