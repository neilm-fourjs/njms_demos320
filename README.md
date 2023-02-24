# njms_demos320
My Genero Demos updated for Genero 3.20 and most of the legacy code removed.

The default user and log for the demo is:
guest / guest
or
test@test.com / 12test


The Demos:
* Widgets - Genero Widgets and UI features
* ipodTree - Tree demo
* PicFlow - picFlow GDC
* Display Array demos
* Multi cell select
* Table List View  ( Browser / GDC UR only )
* Stack Demo ( Browser / GDC UR only )


The Web Component Demos:
* wc_googleMaps - Google Maps
* wc_amCharting - Charting
* wc_d3charrt - Charting
* wc_gauge - Gauges & Pie
* wc_kite - Interactive Image - SVG Kite
* wc_aircraft - Interactive Images - Aricraft catering
* wc_music - Music player


The Application Framework:
* Login
* User Creation
* Menu System
* Basic table maintainance
* Order Entry
* Invoice printing
* Web Ordering

# Cloning and building

*IMPORTANT* Make sure you use the --recursive flag when you clone this repo, eg: On Linux
```
$ git clone --recursive https://github.com/neilm-fourjs/njms_demos320.git
$ cd njms_demos320
$ make
```
For Genero 4.0x
```
$ git clone --recursive https://github.com/neilm-fourjs/njms_demos320.git
$ cd njms_demos320/
$ git checkout g400
$ cd g2_lib
$ git checkout v400
$ make   <-- note: you might need to run this twice to get success!
$ cd ..
$ make
```
NOTE: if you are build from GeneroStudio use the njms_demos400.4pw

NOTE: the DOS versions are probably out of date so use the normal version and just check the env vars for Linux/DOS specific paths

This demo uses imported git repos for common library code and GBC customizations
* git submodule add https://github.com/neilm-fourjs/g2_lib.git g2_lib
* git submodule add https://github.com/neilm-fourjs/gbc_mdi.git gbc_mdi
* git submodule add https://github.com/neilm-fourjs/gbc_njm.git gbc_njm
* git submodule add https://github.com/neilm-fourjs/gbc_clean.git gbc_clean

If libraries change, you can do:
* git submodule foreach git pull origin master


When deployed as via the gas the application urls will be:
```
http://<server>/<gas-alias>/ua/r/<xcf>
or
http://<server>:6394/ua/r/<xcf>
```

# Running the deployed demos ( xcf files )

GDC / Browser
* njmdemo - Main demo with login, in the GDC it will use native rendering, in the browser it uses my gbc_clean custom GBC.
* njmdemo_ur - Main demo with login, in the GDC it will use universal rendering using my gbc_clean custom GBC.
* fontAwesome - A simple viewer for the fontAwesome glyphs.
* materialDesignTest - This is a simple demo showing common widgets / containers, used for testing custom GBC builds.

Just Browser
* njm_demo_web - This demo was for POC, the aim was to show a completely different look-n-feel in the Browser
* njmweb2 - This is a store demo with a responsive scroll grid and features a few customisations of the GBC

# Databases

Originally the demos using a database where written for Informix, but currently I mainly PostgreSQL

* Informix
* PostgreSQL
* Maria DB
* SQL Server


For PostgreSQL
```
sudo -u postgres createuser <appuser>
sudo -u postgres createdb njm_demo400
sudo -u postgres psql
psql (9.6.7)
Type "help" for help.

postgres=# grant all privileges on database njm_demo400 to <appuser>;
GRANT
postgres=# \q
```

or
```
postgres=# \connect njm_demo400;
You are now connected to database "njm_demo400" as user "postgres".
njm_demo400=# GRANT UPDATE ON ALL TABLES IN SCHEMA public TO fourjs;
GRANT
njm_demo400=# GRANT INSERT ON ALL TABLES IN SCHEMA public TO fourjs;
GRANT
njm_demo400=# GRANT DELETE ON ALL TABLES IN SCHEMA public TO fourjs;
GRANT
```

For MariaDB added a user of 'dbuser' to connect to the database.
```
sudo mysql
MariaDB [(none)]> CREATE USER 'dbuser'@'%';
MariaDB [(none)]> GRANT ALL PRIVILEGES ON *.* TO 'dbuser'@'%';
```

For MySQL 8
```
$ sudo mysql
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 9
Server version: 8.0.21-0ubuntu0.20.04.4 (Ubuntu)

mysql> CREATE USER 'dbuser'@'%' IDENTIFIED BY '12dbuser' ;
Query OK, 0 rows affected (0.04 sec)

mysql> GRANT ALL PRIVILEGES ON *.* TO 'dbuser'@'%';
Query OK, 0 rows affected (0.01 sec)


$ mysql -u dbuser
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 11
Server version: 8.0.21-0ubuntu0.20.04.4 (Ubuntu)

mysql> CREATE DATABASE njm_demo400;
Query OK, 1 row affected (0.00 sec)
mysql> GRANT ALL PRIVILEGES ON njm_demo400.* TO 'dbuser'@'%' WITH GRANT OPTION;
Query OK, 1 row affected (0.00 sec)
```

