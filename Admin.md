# Admin Guide for Creating PMT Build for USB Stick

Steps to create
1. Clone PMT-Portable repo
   - This will create the basic framework for the app
1. Setup Database
   - You should have an empty database named 'eth10' with the Postgis extension enabled from step 1
   1. Backup the database you want to restore from
      - ``pg_dump -U postgres -W -F eth10 > eth_backup.tar``
   2. Restore database
      1. Double click PMT-Portable/data/PostgreSQLPortable.exe to get portable postgres instance up and running.
      2. Inside of the command window that opens from previous step, enter the following command to create database.
      - ``CREATE DATABASE eth10 OWNER postgres;``
      3. Open a new command line terminal and change directory to PMT-Portable/data/App/PgSQL/bin.
      4. Enter following command to restore database
      - ``pg_restore -U postgres -d eth10 eth_backup.tar``
      - If having trouble with restore, make sure backup was performed using PostgreSQL version 9.3
1. Setup API
   1. Clone PMT-API repo, follow readme instructions to install dependencies, (branch: feature/offline) and copy into PMT-Portable/server/root
2. Setup Server
   1. Clone PMT-Viewer (branch: feature/offline), follow read me instructions on installing dependencies and build
       - ``grunt build-offline -theme=ethaim -env=local -offline=true``
   2. Copy PMT-Viewer/build to PMT-Portable/server/root
3. Copy PMT-Portable folder onto USB drive