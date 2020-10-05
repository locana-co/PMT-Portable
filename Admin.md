# Admin Guide for Creating PMT Build for USB Stick

Steps to create
1. Clone PMT-Portable repo
   - This will create the basic framework for the app
1. Setup Database
   1. Backup the production database (execute command from the production database server and download file)
      - ``pg_dump -U postgres -Fp eth10 > eth_backup.sql``
   2. You should have an empty database named 'eth10' with the Postgis extension enabled from step 1 but if not:
      1. Double click PMT-Portable/data/PostgreSQLPortable.exe to get portable postgres instance up and running.
      2. Inside of the command window that opens from previous step, enter the following command to create database.
      - ``CREATE DATABASE eth10 OWNER postgres;``
   3. Restore production database to the portable database
      1. Copy eth_backup.sql to the PMT-Portable/data/App/PgSQL/bin.
      2. Double click PMT-Portable/data/PostgreSQLPortable.exe to get portable postgres instance up and running.
      3. Enter following command to restore database
      - ``psql eth10 -f eth_backup.sql``
      - If having trouble with restore, make sure backup was performed using PostgreSQL version 9.4 pg_dump.
1. Setup API
   1. Clone PMT-API repo, follow readme instructions to install dependencies, (branch: feature/offline) and copy into PMT-Portable/server/root
2. Setup Server
   1. Clone PMT-Viewer (branch: feature/offline), follow read me instructions on installing dependencies and build
       - ``grunt build-offline -theme=ethaim -env=local -offline=true``
   2. Copy PMT-Viewer/build to PMT-Portable/server/root
3. Copy PMT-Portable folder onto USB drive
