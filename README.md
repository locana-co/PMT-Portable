PMT-Portable
============

First attempt at a portable portfolio mapping database on a stick. The idea is to run in conjunction with an offline node/webkit server to act as a desktop applicaiton. 

Basic Steps to Reproduce:

1. A portable version of PostgreSQL v9.3 with PostGIS v2.1 enabled: SourceForge has Windows portable installs
	1. https://axiomq.com/blog/backup-and-restore-a-postgresql-database/
	PS D:\PostgreSQL\bin> .\pg_dump -U postgres -W -F t pmt10 > d:\pmt_dump.tar. 
	PS E:\App\PgSQL\bin> .\pg_restore -U postgresql -d pmt10 > d:\pmt_dump.tar
2. A portable web server: 
	http://www.usbwebserver.net/webserver/
3. Run NodeJS/ExpressJS on a USB: 
	1. https://github.com/crazy-max/nodejs-portable
	2. <node ./api.js usb>
4. Send any data element from a Postgres database, through a NodeJS/ExpressJS API to a simple HTML page being served from the portable web server.


Notes:

Solution to target located in server/root

node configured to run directly to an api build in server/root. Opens in shell on launch.