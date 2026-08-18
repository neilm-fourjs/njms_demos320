# app_web

Web/GBC-friendly variant of the order-entry domain. Uses list/detail patterns with form-only fields and JSON-backed SQL wrappers — a lighter counterpart to the traditional desktop app in [`../app/`](../app/).

## Modules

| Module | Description |
|--------|-------------|
| custmnt.4gl | Customer detail form with delivery and invoice address management. |
| custs.4gl | Customer list/search with inline-edit launcher and report output. |
| prodmnt.4gl | Product maintenance with colour picker via `onChange` callback. |
| prods.4gl | Product list/search with inventory visibility and report generation. |
| quotemnt.4gl | Quote detail editor showing header and line items (products, colours). |
| quotes.4gl | Quote list/search with status highlighting and revision tracking. |
