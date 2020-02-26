---------------------------------------------------------------------------
--
-- PostGIS - SFCGAL functions
-- Copyright 2012-2013 Oslandia <infos@oslandia.com>
--
-- This is free software; you can redistribute and/or modify it under
-- the terms of the GNU General Public Licence. See the COPYING file.
--
---------------------------------------------------------------------------


--
-- New SFCGAL functions (meaning prototype not already provided by GEOS)
--












-- INSTALL VERSION: '2.2.3'

BEGIN;

CREATE OR REPLACE FUNCTION postgis_sfcgal_scripts_installed() RETURNS text
	AS $$ SELECT '2.2.3'::text || ' r' || 15172::text AS version $$
	LANGUAGE 'sql' IMMUTABLE;

-- Availability: 2.1.0
CREATE OR REPLACE FUNCTION postgis_sfcgal_version() RETURNS text
        AS '$libdir/postgis-2.2'
        LANGUAGE 'c' IMMUTABLE;
        
-- Availability: 2.1.0
CREATE OR REPLACE FUNCTION ST_3DIntersection(geom1 geometry, geom2 geometry)
       RETURNS geometry
       AS '$libdir/postgis-2.2','sfcgal_intersection3D'
       LANGUAGE 'c' IMMUTABLE STRICT
       COST 100;

-- Availability: 2.2
CREATE OR REPLACE FUNCTION ST_3DDifference(geom1 geometry, geom2 geometry)
       RETURNS geometry
       AS '$libdir/postgis-2.2','sfcgal_difference3D'
       LANGUAGE 'c' IMMUTABLE STRICT
       COST 100;
       
-- Availability: 2.2
CREATE OR REPLACE FUNCTION ST_3DUnion(geom1 geometry, geom2 geometry)
       RETURNS geometry
       AS '$libdir/postgis-2.2','sfcgal_union3D'
       LANGUAGE 'c' IMMUTABLE STRICT
       COST 100;
       
-- Availability: 2.1.0
CREATE OR REPLACE FUNCTION ST_Tesselate(geometry)
       RETURNS geometry
       AS '$libdir/postgis-2.2','sfcgal_tesselate'
       LANGUAGE 'c' IMMUTABLE STRICT
       COST 100;
       
-- Availability: 2.1.0
CREATE OR REPLACE FUNCTION ST_3DArea(geometry)
       RETURNS FLOAT8
       AS '$libdir/postgis-2.2','sfcgal_area3D'
       LANGUAGE 'c' IMMUTABLE STRICT
       COST 100;

-- Availability: 2.1.0       
CREATE OR REPLACE FUNCTION ST_Extrude(geometry, float8, float8, float8)
       RETURNS geometry
       AS '$libdir/postgis-2.2','sfcgal_extrude'
       LANGUAGE 'c' IMMUTABLE STRICT
       COST 100;

-- Availability: 2.1.0       
CREATE OR REPLACE FUNCTION ST_ForceLHR(geometry)
       RETURNS geometry
       AS '$libdir/postgis-2.2','sfcgal_force_lhr'
       LANGUAGE 'c' IMMUTABLE STRICT
       COST 100;
       
-- Availability: 2.1.0
CREATE OR REPLACE FUNCTION ST_Orientation(geometry)
       RETURNS INT4
       AS '$libdir/postgis-2.2','sfcgal_orientation'
       LANGUAGE 'c' IMMUTABLE STRICT
       COST 100;

-- Availability: 2.1.0
CREATE OR REPLACE FUNCTION ST_MinkowskiSum(geometry, geometry)
       RETURNS geometry
       AS '$libdir/postgis-2.2','sfcgal_minkowski_sum'
       LANGUAGE 'c' IMMUTABLE STRICT
       COST 100;

-- Availability: 2.1.0
CREATE OR REPLACE FUNCTION ST_StraightSkeleton(geometry)
       RETURNS geometry
       AS '$libdir/postgis-2.2','sfcgal_straight_skeleton'
       LANGUAGE 'c' IMMUTABLE STRICT
       COST 100;

-- Availability: 2.2.0
CREATE OR REPLACE FUNCTION ST_ApproximateMedialAxis(geometry)
       RETURNS geometry
       AS '$libdir/postgis-2.2','sfcgal_approximate_medial_axis'
       LANGUAGE 'c'
       IMMUTABLE STRICT COST 100;

-- Availability: 2.2.0       
CREATE OR REPLACE FUNCTION ST_IsPlanar(geometry)
       RETURNS boolean
       AS '$libdir/postgis-2.2','sfcgal_is_planar'
       LANGUAGE 'c' IMMUTABLE STRICT
       COST 100;

-- Availability: 2.2
CREATE OR REPLACE FUNCTION ST_Volume(geometry)
       RETURNS FLOAT8
       AS '$libdir/postgis-2.2','sfcgal_volume'
       LANGUAGE 'c' IMMUTABLE STRICT
       COST 100;

-- Availability: 2.2
CREATE OR REPLACE FUNCTION ST_MakeSolid(geometry)
       RETURNS geometry
       AS '$libdir/postgis-2.2','sfcgal_make_solid'
       LANGUAGE 'c' IMMUTABLE STRICT
       COST 100;

-- Availability: 2.2
CREATE OR REPLACE FUNCTION ST_IsSolid(geometry)
       RETURNS boolean
       AS '$libdir/postgis-2.2','sfcgal_is_solid'
       LANGUAGE 'c' IMMUTABLE STRICT
       COST 100;

COMMIT;
