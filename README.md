# njms_demos320
My Genero Demos updated for Genero 3.20 and legacy code removed.

The default user and log for the demo is:
test@test.com / 12test


The Demos:
* ipodTree - Tree demo
* picFlow - picFlow GDC
* widgets - Genero Widgets and UI features


The Web Component Demos:
* wc_aircraft - Interactive Images - Aricraft catering
* wc_d3charrt - Charting
* wc_amCharting - Charting
* wc_googleMaps - Google Maps
* wc_kite - Interactive Image - SVG Kite
* wc_music - Music player


The Application Framework:
* Login
* User Creation
* Menu System
* Basic table maintainance
* Order Entry
* Invoice printing
* Web Ordering


When deployed as via the gas the application urls will be:
```
http://<server>/<gas-alias>/ua/r/<xcf>
or
http://<server>:6394/ua/r/<xcf>
```

The xcf files are:
* njmdemo - Main demo with login using default GBC


Databases:
* Informix
* PostgreSQL
* Maria DB
* SQL Server


For PostgreSQL
```
sudo -u postgres createuser <appuser>
sudo -u postgres createdb njm_demo310
sudo -u postgres psql
psql (9.6.7)
Type "help" for help.

postgres=# grant all privileges on database njm_demo310 to <appuser>;
GRANT
postgres=# \q
```


For MariaDB added a user of 'dbuser' to connect to the database.
```
MariaDB [(none)]> CREATE USER 'dbuser'@'%';
MariaDB [(none)]> GRANT ALL PRIVILEGES ON *.* TO 'dbuser'@'%';
```


This demo uses imported git repos for common library code and GBC customizations
* git submodule add https://github.com/neilm-fourjs/g2_lib.git g2_lib
* git submodule add https://github.com/neilm-fourjs/gbc_mdi.git gbc_mdi

If libraries change do:
* git submodule foreach git pull origin master

