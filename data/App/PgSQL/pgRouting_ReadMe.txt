## INTRODUCTION
pgRouting is a network routing extension for PostgreSQL that works with PostGIS
This package is for PostGIS 2.1,2.2,2.3
More details can be found at: http://pgrouting.org/

pgRouting extends the PostGIS/PostgreSQL geospatial database to provide geospatial routing and other network analysis functionality.

This 2.3 library contains following features:

New Signatures:

    pgr_TSP
    pgr_aStar

New Functions:

    pgr_eucledianTSP

New Proposed functions

    pgr_dijkstraCostMatrix
    pgr_withPointsCostMatrix
    pgr_maxFlowPushRelabel
    pgr_maxFlowEdmondsKarp
    pgr_maxFlowBoykovKolmogorov
    pgr_maximumCardinalityMatching
    pgr_edgeDisjointPaths
    pgr_contractGraph

Deprecated Signatures

    pgr_tsp - use pgr_TSP or pgr_eucledianTSP instead
    pgr_astar - use pgr_aStar instead

Deprecated functions

    pgr_flip_edges
    pgr_vidsToDmatrix
    pgr_pointsToDMatrix
    pgr_textToPoints



## INSTALL
To install first create a postgresql database using createdb, psql, or pgAdmin
Copy the files from this zip file to same named folders in your PostgreSQL install.

Install PostGIS 2.1 or 2.2 or 2.3 using:
CREATE EXTENSION postgis;

If you have multiple versions of PostGIS and want to force a particular version do:
--For latest stable
CREATE EXTENSION postgis VERSION "2.2.3";

--For latest dev
CREATE EXTENSION postgis VERSION "2.3.0dev";

Then install pgRouting:

CREATE EXTENSION pgrouting;


If updating from old pgrouting use instead
ALTER EXTENSION pgrouting UPDATE;

If you are updating from a development version and UPDATE fails, do:

DROP EXTENSION pgrouting;
CREATE EXTENSION pgrouting;


## FOR THOSE WHO WANT TO COMPILE THEMSELVES 
These were built using
* These binaries are compiled from source
   at git@github.com:pgRouting/pgrouting.git
git clone https://github.com/pgRouting/pgrouting.git
git checkout develop

If building for 32-bit download http://www.bostongis.com/postgisstuff/ming32gcc481.7z
If building for 64-bit download http://www.bostongis.com/postgisstuff/ming64gcc48.7z
Download cmake windows binaries from http://cmake.org/cmake/resources/software.html, extract the zip and copy to
 c:\ming32\projects\cmake-2.8.10.2-win32-x86 (or ming64 folder)
 
To rebuild, you can modify the packaged scripts in tools/
makedependanciesw64.sh  - how to build the dependencies
makepgroutingw32.sh          - how to build under ming32
makepgroutingw64.sh          - how to build under ming64

Once built to get rid of all the debug weight: 
cd build/lib
strip *.dll