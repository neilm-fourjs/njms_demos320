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


*IMPORTANT* Make sure you use the --recursive flag when you clone this repo, eg: On Linux
```
$ git clone --recursive https://github.com/neilm-fourjs/njms_demos320.git
$ cd njms_demos320
$ make
```


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

or
```
postgres=# \connect njm_demo310;
You are now connected to database "njm_demo310" as user "postgres".
njm_demo310=# GRANT UPDATE ON ALL TABLES IN SCHEMA public TO fourjs;
GRANT
njm_demo310=# GRANT INSERT ON ALL TABLES IN SCHEMA public TO fourjs;
GRANT
njm_demo310=# GRANT DELETE ON ALL TABLES IN SCHEMA public TO fourjs;
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

mysql> CREATE DATABASE njm_demo310;
Query OK, 1 row affected (0.00 sec)
mysql> GRANT ALL PRIVILEGES ON njm_demo310.* TO 'dbuser'@'%' WITH GRANT OPTION;
Query OK, 1 row affected (0.00 sec)
```


This demo uses imported git repos for common library code and GBC customizations
* git submodule add https://github.com/neilm-fourjs/g2_lib.git g2_lib
* git submodule add https://github.com/neilm-fourjs/gbc_mdi.git gbc_mdi
* git submodule add https://github.com/neilm-fourjs/gbc_njm.git gbc_njm
* git submodule add https://github.com/neilm-fourjs/gbc_clean.git gbc_clean

If libraries change do:
* git submodule foreach git pull origin master

