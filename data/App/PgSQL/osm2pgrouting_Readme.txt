# Before you can use this tool, you will need
This is compiled using source from https://github.com/pgRouting/osm2pgrouting
and 2.1.0 of expat from - http://sourceforge.net/projects/expat/files/expat/2.1.0/

using mingw-w64 gcc 4.8.3 or 4.8.1

1) A working PostgreSQL, PostGIS 2.1, PostGIS 2.2 and pgRouting 2.1 install with a postgis and pgrouting enabled databases (files such as libpq etc. are required by osm2pgrouting)
2) Copy the osm2pgrouting.exe  to your PostgreSQL bin folder, other dependencies should already be there if you have PostGIS 2.2.
3) If you want separate from your PostgreSQL install use the accompanying sample.bat batch script for loading

You can get already prepared osm files for popular metro areas from https://mapzen.com/metro-extracts/
Extract the osm.bz files with something like 7-Zip.

4) If you don't have a database with PostGIS and pgRouting installed already, create one and run

CREATE EXTENSION postgis;
CREATE EXTENSION pgrouting;

from pgAdmin SQL or psql.

# osm2pgrouting

## How to use

Start the program like this:

Look at sample.bat for usage example which loads up the sample.osm file
