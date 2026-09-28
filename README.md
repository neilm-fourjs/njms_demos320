# njms_demos600

NJM's Genero demos, updated for **Genero 6.00**. The repository holds UI feature
demos, web-component demos, dialog (wizard) demos, a small order-entry
application, a REST service, and the system framework that runs them.

All Genero source code is in [`src/`](src/). Each source folder has its own
`README.md` with a module-by-module table.

## Source layout

| Folder | Contents |
|--------|----------|
| [`src/demos`](src/demos/README.md) | Standalone UI, web-component, chart, and wizard demos. |
| [`src/app`](src/app/README.md) | Desktop order-entry application — customers, stock, orders, invoices. |
| [`src/app_web`](src/app_web/README.md) | Web/GBC variant of the same business domain (list/detail pattern). |
| [`src/sys`](src/sys/README.md) | Login, users, roles, dynamic menu, and the MDI container. |
| [`src/utils`](src/utils/README.md) | Icon viewers, GBC theme viewer, Material Design test, GRE report test. |
| [`src/ws`](src/ws/README.md) | REST stock-query service and its generated client. |
| [`src/gl_dynMaint`](src/gl_dynMaint/README.md) | Generic runtime CRUD program — no per-table forms. |
| [`src/OpenIdLogin`](src/OpenIdLogin/README.md) | OpenID Connect login example. |
| [`src/api`](src/api/README.md) | REST API for `njm_demo` database access (`njm_demoapi`). |
| [`src/applib`](src/applib/README.md) | Application constants, schema include, combo-box helpers. |
| [`src/db`](src/db/README.md) | Database creation and demo-data loader (`mk_db`). |
| [`src/glm`](src/glm/README.md) | Package that builds forms, SQL, and UI at runtime for `dynMaint`. |

Support folders outside `src/`:

| Folder | Contents |
|--------|----------|
| `etc` | Schema, forms resources, style sheets (`.4st`), action defaults (`.4ad`), reports (`.4rp`), DB profiles. |
| `pics` | Images, logos, icon fonts, and `image2font` mapping files. |
| `distarc`, `distbin` | Archive staging folder and the built `.gar`. |
| `gas_deploy`, `gas_ws` | Application configuration files (`.xcf`) for GAS deployment. |
| `njm_app_bin600` | Compiled `.42m` / `.42f` output for Genero 6.00. |
| `g2_lib` | Common library (git submodule). |
| `gbc_clean`, `gbc_njm`, `gbc_mdi` | GBC customizations (git submodules). |

## Login

The database loader creates two accounts:

```
guest / guest
test@test.com / T3st.T3st
```

## The demos

The menu is database driven. `mk_db` loads it, so the entries below are what the
main menu shows.

### UI demo programs

| Menu item | Program |
|-----------|---------|
| Widgets Demo | `widgets` — widgets, containers, charts, and interactive controls. |
| ipodTree Demo | `ipodTree` — tree view of a music library with album art. |
| Display Array Demo 1 / 2 | `dispArr A` / `dispArr B` — two `DISPLAY ARRAY` styles. |
| Input Array Expenses Demo | `expenses` — `INPUT ARRAY` with live totals and VAT. |
| Multi Cell Select | `multi_cell_sel` — multiple-cell selection in a table. |
| Table - List View | `listView` — list-view rendering (GBC or Universal Rendering only). |

### Web component demos

| Menu item | Program |
|-----------|---------|
| GoogleMaps | `wc_gm` |
| AmCharts | `wc_amcharts` |
| D3Charts | `wc_d3Charts` |
| Gauge / Pie | `wc_gauge` |
| Kite Colourizer | `wc_kite` — interactive SVG. |
| Aircraft | `wc_aircraft` — interactive SVG with drag and drop. |
| Remote Music Player | `wc_music` |
| Calendar | `wc_calendar_demo` |
| Richtext | `wc_richtext` |
| Gallery | `wc_gallery` |

### Wizard / dialog demos

Four programs do the same task with a different dialog technique:

| Menu item | Program | Technique |
|-----------|---------|-----------|
| Wizard SD | `wizard_sd` | One `DIALOG`, state machine. |
| Wizard MD | `wizard_md` | Separate dialogs per step. |
| Wizard MRS | `wizard_mrs` | Multiple-row selection. |
| Wizard DnD | `wizard_dnd` | Drag and drop between arrays. |

### Desktop applications

| Menu item | Program |
|-----------|---------|
| Customer Enquiry | `cust_mnt YYNNNN` |
| Stock / Supplier Enquiry | `dynMaint <db> stock stock_code YYNNNN` |
| Customer Maintenance | `cust_mnt` |
| Stock Maintenance | `dm_stock` |
| Stock Cat, Supplier, Colours, Countries Maintenance | `dynMaint` with the table and key |
| Order Entry | `ordent` |
| Web Order Entry #1 / #2 | `webOE` / `webOE2` |
| Print Invoices ASK / PDF | `printInvoices 0 ordent ASK preview` / `printInvoices 0 ordent PDF preview` |
| Print Picking Notes | `printInvoices picklist` |

### Web applications

| Menu item | Program |
|-----------|---------|
| Customers | `custs` |
| Products | `prods` |
| Quotes | `quotes` |

### System maintenance

| Menu item | Program |
|-----------|---------|
| User/Role Maintenance | `user_mnt` |
| Menu/Role Maintenance | `menu_mnt` |
| View Login History | `login_hist` |

### Utilities

| Menu item | Program |
|-----------|---------|
| Material Design Test | `matDesTest` |
| Font Viewer (default, FA5, FA6.5, njmdemos, Material Design) | `fontAwesome` |
| GRE Test 4RP | `gre_test4rp` |
| Reset Database | `mk_db` |

## Clone

Use `--recursive`, because the library and the GBC customizations are
submodules:

```bash
git clone --recursive https://github.com/neilm-fourjs/njms_demos600.git
cd njms_demos600
```

To update the submodules later:

```bash
git submodule foreach git pull origin master
```

## Build

`FGLDIR` must point to the Genero installation. The top-level `Makefile` sets
the demo environment (`FGLIMAGEPATH`, `FGLRESOURCEPATH`, `FGLDBPATH`,
`FGLPROFILE`, `FGLGBCDIR`) and then calls `src/makefile`.

```bash
make          # extract the schema, compile all modules, build the .gar
make run      # run the main menu from njm_app_bin600
make db       # create the database and load the demo data
make clean    # delete .42?, .zip, .gar, and .4pdb files
make beautify # apply the .fgl-format rules to every src/*.4gl
```

Useful variables:

| Variable | Default | Purpose |
|----------|---------|---------|
| `GENVER` | `600` | Genero version; selects the `njm_app_bin<ver>` output folder. |
| `DBTYPE` | `pgs` | Database driver profile in `etc/<dbtype>/profile`. |
| `DBNAME` | `njm_demo400` | Database name. |
| `GBC` | `gbc-clean` | GBC customization used through `FGLGBCDIR`. |

To compile one module by hand:

```bash
fglcomp -M -Wall <module>.4gl   # -> .42m
fglform -M <form>.per           # -> .42f
FGLGUI=0 TERM=xterm fglrun <module>.42m
```

In Genero Studio, open `njms_demos600.4pw`.

## Database

The demos run mainly on **PostgreSQL**. Informix, MariaDB / MySQL, and SQL
Server profiles are in `etc/`. Create the database and the user, then run
`make db`.

```bash
sudo -u postgres createuser <appuser>
sudo -u postgres createdb njm_demo400
sudo -u postgres psql -c "grant all privileges on database njm_demo400 to <appuser>;"
psql -d njm_demo400 -c "ALTER USER neilm PASSWORD '12test';"
psql -d njm_demo400 --password -c "SELECT user;"
```

## Deployment

`mk_gar.sh` stages `distarc/` and builds `distbin/njms_demos600_pgs.gar` from
the `.xcf` files in `gas_deploy/`.

```bash
make deploy     # deploy and enable the archive
make undeploy   # disable and remove the archive
make redeploy   # undeploy then deploy
```

Deployed applications:

| `.xcf` | Program | Notes |
|--------|---------|-------|
| `njmdemo` | `menu` | Main demo with login. Native rendering in the GDC, `gbc_clean` in the browser. |
| `nd` | `menu` | Main demo, alternative configuration. |
| `njmdemo_web` | `container` | MDI container version — different look and feel in the browser. |
| `njmweb` | `webOE` | Web ordering, version 1. |
| `njmweb2` | `webOE2` | Store demo with a responsive scroll grid. |
| `njmdemodb` | `mk_db` | Database creation and reset. |
| `fontAwesome` | `fontAwesome` | Icon viewer. |
| `materialDesignTest` | `matDesTest` | Widget and container test page for custom GBC builds. |
| `njm` | `njm_demoapi` | REST API for database access. |
| `ws_demo` | `stockQuery` | REST stock-query service (in `gas_ws/`). |

Application URLs:

```
http://<server>/<gas-alias>/ua/r/<xcf>
http://<server>:6394/ua/r/<xcf>
```
