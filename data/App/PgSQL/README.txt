To install

1) Copy the files in this folder to you PostgreSQL/9.whatever folder (structure should mirror what you have).

2) 
If you want to spatially enable a database you should use the new extension feature:
SQL approach is connect to database you want to spatially enable. ONly the postgis extension is required
, others are optional if you want the added features


CREATE EXTENSION postgis;
CREATE EXTENSION postgis_topology;
CREATE EXTENSION fuzzystrmatch; -- required for postgis_tiger_geocoder
CREATE EXTENSION postgis_tiger_geocoder;
-- this may or may not be included in your package
-- but if included allows 
-- you to use the alternative pagc_normalize_addresss function of postgis_tiger_geocoder;
CREATE EXTENSION address_standardizer;

-- a sample address standardizer rule set targetted for USA data
CREATE EXTENSION address_standardizer_data_us;


-- You will also be able to do
CREATE EXTENSION postgis_sfcgal;

-- or you can use pgAdmin extension drop down
If you use PgAdmin, you should see these extensions
postgis  (this has geometry/geography/raster support)
postgis_topology
postgis_tiger_geocoder
postgis_sfcgal
address_standardizer
address_standardizer_data_us


which you can install with PgAdmin by selecting from the extensions drop down.



-- Upgrading extension --
To upgrade an extension, it's just as easy. If you are using PgAdmin,
go to the extensions section and the postgis / postgis_topology.
Select the version drop down and bump what you have currently to the latest.

You can also do this with SQL commands:

ALTER EXTENSION postgis UPDATE TO "2.2.0";

repeat for each extension

If you just want to go to latest version, do 
ALTER EXTENSION postgis UPDATE;

repeat for each extension


-- What to do if you get an error that there is no migration path
-- from your current to new --
If you get an error message about not able to migrate from your current version to new, 
because no migration path, you can create a migration path file, you need to do a HARD UPGRADE.

Hard upgrade is pretty simple if your backup was using extensions:
1) Backup your database
2) CREATE a new database and run:
CREATE EXTENSION postgis;
CREATE EXTENSION postgis_sfcgal;
CREATE EXTENSION postgis_topology;
CREATE EXTENSION fuzzystrmatch; -- required for postgis_tiger_geocoder
CREATE EXTENSION postgis_tiger_geocoder;

3) Restore your old database backup onto the new one.
Since the postgis extension is installed, you might get a restore failure notice about postgis and postgis_topology
extensions not restored because they are already present.  You can safely ignore those notices.

