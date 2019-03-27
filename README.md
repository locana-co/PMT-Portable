PMT-Portable
============

First attempt at a portable portfolio mapping database on a stick. The idea is to run in conjunction with an offline node/webkit server to act as a desktop applicaiton. 

Basic Steps to Reproduce:

1. A portable version of PostgreSQL v9.3 with PostGIS v2.1 enabled: SourceForge has Windows portable installs
2. A portable web server: 
	http://www.usbwebserver.net/webserver/
3. Run NodeJS/ExpressJS on a USB: 
	1. https://github.com/crazy-max/nodejs-portable
	2. <node ./api.js usb>
4. Send any data element from a Postgres database, through a NodeJS/ExpressJS API to a simple HTML page being served from the portable web server.


Notes:

Solution to target located in server/root

node configured to run directly to an api build in server/root. Opens in shell on launch.

Instructions:

Doubleclick "StartApplication.bat" and follow the instructions to start prepare the environment for the application. Once all setps are complete, a browser window will open with the application running. 

**All command windows and applications that are opened during the startup process must stay open for the duration of application use. Though they can be minimized. And this does not apply to "StartApplication.bat".**

If for any reason one of the component stops working during application use. A script has been provided for each individual component. Just doubleclick the "Restart"application command file and follow the instrucitons to get everything back up and running. 