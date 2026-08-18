# app

Traditional desktop order-entry application — customer maintenance, stock management, order entry, and invoice printing. Uses the `g2_lib` framework and demonstrates classic Genero GUI patterns with rich dialogs, menus, and reporting.

A web/GBC variant of the same business domain lives in [`../app_web/`](../app_web/).

## Modules

| Module | Description |
|--------|-------------|
| cust_mnt.4gl | Customer maintenance with multi-table input for delivery and invoice addresses. |
| dm_stock.4gl | Dynamic stock maintenance with find/update/insert/delete and combobox initialisation. |
| oe_lib.4gl | Order-entry library: customer lookup, stock retrieval, pack handling, price/tax calculations. |
| oeweb_lib.4gl | Web order-entry library: category browsing, shopping cart, login/registration, order placement. |
| ordent.4gl | Order entry: new order creation, line-item management, stock allocation, enquiry. |
| printInvoices.4gl | Invoice/picklist generator using GRE, with pack explosion and tax summaries. |
| webOE.4gl | Web ordering interface v1 with dynamic grid layout (CSS or traditional grid). |
| webOE2.4gl | Web ordering interface v2 with simplified input-array-based product display. |
