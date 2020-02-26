\echo Use "CREATE EXTENSION postgis_sfcgal" to load this file. \quit
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- 
----
-- PostGIS - Spatial Types for PostgreSQL
-- http://postgis.net
--
-- Copyright (C) 2011 Regina Obe <lr@pcorp.us>
--
-- This is free software; you can redistribute and/or modify it under
-- the terms of the GNU General Public Licence. See the COPYING file.
--
-- Author: Regina Obe <lr@pcorp.us>
--  
-- This is a suite of SQL helper functions for use during a PostGIS extension install/upgrade
-- The functions get uninstalled after the extention install/upgrade process
---------------------------
-- postgis_extension_remove_objects: This function removes objects of a particular class from an extension
-- this is needed because there is no ALTER EXTENSION DROP FUNCTION/AGGREGATE command
-- and we can't CREATE OR REPALCe functions whose signatures have changed and we can drop them if they are part of an extention
-- So we use this to remove it from extension first before we drop
CREATE OR REPLACE FUNCTION postgis_extension_remove_objects(param_extension text, param_type text)
  RETURNS boolean AS
$$
DECLARE 
	var_sql text := '';
	var_r record;
	var_result boolean := false;
	var_class text := '';
	var_is_aggregate boolean := false;
	var_sql_list text := '';
BEGIN
		var_class := CASE WHEN lower(param_type) = 'function' OR lower(param_type) = 'aggregate' THEN 'pg_proc' ELSE '' END; 
		var_is_aggregate := CASE WHEN lower(param_type) = 'aggregate' THEN true ELSE false END;
		var_sql_list := 'SELECT ''ALTER EXTENSION '' || e.extname || '' DROP '' || $3 || '' '' || COALESCE(proc.proname || ''('' || oidvectortypes(proc.proargtypes) || '')'',typ.typname, cd.relname, op.oprname, 
				cs.typname || '' AS '' || ct.typname || '') '', opcname, opfname) || '';'' AS remove_command
		FROM pg_depend As d INNER JOIN pg_extension As e
			ON d.refobjid = e.oid INNER JOIN pg_class As c ON
				c.oid = d.classid
				LEFT JOIN pg_proc AS proc ON proc.oid = d.objid
				LEFT JOIN pg_type AS typ ON typ.oid = d.objid
				LEFT JOIN pg_class As cd ON cd.oid = d.objid
				LEFT JOIN pg_operator As op ON op.oid = d.objid
				LEFT JOIN pg_cast AS ca ON ca.oid = d.objid
				LEFT JOIN pg_type AS cs ON ca.castsource = cs.oid
				LEFT JOIN pg_type AS ct ON ca.casttarget = ct.oid
				LEFT JOIN pg_opclass As oc ON oc.oid = d.objid
				LEFT JOIN pg_opfamily As ofa ON ofa.oid = d.objid
		WHERE d.deptype = ''e'' and e.extname = $1 and c.relname = $2 AND COALESCE(proc.proisagg, false) = $4;';
		FOR var_r IN EXECUTE var_sql_list  USING param_extension, var_class, param_type, var_is_aggregate
        LOOP
            var_sql := var_sql || var_r.remove_command || ';';
        END LOOP;
        IF var_sql > '' THEN
            EXECUTE var_sql;
            var_result := true;
        END IF;
        RETURN var_result;
END;
$$
LANGUAGE plpgsql VOLATILE;

CREATE OR REPLACE FUNCTION postgis_extension_drop_if_exists(param_extension text, param_statement text)
  RETURNS boolean AS
$$
DECLARE 
	var_sql_ext text := 'ALTER EXTENSION ' || quote_ident(param_extension) || ' ' || replace(param_statement, 'IF EXISTS', '');
	var_result boolean := false;
BEGIN
	BEGIN
		EXECUTE var_sql_ext;
		var_result := true;
	EXCEPTION
		WHEN OTHERS THEN
			--this is to allow ignoring if the object does not exist in extension
			var_result := false;
	END;
	RETURN var_result;
END;
$$
LANGUAGE plpgsql VOLATILE;

CREATE OR REPLACE FUNCTION postgis_extension_AddToSearchPath(a_schema_name varchar)
RETURNS text
AS
$$
DECLARE
	var_result text;
	var_cur_search_path text;
BEGIN
	SELECT reset_val INTO var_cur_search_path FROM pg_settings WHERE name = 'search_path';
	IF var_cur_search_path LIKE '%' || quote_ident(a_schema_name) || '%' THEN
		var_result := a_schema_name || ' already in database search_path';
	ELSE
		var_cur_search_path := var_cur_search_path || ', '
                        || quote_ident(a_schema_name); 
		EXECUTE 'ALTER DATABASE ' || quote_ident(current_database())
                              || ' SET search_path = ' || var_cur_search_path;
		var_result := a_schema_name || ' has been added to end of database search_path ';
	END IF;

	EXECUTE 'SET search_path = ' || var_cur_search_path;
  
  RETURN var_result;
END
$$
LANGUAGE 'plpgsql' VOLATILE STRICT;

--
-- UPGRADE SCRIPT TO PostGIS 2.2
--

LOAD '$libdir/postgis-2.2';

CREATE OR REPLACE FUNCTION postgis_major_version_check()
RETURNS text
AS '
DECLARE
	old_scripts text;
	new_scripts text;
	old_maj text;
	new_maj text;
BEGIN
	--
	-- This uses postgis_lib_version() rather then
	-- postgis_scripts_installed() as in 1.0 because
	-- in the 1.0 => 1.1 transition that would result
	-- in an impossible upgrade:
	--
	--   from 0.3.0 to 1.1.0
	--
	-- Next releases will still be ok as
	-- postgis_lib_version() and postgis_scripts_installed()
	-- would both return actual PostGIS release number.
	-- 
	BEGIN
		SELECT into old_scripts postgis_lib_version();
	EXCEPTION WHEN OTHERS THEN
		RAISE DEBUG ''Got %'', SQLERRM;
		SELECT into old_scripts postgis_scripts_installed();
	END;
	SELECT into new_scripts ''2.2'';
	SELECT into old_maj substring(old_scripts from 1 for 2);
	SELECT into new_maj substring(new_scripts from 1 for 2);

	IF old_maj != new_maj THEN
		RAISE EXCEPTION ''Upgrade of postgis from version % to version % requires a dump/reload. See PostGIS manual for instructions'', old_scripts, new_scripts;
	ELSE
		RETURN ''Scripts versions checked for upgrade: ok'';
	END IF;
END
'
LANGUAGE 'plpgsql';

SELECT postgis_major_version_check();

DROP FUNCTION postgis_major_version_check();

CREATE TEMPORARY TABLE _postgis_upgrade_info AS WITH versions AS (
  SELECT '2.2'::text as upgraded,
  postgis_scripts_installed() as installed
) SELECT
  upgraded as scripts_upgraded,
  installed as scripts_installed,
  substring(upgraded from '([0-9]*)\.')::int * 100 +
  substring(upgraded from '[0-9]*\.([0-9]*)\.')::int
    as version_to_num,
  substring(installed from '([0-9]*)\.')::int * 100 +
  substring(installed from '[0-9]*\.([0-9]*)\.')::int
    as version_from_num,
  position('dev' in  installed)::bool
    as version_from_isdev
  FROM versions
;
 
CREATE OR REPLACE FUNCTION postgis_sfcgal_scripts_installed() RETURNS text
	AS $$ SELECT '2.2.3'::text || ' r' || 15172::text AS version $$
	LANGUAGE 'sql' IMMUTABLE;
CREATE OR REPLACE FUNCTION postgis_sfcgal_version() RETURNS text
        AS '$libdir/postgis-2.2'
        LANGUAGE 'c' IMMUTABLE;
CREATE OR REPLACE FUNCTION ST_3DIntersection(geom1 geometry, geom2 geometry)
       RETURNS geometry
       AS '$libdir/postgis-2.2','sfcgal_intersection3D'
       LANGUAGE 'c' IMMUTABLE STRICT
       COST 100;
CREATE OR REPLACE FUNCTION ST_3DDifference(geom1 geometry, geom2 geometry)
       RETURNS geometry
       AS '$libdir/postgis-2.2','sfcgal_difference3D'
       LANGUAGE 'c' IMMUTABLE STRICT
       COST 100;
CREATE OR REPLACE FUNCTION ST_3DUnion(geom1 geometry, geom2 geometry)
       RETURNS geometry
       AS '$libdir/postgis-2.2','sfcgal_union3D'
       LANGUAGE 'c' IMMUTABLE STRICT
       COST 100;
CREATE OR REPLACE FUNCTION ST_Tesselate(geometry)
       RETURNS geometry
       AS '$libdir/postgis-2.2','sfcgal_tesselate'
       LANGUAGE 'c' IMMUTABLE STRICT
       COST 100;
CREATE OR REPLACE FUNCTION ST_3DArea(geometry)
       RETURNS FLOAT8
       AS '$libdir/postgis-2.2','sfcgal_area3D'
       LANGUAGE 'c' IMMUTABLE STRICT
       COST 100;
CREATE OR REPLACE FUNCTION ST_Extrude(geometry, float8, float8, float8)
       RETURNS geometry
       AS '$libdir/postgis-2.2','sfcgal_extrude'
       LANGUAGE 'c' IMMUTABLE STRICT
       COST 100;
CREATE OR REPLACE FUNCTION ST_ForceLHR(geometry)
       RETURNS geometry
       AS '$libdir/postgis-2.2','sfcgal_force_lhr'
       LANGUAGE 'c' IMMUTABLE STRICT
       COST 100;
CREATE OR REPLACE FUNCTION ST_Orientation(geometry)
       RETURNS INT4
       AS '$libdir/postgis-2.2','sfcgal_orientation'
       LANGUAGE 'c' IMMUTABLE STRICT
       COST 100;
CREATE OR REPLACE FUNCTION ST_MinkowskiSum(geometry, geometry)
       RETURNS geometry
       AS '$libdir/postgis-2.2','sfcgal_minkowski_sum'
       LANGUAGE 'c' IMMUTABLE STRICT
       COST 100;
CREATE OR REPLACE FUNCTION ST_StraightSkeleton(geometry)
       RETURNS geometry
       AS '$libdir/postgis-2.2','sfcgal_straight_skeleton'
       LANGUAGE 'c' IMMUTABLE STRICT
       COST 100;
CREATE OR REPLACE FUNCTION ST_ApproximateMedialAxis(geometry)
       RETURNS geometry
       AS '$libdir/postgis-2.2','sfcgal_approximate_medial_axis'
       LANGUAGE 'c'
       IMMUTABLE STRICT COST 100;
CREATE OR REPLACE FUNCTION ST_IsPlanar(geometry)
       RETURNS boolean
       AS '$libdir/postgis-2.2','sfcgal_is_planar'
       LANGUAGE 'c' IMMUTABLE STRICT
       COST 100;
CREATE OR REPLACE FUNCTION ST_Volume(geometry)
       RETURNS FLOAT8
       AS '$libdir/postgis-2.2','sfcgal_volume'
       LANGUAGE 'c' IMMUTABLE STRICT
       COST 100;
CREATE OR REPLACE FUNCTION ST_MakeSolid(geometry)
       RETURNS geometry
       AS '$libdir/postgis-2.2','sfcgal_make_solid'
       LANGUAGE 'c' IMMUTABLE STRICT
       COST 100;
CREATE OR REPLACE FUNCTION ST_IsSolid(geometry)
       RETURNS boolean
       AS '$libdir/postgis-2.2','sfcgal_is_solid'
       LANGUAGE 'c' IMMUTABLE STRICT
       COST 100;
DROP TABLE _postgis_upgrade_info;
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--
--
-- PostGIS - Spatial Types for PostgreSQL
-- http://postgis.net
--
-- Copyright (C) 2011-2012 Sandro Santilli <strk@keybit.net>
-- Copyright (C) 2010-2012 Regina Obe <lr@pcorp.us>
-- Copyright (C) 2009      Paul Ramsey <pramsey@cleverelephant.ca>
--
-- This is free software; you can redistribute and/or modify it under
-- the terms of the GNU General Public Licence. See the COPYING file.
--
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--
-- This file contains drop commands for obsoleted items that need
-- to be dropped _after_ upgrade of old functions.
-- Changes to this file affect postgis_upgrade*.sql script.
--
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

-- First drop old aggregates
DROP AGGREGATE IF EXISTS memgeomunion(geometry);
DROP AGGREGATE IF EXISTS geomunion(geometry);
DROP AGGREGATE IF EXISTS polygonize(geometry); -- Deprecated in 1.2.3, Dropped in 2.0.0
DROP AGGREGATE IF EXISTS collect(geometry); -- Deprecated in 1.2.3, Dropped in 2.0.0
DROP AGGREGATE IF EXISTS st_geomunion(geometry);
DROP AGGREGATE IF EXISTS accum_old(geometry);
DROP AGGREGATE IF EXISTS st_accum_old(geometry);

DROP AGGREGATE IF EXISTS st_astwkb_agg(geometry, integer); -- temporarely introduced before 2.2.0 final
DROP AGGREGATE IF EXISTS st_astwkb_agg(geometry, integer, bigint); -- temporarely introduced before 2.2.0 final
DROP AGGREGATE IF EXISTS st_astwkbagg(geometry, integer); -- temporarely introduced before 2.2.0 final
DROP AGGREGATE IF EXISTS st_astwkbagg(geometry, integer, bigint); -- temporarely introduced before 2.2.0 final
DROP AGGREGATE IF EXISTS st_astwkbagg(geometry, integer, bigint, boolean); -- temporarely introduced before 2.2.0 final
DROP AGGREGATE IF EXISTS st_astwkbagg(geometry, integer, bigint, boolean, boolean); -- temporarely introduced before 2.2.0 final


-- BEGIN Management functions that now have default param for typmod --
DROP FUNCTION IF EXISTS AddGeometryColumn(varchar,varchar,varchar,varchar,integer,varchar,integer);
DROP FUNCTION IF EXISTS AddGeometryColumn(varchar,varchar,varchar,integer,varchar,integer);
DROP FUNCTION IF EXISTS AddGeometryColumn(varchar,varchar,integer,varchar,integer);
DROP FUNCTION IF EXISTS populate_geometry_columns();
DROP FUNCTION IF EXISTS populate_geometry_columns(oid);

-- END Management functions now have default parameter for typmod --
-- Then drop old functions
DROP FUNCTION IF EXISTS box2d_overleft(box2d, box2d);
DROP FUNCTION IF EXISTS box2d_overright(box2d, box2d);
DROP FUNCTION IF EXISTS box2d_left(box2d, box2d);
DROP FUNCTION IF EXISTS box2d_right(box2d, box2d);
DROP FUNCTION IF EXISTS box2d_contain(box2d, box2d);
DROP FUNCTION IF EXISTS box2d_contained(box2d, box2d);
DROP FUNCTION IF EXISTS box2d_overlap(box2d, box2d);
DROP FUNCTION IF EXISTS box2d_same(box2d, box2d);
DROP FUNCTION IF EXISTS box2d_intersects(box2d, box2d);
DROP FUNCTION IF EXISTS st_area(geography); -- this one changed to use default parameters
DROP FUNCTION IF EXISTS ST_AsGeoJson(geometry); -- this one changed to use default args 
DROP FUNCTION IF EXISTS ST_AsGeoJson(geography); -- this one changed to use default args 
DROP FUNCTION IF EXISTS ST_AsGeoJson(geometry,int4); -- this one changed to use default args 
DROP FUNCTION IF EXISTS ST_AsGeoJson(geography,int4); -- this one changed to use default args 
DROP FUNCTION IF EXISTS ST_AsGeoJson(int4,geometry); -- this one changed to use default args
DROP FUNCTION IF EXISTS ST_AsGeoJson(int4,geography); -- this one changed to use default args
DROP FUNCTION IF EXISTS ST_AsGeoJson(int4,geometry,int4); -- this one changed to use default args
DROP FUNCTION IF EXISTS ST_AsGeoJson(int4,geography,int4); -- this one changed to use default args
DROP FUNCTION IF EXISTS st_asgml(geometry); -- changed to use default args
DROP FUNCTION IF EXISTS st_asgml(geometry, int4);  -- changed to use default args
DROP FUNCTION IF EXISTS st_asgml(int4, geometry);  -- changed to use default args
DROP FUNCTION IF EXISTS st_asgml(int4, geometry, int4);  -- changed to use default args
DROP FUNCTION IF EXISTS st_asgml(int4, geometry, int4,int4);  -- changed to use default args
DROP FUNCTION IF EXISTS st_asgml(int4, geometry, int4,int4,text); -- changed to use default args
DROP FUNCTION IF EXISTS st_asgml(geography); -- changed to use default args
DROP FUNCTION IF EXISTS st_asgml(geography, int4);  -- changed to use default args
DROP FUNCTION IF EXISTS st_asgml(int4, geography);  -- changed to use default args
DROP FUNCTION IF EXISTS st_asgml(int4, geography, int4);  -- changed to use default args
DROP FUNCTION IF EXISTS st_asgml(int4, geography, int4,int4);  -- changed to use default args
DROP FUNCTION IF EXISTS st_asgml(int4, geography, int4,int4,text); -- changed to use default args
DROP FUNCTION IF EXISTS _st_asgml(int4, geometry, int4,int4,text); -- changed to use default args
DROP FUNCTION IF EXISTS _st_asgml(int4, geography, int4,int4,text); -- changed to use default args
DROP FUNCTION IF EXISTS ST_AsKML(geometry); -- changed to use default args
DROP FUNCTION IF EXISTS ST_AsKML(geography); -- changed to use default args
DROP FUNCTION IF EXISTS ST_AsKML(int4, geometry, int4); -- changed to use default args
DROP FUNCTION IF EXISTS ST_AsKML(int4, geography, int4); -- changed to use default args
DROP FUNCTION IF EXISTS st_asx3d(geometry); -- this one changed to use default parameters so full function deals with it
DROP FUNCTION IF EXISTS st_asx3d(geometry, int4); -- introduce variant with opts so get rid of other without ops
DROP FUNCTION IF EXISTS st_assvg(geometry); -- changed to use default args
DROP FUNCTION IF EXISTS st_assvg(geometry,int4); -- changed to use default args
DROP FUNCTION IF EXISTS st_assvg(geography); -- changed to use default args
DROP FUNCTION IF EXISTS st_assvg(geography,int4); -- changed to use default args
DROP FUNCTION IF EXISTS st_box2d_overleft(box2d, box2d);
DROP FUNCTION IF EXISTS st_box2d_overright(box2d, box2d);
DROP FUNCTION IF EXISTS st_box2d_left(box2d, box2d);
DROP FUNCTION IF EXISTS st_box2d_right(box2d, box2d);
DROP FUNCTION IF EXISTS st_box2d_contain(box2d, box2d);
DROP FUNCTION IF EXISTS st_box2d_contained(box2d, box2d);
DROP FUNCTION IF EXISTS st_box2d_overlap(box2d, box2d);
DROP FUNCTION IF EXISTS st_box2d_same(box2d, box2d);
DROP FUNCTION IF EXISTS st_box2d_intersects(box2d, box2d);
DROP FUNCTION IF EXISTS st_box2d_in(cstring);
DROP FUNCTION IF EXISTS st_box2d_out(box2d);
DROP FUNCTION IF EXISTS st_box2d(geometry);
DROP FUNCTION IF EXISTS st_box2d(box3d);
DROP FUNCTION IF EXISTS st_box3d(box2d);
DROP FUNCTION IF EXISTS st_box(box3d);
DROP FUNCTION IF EXISTS st_box3d(geometry);
DROP FUNCTION IF EXISTS st_box(geometry);
DROP FUNCTION IF EXISTS ST_ConcaveHull(geometry,float); -- this one changed to use default parameters
DROP FUNCTION IF EXISTS st_text(geometry);
DROP FUNCTION IF EXISTS st_geometry(box2d);
DROP FUNCTION IF EXISTS st_geometry(box3d);
DROP FUNCTION IF EXISTS st_geometry(text);
DROP FUNCTION IF EXISTS st_geometry(bytea);
DROP FUNCTION IF EXISTS st_bytea(geometry);
DROP FUNCTION IF EXISTS st_addbbox(geometry);
DROP FUNCTION IF EXISTS st_dropbbox(geometry); 
DROP FUNCTION IF EXISTS st_hasbbox(geometry); 
DROP FUNCTION IF EXISTS cache_bbox();
DROP FUNCTION IF EXISTS st_cache_bbox();
DROP FUNCTION IF EXISTS ST_GeoHash(geometry); -- changed to use default args
DROP FUNCTION IF EXISTS st_length(geography); -- this one changed to use default parameters
DROP FUNCTION IF EXISTS st_perimeter(geography); -- this one changed to use default parameters
DROP FUNCTION IF EXISTS transform_geometry(geometry,text,text,int);
DROP FUNCTION IF EXISTS collector(geometry, geometry);
DROP FUNCTION IF EXISTS st_collector(geometry, geometry);
DROP FUNCTION IF EXISTS geom_accum (geometry[],geometry);
DROP FUNCTION IF EXISTS st_geom_accum (geometry[],geometry);
DROP FUNCTION IF EXISTS collect_garray (geometry[]);
DROP FUNCTION IF EXISTS st_collect_garray (geometry[]);
DROP FUNCTION IF EXISTS geosnoop(geometry);
DROP FUNCTION IF EXISTS jtsnoop(geometry);
DROP FUNCTION IF EXISTS st_noop(geometry);
DROP FUNCTION IF EXISTS st_max_distance(geometry, geometry);
DROP FUNCTION IF EXISTS  ST_MinimumBoundingCircle(geometry); --changed to use default parameters
-- Drop internals that should never have existed --
DROP FUNCTION IF EXISTS st_geometry_analyze(internal);
DROP FUNCTION IF EXISTS st_geometry_in(cstring);
DROP FUNCTION IF EXISTS st_geometry_out(geometry);
DROP FUNCTION IF EXISTS st_geometry_recv(internal);
DROP FUNCTION IF EXISTS st_geometry_send(geometry);
DROP FUNCTION IF EXISTS st_spheroid_in(cstring);
DROP FUNCTION IF EXISTS st_spheroid_out(spheroid);
DROP FUNCTION IF EXISTS st_geometry_lt(geometry, geometry);
DROP FUNCTION IF EXISTS st_geometry_gt(geometry, geometry);
DROP FUNCTION IF EXISTS st_geometry_ge(geometry, geometry);
DROP FUNCTION IF EXISTS st_geometry_eq(geometry, geometry);
DROP FUNCTION IF EXISTS st_geometry_cmp(geometry, geometry);
DROP FUNCTION IF EXISTS SnapToGrid(geometry, float8, float8);
DROP FUNCTION IF EXISTS st_removerepeatedpoints(geometry);

DROP FUNCTION IF EXISTS geometry_gist_sel_2d (internal, oid, internal, int4);
DROP FUNCTION IF EXISTS geometry_gist_joinsel_2d(internal, oid, internal, smallint);
DROP FUNCTION IF EXISTS geography_gist_selectivity (internal, oid, internal, int4);
DROP FUNCTION IF EXISTS geography_gist_join_selectivity(internal, oid, internal, smallint);

DROP FUNCTION IF EXISTS ST_AsBinary(text); -- deprecated in 2.0
DROP FUNCTION IF EXISTS postgis_uses_stats(); -- deprecated in 2.0

DROP FUNCTION IF EXISTS st_astwkb(geometry,integer,bigint,bool,bool); -- temporarely introduced before 2.2.0 final
DROP FUNCTION IF EXISTS pgis_twkb_accum_transfn(internal,geometry,integer); -- temporarely introduced before 2.2.0 final
DROP FUNCTION IF EXISTS pgis_twkb_accum_transfn(internal,geometry,integer,bigint); -- temporarely introduced before 2.2.0 final
DROP FUNCTION IF EXISTS pgis_twkb_accum_transfn(internal,geometry,integer,bigint,bool); -- temporarely introduced before 2.2.0 final
DROP FUNCTION IF EXISTS pgis_twkb_accum_transfn(internal,geometry,integer,bigint,bool,bool); -- temporarely introduced before 2.2.0 final
DROP FUNCTION IF EXISTS pgis_twkb_accum_finalfn(internal); -- temporarely introduced before 2.2.0 final

DROP FUNCTION IF EXISTS st_seteffectivearea(geometry, double precision); -- temporarely introduced before 2.2.0 final

DROP FUNCTION IF EXISTS geometry_distance_box_nd(geometry,geometry); -- temporarely introduced before 2.2.0 final

-- pgis_abs type was increased from 8 bytes in 2.1 to 16 bytes in 2.2
-- See #3460
UPDATE pg_type SET typlen=16 WHERE typname='pgis_abs' AND typlen=8;

COMMENT ON FUNCTION postgis_sfcgal_version() IS 'Returns the version of SFCGAL in use';
			
COMMENT ON FUNCTION ST_Extrude(geometry, float, float, float) IS 'args: geom, x, y, z - Extrude a surface to a related volume';
			
COMMENT ON FUNCTION ST_StraightSkeleton(geometry) IS 'args: geom - Compute a straight skeleton from a geometry';
			
COMMENT ON FUNCTION ST_ApproximateMedialAxis(geometry) IS 'args: geom - Compute the approximate medial axis of an areal geometry.';
			
COMMENT ON FUNCTION ST_IsPlanar(geometry) IS 'args: geom - Check if a surface is or not planar';
			
COMMENT ON FUNCTION ST_Orientation(geometry) IS 'args: geom - Determine surface orientation';
			
COMMENT ON FUNCTION ST_ForceLHR(geometry) IS 'args: geom - Force LHR orientation';
			
COMMENT ON FUNCTION ST_MinkowskiSum(geometry, geometry) IS 'args: geom1, geom2 - Performs Minkowski sum';
			
COMMENT ON FUNCTION ST_3DIntersection(geometry, geometry) IS 'args: geom1, geom2 - Perform 3D intersection';
			
COMMENT ON FUNCTION ST_3DDifference(geometry, geometry) IS 'args: geom1, geom2 - Perform 3D difference';
			
COMMENT ON FUNCTION ST_3DUnion(geometry, geometry) IS 'args: geom1, geom2 - Perform 3D union';
			
COMMENT ON FUNCTION ST_3DArea(geometry) IS 'args: geom1 - Computes area of 3D surface geometries. Will return 0 for solids.';
			
COMMENT ON FUNCTION ST_Tesselate(geometry) IS 'args: geom - Perform surface Tesselation of a polygon or polyhedralsurface and returns as a TIN or collection of TINS';
			
COMMENT ON FUNCTION ST_Volume(geometry) IS 'args: geom1 - Computes the volume of a 3D solid. If applied to surface (even closed) geometries will return 0.';
			
COMMENT ON FUNCTION ST_MakeSolid(geometry) IS 'args: geom1 - Cast the geometry into a solid. No check is performed. To obtain a valid solid, the input geometry must be a closed Polyhedral Surface or a closed TIN.';
			
COMMENT ON FUNCTION ST_IsSolid(geometry) IS 'args: geom1 - Test if the geometry is a solid. No validity check is performed.';
			-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- 
----
-- PostGIS - Spatial Types for PostgreSQL
-- http://postgis.net
--
-- Copyright (C) 2011 Regina Obe <lr@pcorp.us>
--
-- This is free software; you can redistribute and/or modify it under
-- the terms of the GNU General Public Licence. See the COPYING file.
--
-- Author: Regina Obe <lr@pcorp.us>
--  
-- This drops extension helper functions
-- and should be called at the end of the extension upgrade file
DROP FUNCTION postgis_extension_remove_objects(text, text);
DROP FUNCTION postgis_extension_drop_if_exists(text, text);
DROP FUNCTION postgis_extension_AddToSearchPath(varchar);
