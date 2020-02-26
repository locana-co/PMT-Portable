-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- 
-- PostGIS - Spatial Types for PostgreSQL 
-- http://postgis.net 
-- 
-- This is free software; you can redistribute and/or modify it under 
-- the terms of the GNU General Public Licence. See the COPYING file. 
-- 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- 
-- Generated on: Sat Oct 15 16:17:38 2016
--           by: ../../utils/create_unpackaged.pl
--          for: postgis
--         from: -
-- 
-- Do not edit manually, your changes will be lost.
-- 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- complain if script is sourced in psql
\echo Use "CREATE EXTENSION postgis" to load this file. \quit

-- Register all views.
ALTER EXTENSION postgis ADD VIEW geography_columns;
ALTER EXTENSION postgis ADD VIEW geometry_columns;
ALTER EXTENSION postgis ADD VIEW raster_columns;
ALTER EXTENSION postgis ADD VIEW raster_overviews;
-- Register all tables.
ALTER EXTENSION postgis ADD TABLE spatial_ref_sys;
-- Register all aggregates.
ALTER EXTENSION postgis ADD AGGREGATE ST_Extent (geometry);
ALTER EXTENSION postgis ADD AGGREGATE ST_3DExtent (geometry);
ALTER EXTENSION postgis ADD AGGREGATE ST_MemCollect (geometry);
ALTER EXTENSION postgis ADD AGGREGATE ST_MemUnion (geometry);
ALTER EXTENSION postgis ADD AGGREGATE ST_Accum (geometry);
ALTER EXTENSION postgis ADD AGGREGATE ST_Union (geometry);
ALTER EXTENSION postgis ADD AGGREGATE ST_Collect (geometry);
ALTER EXTENSION postgis ADD AGGREGATE ST_ClusterIntersecting (geometry);
ALTER EXTENSION postgis ADD AGGREGATE ST_ClusterWithin (geometry, float8);
ALTER EXTENSION postgis ADD AGGREGATE ST_Polygonize (geometry);
ALTER EXTENSION postgis ADD AGGREGATE ST_MakeLine (geometry);
ALTER EXTENSION postgis ADD AGGREGATE st_summarystatsagg (raster, integer, boolean, double precision);
ALTER EXTENSION postgis ADD AGGREGATE st_summarystatsagg (raster, boolean, double precision);
ALTER EXTENSION postgis ADD AGGREGATE st_summarystatsagg (raster, int, boolean);
ALTER EXTENSION postgis ADD AGGREGATE st_countagg (raster, integer, boolean, double precision);
ALTER EXTENSION postgis ADD AGGREGATE st_countagg (raster, integer, boolean);
ALTER EXTENSION postgis ADD AGGREGATE st_countagg (raster, boolean);
ALTER EXTENSION postgis ADD AGGREGATE st_samealignment (raster);
ALTER EXTENSION postgis ADD AGGREGATE st_union (raster, unionarg[]);
ALTER EXTENSION postgis ADD AGGREGATE st_union (raster, integer, text);
ALTER EXTENSION postgis ADD AGGREGATE st_union (raster, integer);
ALTER EXTENSION postgis ADD AGGREGATE st_union (raster);
ALTER EXTENSION postgis ADD AGGREGATE st_union (raster, text);
-- Register all operators classes and families.
ALTER EXTENSION postgis ADD OPERATOR CLASS btree_geometry_ops USING btree;
ALTER EXTENSION postgis ADD OPERATOR FAMILY btree_geometry_ops USING btree;
ALTER EXTENSION postgis ADD OPERATOR CLASS gist_geometry_ops_2d USING GIST;
ALTER EXTENSION postgis ADD OPERATOR FAMILY gist_geometry_ops_2d USING GIST;
ALTER EXTENSION postgis ADD OPERATOR CLASS gist_geometry_ops_nd USING GIST;
ALTER EXTENSION postgis ADD OPERATOR FAMILY gist_geometry_ops_nd USING GIST;
ALTER EXTENSION postgis ADD OPERATOR CLASS gist_geography_ops USING GIST;
ALTER EXTENSION postgis ADD OPERATOR FAMILY gist_geography_ops USING GIST;
ALTER EXTENSION postgis ADD OPERATOR CLASS btree_geography_ops USING btree;
ALTER EXTENSION postgis ADD OPERATOR FAMILY btree_geography_ops USING btree;
ALTER EXTENSION postgis ADD OPERATOR CLASS hash_raster_ops USING hash;
ALTER EXTENSION postgis ADD OPERATOR FAMILY hash_raster_ops USING hash;
-- Register all operators.
ALTER EXTENSION postgis ADD OPERATOR <  (geometry,geometry);
ALTER EXTENSION postgis ADD OPERATOR <=  (geometry,geometry);
ALTER EXTENSION postgis ADD OPERATOR =  (geometry,geometry);
ALTER EXTENSION postgis ADD OPERATOR >=  (geometry,geometry);
ALTER EXTENSION postgis ADD OPERATOR >  (geometry,geometry);
ALTER EXTENSION postgis ADD OPERATOR &&  (geometry,geometry);
ALTER EXTENSION postgis ADD OPERATOR ~=  (geometry,geometry);
ALTER EXTENSION postgis ADD OPERATOR <->  (geometry,geometry);
ALTER EXTENSION postgis ADD OPERATOR <#>  (geometry,geometry);
ALTER EXTENSION postgis ADD OPERATOR @  (geometry,geometry);
ALTER EXTENSION postgis ADD OPERATOR ~  (geometry,geometry);
ALTER EXTENSION postgis ADD OPERATOR <<  (geometry,geometry);
ALTER EXTENSION postgis ADD OPERATOR &<  (geometry,geometry);
ALTER EXTENSION postgis ADD OPERATOR <<|  (geometry,geometry);
ALTER EXTENSION postgis ADD OPERATOR &<|  (geometry,geometry);
ALTER EXTENSION postgis ADD OPERATOR &>  (geometry,geometry);
ALTER EXTENSION postgis ADD OPERATOR >>  (geometry,geometry);
ALTER EXTENSION postgis ADD OPERATOR |&>  (geometry,geometry);
ALTER EXTENSION postgis ADD OPERATOR |>>  (geometry,geometry);
ALTER EXTENSION postgis ADD OPERATOR &&&  (geometry,geometry);
ALTER EXTENSION postgis ADD OPERATOR <<->>  (geometry,geometry);
ALTER EXTENSION postgis ADD OPERATOR |=|  (geometry,geometry);
ALTER EXTENSION postgis ADD OPERATOR &&  (geography,geography);
ALTER EXTENSION postgis ADD OPERATOR <->  (geography,geography);
ALTER EXTENSION postgis ADD OPERATOR <  (geography,geography);
ALTER EXTENSION postgis ADD OPERATOR <=  (geography,geography);
ALTER EXTENSION postgis ADD OPERATOR =  (geography,geography);
ALTER EXTENSION postgis ADD OPERATOR >=  (geography,geography);
ALTER EXTENSION postgis ADD OPERATOR >  (geography,geography);
ALTER EXTENSION postgis ADD OPERATOR =  (raster,raster);
ALTER EXTENSION postgis ADD OPERATOR <<  (raster,raster);
ALTER EXTENSION postgis ADD OPERATOR &<  (raster,raster);
ALTER EXTENSION postgis ADD OPERATOR <<|  (raster,raster);
ALTER EXTENSION postgis ADD OPERATOR &<|  (raster,raster);
ALTER EXTENSION postgis ADD OPERATOR &&  (raster,raster);
ALTER EXTENSION postgis ADD OPERATOR &>  (raster,raster);
ALTER EXTENSION postgis ADD OPERATOR >>  (raster,raster);
ALTER EXTENSION postgis ADD OPERATOR |&>  (raster,raster);
ALTER EXTENSION postgis ADD OPERATOR |>>  (raster,raster);
ALTER EXTENSION postgis ADD OPERATOR ~=  (raster,raster);
ALTER EXTENSION postgis ADD OPERATOR @  (raster,raster);
ALTER EXTENSION postgis ADD OPERATOR ~  (raster,raster);
ALTER EXTENSION postgis ADD OPERATOR ~  (raster,geometry);
ALTER EXTENSION postgis ADD OPERATOR @  (raster,geometry);
ALTER EXTENSION postgis ADD OPERATOR &&  (raster,geometry);
ALTER EXTENSION postgis ADD OPERATOR ~  (geometry,raster);
ALTER EXTENSION postgis ADD OPERATOR @  (geometry,raster);
ALTER EXTENSION postgis ADD OPERATOR &&  (geometry,raster);
-- Register all casts.
ALTER EXTENSION postgis ADD CAST (geometry AS geometry);
ALTER EXTENSION postgis ADD CAST (geometry AS point);
ALTER EXTENSION postgis ADD CAST (point AS geometry);
ALTER EXTENSION postgis ADD CAST (geometry AS path);
ALTER EXTENSION postgis ADD CAST (path AS geometry);
ALTER EXTENSION postgis ADD CAST (geometry AS polygon);
ALTER EXTENSION postgis ADD CAST (polygon AS geometry);
ALTER EXTENSION postgis ADD CAST (geometry AS box2d);
ALTER EXTENSION postgis ADD CAST (geometry AS box3d);
ALTER EXTENSION postgis ADD CAST (geometry AS box);
ALTER EXTENSION postgis ADD CAST (box3d AS box2d);
ALTER EXTENSION postgis ADD CAST (box2d AS box3d);
ALTER EXTENSION postgis ADD CAST (box2d AS geometry);
ALTER EXTENSION postgis ADD CAST (box3d AS box);
ALTER EXTENSION postgis ADD CAST (box3d AS geometry);
ALTER EXTENSION postgis ADD CAST (text AS geometry);
ALTER EXTENSION postgis ADD CAST (geometry AS text);
ALTER EXTENSION postgis ADD CAST (bytea AS geometry);
ALTER EXTENSION postgis ADD CAST (geometry AS bytea);
ALTER EXTENSION postgis ADD CAST (geography AS geography);
ALTER EXTENSION postgis ADD CAST (bytea AS geography);
ALTER EXTENSION postgis ADD CAST (geography AS bytea);
ALTER EXTENSION postgis ADD CAST (geometry AS geography);
ALTER EXTENSION postgis ADD CAST (geography AS geometry);
ALTER EXTENSION postgis ADD CAST (raster AS box3d);
ALTER EXTENSION postgis ADD CAST (raster AS geometry);
ALTER EXTENSION postgis ADD CAST (raster AS bytea);
-- Register all functions except 28 needed for type definition.
ALTER EXTENSION postgis ADD FUNCTION _postgis_deprecate (oldname text, newname text, version text);
ALTER EXTENSION postgis ADD FUNCTION geometry (geometry, integer, boolean);
ALTER EXTENSION postgis ADD FUNCTION geometry (point);
ALTER EXTENSION postgis ADD FUNCTION point (geometry);
ALTER EXTENSION postgis ADD FUNCTION geometry (path);
ALTER EXTENSION postgis ADD FUNCTION path (geometry);
ALTER EXTENSION postgis ADD FUNCTION geometry (polygon);
ALTER EXTENSION postgis ADD FUNCTION polygon (geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_X (geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_Y (geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_Z (geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_M (geometry);
ALTER EXTENSION postgis ADD FUNCTION geometry_lt (geom1 geometry, geom2 geometry);
ALTER EXTENSION postgis ADD FUNCTION geometry_le (geom1 geometry, geom2 geometry);
ALTER EXTENSION postgis ADD FUNCTION geometry_gt (geom1 geometry, geom2 geometry);
ALTER EXTENSION postgis ADD FUNCTION geometry_ge (geom1 geometry, geom2 geometry);
ALTER EXTENSION postgis ADD FUNCTION geometry_eq (geom1 geometry, geom2 geometry);
ALTER EXTENSION postgis ADD FUNCTION geometry_cmp (geom1 geometry, geom2 geometry);
ALTER EXTENSION postgis ADD FUNCTION geometry_gist_distance_2d (internal,geometry,int4);
ALTER EXTENSION postgis ADD FUNCTION geometry_gist_consistent_2d (internal,geometry,int4);
ALTER EXTENSION postgis ADD FUNCTION geometry_gist_compress_2d (internal);
ALTER EXTENSION postgis ADD FUNCTION geometry_gist_penalty_2d (internal,internal,internal);
ALTER EXTENSION postgis ADD FUNCTION geometry_gist_picksplit_2d (internal, internal);
ALTER EXTENSION postgis ADD FUNCTION geometry_gist_union_2d (bytea, internal);
ALTER EXTENSION postgis ADD FUNCTION geometry_gist_same_2d (geom1 geometry, geom2 geometry, internal);
ALTER EXTENSION postgis ADD FUNCTION geometry_gist_decompress_2d (internal);
ALTER EXTENSION postgis ADD FUNCTION _postgis_selectivity (tbl regclass, att_name text, geom geometry, mode text );
ALTER EXTENSION postgis ADD FUNCTION _postgis_join_selectivity (regclass, text, regclass, text, text );
ALTER EXTENSION postgis ADD FUNCTION _postgis_stats (tbl regclass, att_name text, text );
ALTER EXTENSION postgis ADD FUNCTION gserialized_gist_sel_2d  (internal, oid, internal, int4);
ALTER EXTENSION postgis ADD FUNCTION gserialized_gist_sel_nd  (internal, oid, internal, int4);
ALTER EXTENSION postgis ADD FUNCTION gserialized_gist_joinsel_2d  (internal, oid, internal, smallint);
ALTER EXTENSION postgis ADD FUNCTION gserialized_gist_joinsel_nd  (internal, oid, internal, smallint);
ALTER EXTENSION postgis ADD FUNCTION geometry_overlaps (geom1 geometry, geom2 geometry);
ALTER EXTENSION postgis ADD FUNCTION geometry_same (geom1 geometry, geom2 geometry);
ALTER EXTENSION postgis ADD FUNCTION geometry_distance_centroid (geom1 geometry, geom2 geometry);
ALTER EXTENSION postgis ADD FUNCTION geometry_distance_box (geom1 geometry, geom2 geometry);
ALTER EXTENSION postgis ADD FUNCTION geometry_contains (geom1 geometry, geom2 geometry);
ALTER EXTENSION postgis ADD FUNCTION geometry_within (geom1 geometry, geom2 geometry);
ALTER EXTENSION postgis ADD FUNCTION geometry_left (geom1 geometry, geom2 geometry);
ALTER EXTENSION postgis ADD FUNCTION geometry_overleft (geom1 geometry, geom2 geometry);
ALTER EXTENSION postgis ADD FUNCTION geometry_below (geom1 geometry, geom2 geometry);
ALTER EXTENSION postgis ADD FUNCTION geometry_overbelow (geom1 geometry, geom2 geometry);
ALTER EXTENSION postgis ADD FUNCTION geometry_overright (geom1 geometry, geom2 geometry);
ALTER EXTENSION postgis ADD FUNCTION geometry_right (geom1 geometry, geom2 geometry);
ALTER EXTENSION postgis ADD FUNCTION geometry_overabove (geom1 geometry, geom2 geometry);
ALTER EXTENSION postgis ADD FUNCTION geometry_above (geom1 geometry, geom2 geometry);
ALTER EXTENSION postgis ADD FUNCTION geometry_gist_consistent_nd (internal,geometry,int4);
ALTER EXTENSION postgis ADD FUNCTION geometry_gist_compress_nd (internal);
ALTER EXTENSION postgis ADD FUNCTION geometry_gist_penalty_nd (internal,internal,internal);
ALTER EXTENSION postgis ADD FUNCTION geometry_gist_picksplit_nd (internal, internal);
ALTER EXTENSION postgis ADD FUNCTION geometry_gist_union_nd (bytea, internal);
ALTER EXTENSION postgis ADD FUNCTION geometry_gist_same_nd (geometry, geometry, internal);
ALTER EXTENSION postgis ADD FUNCTION geometry_gist_decompress_nd (internal);
ALTER EXTENSION postgis ADD FUNCTION geometry_overlaps_nd (geometry, geometry);
ALTER EXTENSION postgis ADD FUNCTION geometry_distance_centroid_nd (geometry,geometry);
ALTER EXTENSION postgis ADD FUNCTION geometry_distance_cpa (geometry, geometry);
ALTER EXTENSION postgis ADD FUNCTION geometry_gist_distance_nd (internal,geometry,int4);
ALTER EXTENSION postgis ADD FUNCTION ST_ShiftLongitude (geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_Shift_Longitude (geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_XMin (box3d);
ALTER EXTENSION postgis ADD FUNCTION ST_YMin (box3d);
ALTER EXTENSION postgis ADD FUNCTION ST_ZMin (box3d);
ALTER EXTENSION postgis ADD FUNCTION ST_XMax (box3d);
ALTER EXTENSION postgis ADD FUNCTION ST_YMax (box3d);
ALTER EXTENSION postgis ADD FUNCTION ST_ZMax (box3d);
ALTER EXTENSION postgis ADD FUNCTION ST_expand (box2d,float8);
ALTER EXTENSION postgis ADD FUNCTION postgis_getbbox (geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_MakeBox2d (geom1 geometry, geom2 geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_EstimatedExtent (text,text,text);
ALTER EXTENSION postgis ADD FUNCTION ST_estimated_extent (text,text,text);
ALTER EXTENSION postgis ADD FUNCTION ST_EstimatedExtent (text,text);
ALTER EXTENSION postgis ADD FUNCTION ST_estimated_extent (text,text);
ALTER EXTENSION postgis ADD FUNCTION ST_FindExtent (text,text,text);
ALTER EXTENSION postgis ADD FUNCTION ST_find_extent (text,text,text);
ALTER EXTENSION postgis ADD FUNCTION ST_FindExtent (text,text);
ALTER EXTENSION postgis ADD FUNCTION ST_find_extent (text,text);
ALTER EXTENSION postgis ADD FUNCTION postgis_addbbox (geometry);
ALTER EXTENSION postgis ADD FUNCTION postgis_dropbbox (geometry);
ALTER EXTENSION postgis ADD FUNCTION postgis_hasbbox (geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_MemSize (geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_mem_size (geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_summary (geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_Npoints (geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_nrings (geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_3DLength (geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_Length2d (geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_Length (geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_LengthSpheroid (geometry, spheroid);
ALTER EXTENSION postgis ADD FUNCTION ST_3DLength_spheroid (geometry, spheroid);
ALTER EXTENSION postgis ADD FUNCTION ST_length_spheroid (geometry, spheroid);
ALTER EXTENSION postgis ADD FUNCTION ST_Length2DSpheroid (geometry, spheroid);
ALTER EXTENSION postgis ADD FUNCTION ST_length2d_spheroid (geometry, spheroid);
ALTER EXTENSION postgis ADD FUNCTION ST_3DPerimeter (geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_perimeter2d (geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_Perimeter (geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_area2d (geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_Area (geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_DistanceSpheroid (geom1 geometry, geom2 geometry,spheroid);
ALTER EXTENSION postgis ADD FUNCTION ST_distance_spheroid (geom1 geometry, geom2 geometry,spheroid);
ALTER EXTENSION postgis ADD FUNCTION ST_Distance (geom1 geometry, geom2 geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_PointInsideCircle (geometry,float8,float8,float8);
ALTER EXTENSION postgis ADD FUNCTION ST_point_inside_circle (geometry,float8,float8,float8);
ALTER EXTENSION postgis ADD FUNCTION ST_azimuth (geom1 geometry, geom2 geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_Force2D (geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_force_2d (geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_Force3DZ (geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_force_3dz (geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_Force3D (geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_force_3d (geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_Force3DM (geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_force_3dm (geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_Force4D (geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_force_4d (geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_ForceCollection (geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_force_collection (geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_CollectionExtract (geometry, integer);
ALTER EXTENSION postgis ADD FUNCTION ST_CollectionHomogenize (geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_Multi (geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_ForceCurve (geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_ForceSFS (geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_ForceSFS (geometry, version text);
ALTER EXTENSION postgis ADD FUNCTION ST_Expand (box3d,float8);
ALTER EXTENSION postgis ADD FUNCTION ST_Expand (geometry,float8);
ALTER EXTENSION postgis ADD FUNCTION ST_Envelope (geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_BoundingDiagonal (geom geometry, fits boolean );
ALTER EXTENSION postgis ADD FUNCTION ST_Reverse (geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_ForceRHR (geometry);
ALTER EXTENSION postgis ADD FUNCTION postgis_noop (geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_zmflag (geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_NDims (geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_AsEWKT (geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_AsTWKB (geom geometry, prec int4 , prec_z int4 , prec_m int4 , with_sizes boolean , with_boxes boolean );
ALTER EXTENSION postgis ADD FUNCTION ST_AsTWKB (geom geometry[], ids bigint[], prec int4 , prec_z int4 , prec_m int4 , with_sizes boolean , with_boxes boolean );
ALTER EXTENSION postgis ADD FUNCTION ST_AsEWKB (geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_AsHEXEWKB (geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_AsHEXEWKB (geometry, text);
ALTER EXTENSION postgis ADD FUNCTION ST_AsEWKB (geometry,text);
ALTER EXTENSION postgis ADD FUNCTION ST_AsLatLonText (geom geometry, tmpl text );
ALTER EXTENSION postgis ADD FUNCTION GeomFromEWKB (bytea);
ALTER EXTENSION postgis ADD FUNCTION ST_GeomFromEWKB (bytea);
ALTER EXTENSION postgis ADD FUNCTION ST_GeomFromTWKB (bytea);
ALTER EXTENSION postgis ADD FUNCTION GeomFromEWKT (text);
ALTER EXTENSION postgis ADD FUNCTION ST_GeomFromEWKT (text);
ALTER EXTENSION postgis ADD FUNCTION postgis_cache_bbox ();
ALTER EXTENSION postgis ADD FUNCTION ST_MakePoint (float8, float8);
ALTER EXTENSION postgis ADD FUNCTION ST_MakePoint (float8, float8, float8);
ALTER EXTENSION postgis ADD FUNCTION ST_MakePoint (float8, float8, float8, float8);
ALTER EXTENSION postgis ADD FUNCTION ST_MakePointM (float8, float8, float8);
ALTER EXTENSION postgis ADD FUNCTION ST_3DMakeBox (geom1 geometry, geom2 geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_MakeLine  (geometry[]);
ALTER EXTENSION postgis ADD FUNCTION ST_LineFromMultiPoint (geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_MakeLine (geom1 geometry, geom2 geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_AddPoint (geom1 geometry, geom2 geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_AddPoint (geom1 geometry, geom2 geometry, integer);
ALTER EXTENSION postgis ADD FUNCTION ST_RemovePoint (geometry, integer);
ALTER EXTENSION postgis ADD FUNCTION ST_SetPoint (geometry, integer, geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_MakeEnvelope (float8, float8, float8, float8, integer );
ALTER EXTENSION postgis ADD FUNCTION ST_MakePolygon (geometry, geometry[]);
ALTER EXTENSION postgis ADD FUNCTION ST_MakePolygon (geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_BuildArea (geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_Polygonize  (geometry[]);
ALTER EXTENSION postgis ADD FUNCTION ST_ClusterIntersecting (geometry[]);
ALTER EXTENSION postgis ADD FUNCTION ST_ClusterWithin (geometry[], float8);
ALTER EXTENSION postgis ADD FUNCTION ST_LineMerge (geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_Affine (geometry,float8,float8,float8,float8,float8,float8,float8,float8,float8,float8,float8,float8);
ALTER EXTENSION postgis ADD FUNCTION ST_Affine (geometry,float8,float8,float8,float8,float8,float8);
ALTER EXTENSION postgis ADD FUNCTION ST_Rotate (geometry,float8);
ALTER EXTENSION postgis ADD FUNCTION ST_Rotate (geometry,float8,float8,float8);
ALTER EXTENSION postgis ADD FUNCTION ST_Rotate (geometry,float8,geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_RotateZ (geometry,float8);
ALTER EXTENSION postgis ADD FUNCTION ST_RotateX (geometry,float8);
ALTER EXTENSION postgis ADD FUNCTION ST_RotateY (geometry,float8);
ALTER EXTENSION postgis ADD FUNCTION ST_Translate (geometry,float8,float8,float8);
ALTER EXTENSION postgis ADD FUNCTION ST_Translate (geometry,float8,float8);
ALTER EXTENSION postgis ADD FUNCTION ST_Scale (geometry,geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_Scale (geometry,float8,float8,float8);
ALTER EXTENSION postgis ADD FUNCTION ST_Scale (geometry,float8,float8);
ALTER EXTENSION postgis ADD FUNCTION ST_Transscale (geometry,float8,float8,float8,float8);
ALTER EXTENSION postgis ADD FUNCTION ST_Dump (geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_DumpRings (geometry);
ALTER EXTENSION postgis ADD FUNCTION _ST_DumpPoints (the_geom geometry, cur_path integer[]);
ALTER EXTENSION postgis ADD FUNCTION ST_DumpPoints (geometry);
ALTER EXTENSION postgis ADD FUNCTION populate_geometry_columns (use_typmod boolean );
ALTER EXTENSION postgis ADD FUNCTION populate_geometry_columns (tbl_oid oid, use_typmod boolean );
ALTER EXTENSION postgis ADD FUNCTION AddGeometryColumn (catalog_name varchar,schema_name varchar,table_name varchar,column_name varchar,new_srid_in integer,new_type varchar,new_dim integer, use_typmod boolean );
ALTER EXTENSION postgis ADD FUNCTION AddGeometryColumn (schema_name varchar,table_name varchar,column_name varchar,new_srid integer,new_type varchar,new_dim integer, use_typmod boolean );
ALTER EXTENSION postgis ADD FUNCTION AddGeometryColumn (table_name varchar,column_name varchar,new_srid integer,new_type varchar,new_dim integer, use_typmod boolean );
ALTER EXTENSION postgis ADD FUNCTION DropGeometryColumn (catalog_name varchar, schema_name varchar,table_name varchar,column_name varchar);
ALTER EXTENSION postgis ADD FUNCTION DropGeometryColumn (schema_name varchar, table_name varchar,column_name varchar);
ALTER EXTENSION postgis ADD FUNCTION DropGeometryColumn (table_name varchar, column_name varchar);
ALTER EXTENSION postgis ADD FUNCTION DropGeometryTable (catalog_name varchar, schema_name varchar, table_name varchar);
ALTER EXTENSION postgis ADD FUNCTION DropGeometryTable (schema_name varchar, table_name varchar);
ALTER EXTENSION postgis ADD FUNCTION DropGeometryTable (table_name varchar);
ALTER EXTENSION postgis ADD FUNCTION UpdateGeometrySRID (catalogn_name varchar,schema_name varchar,table_name varchar,column_name varchar,new_srid_in integer);
ALTER EXTENSION postgis ADD FUNCTION UpdateGeometrySRID (varchar,varchar,varchar,integer);
ALTER EXTENSION postgis ADD FUNCTION UpdateGeometrySRID (varchar,varchar,integer);
ALTER EXTENSION postgis ADD FUNCTION find_srid (varchar,varchar,varchar);
ALTER EXTENSION postgis ADD FUNCTION get_proj4_from_srid (integer);
ALTER EXTENSION postgis ADD FUNCTION postgis_transform_geometry (geometry,text,text,int);
ALTER EXTENSION postgis ADD FUNCTION ST_Transform (geometry,integer);
ALTER EXTENSION postgis ADD FUNCTION postgis_version ();
ALTER EXTENSION postgis ADD FUNCTION postgis_liblwgeom_version ();
ALTER EXTENSION postgis ADD FUNCTION postgis_proj_version ();
ALTER EXTENSION postgis ADD FUNCTION postgis_scripts_installed ();
ALTER EXTENSION postgis ADD FUNCTION postgis_lib_version ();
ALTER EXTENSION postgis ADD FUNCTION postgis_scripts_released ();
ALTER EXTENSION postgis ADD FUNCTION postgis_geos_version ();
ALTER EXTENSION postgis ADD FUNCTION postgis_svn_version ();
ALTER EXTENSION postgis ADD FUNCTION postgis_libxml_version ();
ALTER EXTENSION postgis ADD FUNCTION postgis_scripts_build_date ();
ALTER EXTENSION postgis ADD FUNCTION postgis_lib_build_date ();
ALTER EXTENSION postgis ADD FUNCTION postgis_full_version ();
ALTER EXTENSION postgis ADD FUNCTION box2d (geometry);
ALTER EXTENSION postgis ADD FUNCTION box3d (geometry);
ALTER EXTENSION postgis ADD FUNCTION box (geometry);
ALTER EXTENSION postgis ADD FUNCTION box2d (box3d);
ALTER EXTENSION postgis ADD FUNCTION box3d (box2d);
ALTER EXTENSION postgis ADD FUNCTION box (box3d);
ALTER EXTENSION postgis ADD FUNCTION text (geometry);
ALTER EXTENSION postgis ADD FUNCTION box3dtobox (box3d);
ALTER EXTENSION postgis ADD FUNCTION geometry (box2d);
ALTER EXTENSION postgis ADD FUNCTION geometry (box3d);
ALTER EXTENSION postgis ADD FUNCTION geometry (text);
ALTER EXTENSION postgis ADD FUNCTION geometry (bytea);
ALTER EXTENSION postgis ADD FUNCTION bytea (geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_Simplify (geometry, float8);
ALTER EXTENSION postgis ADD FUNCTION ST_Simplify (geometry, float8, boolean);
ALTER EXTENSION postgis ADD FUNCTION ST_SimplifyVW (geometry,  float8);
ALTER EXTENSION postgis ADD FUNCTION ST_SetEffectiveArea (geometry,  float8 , integer );
ALTER EXTENSION postgis ADD FUNCTION ST_SnapToGrid (geometry, float8, float8, float8, float8);
ALTER EXTENSION postgis ADD FUNCTION ST_SnapToGrid (geometry, float8, float8);
ALTER EXTENSION postgis ADD FUNCTION ST_SnapToGrid (geometry, float8);
ALTER EXTENSION postgis ADD FUNCTION ST_SnapToGrid (geom1 geometry, geom2 geometry, float8, float8, float8, float8);
ALTER EXTENSION postgis ADD FUNCTION ST_Segmentize (geometry, float8);
ALTER EXTENSION postgis ADD FUNCTION ST_LineInterpolatePoint (geometry, float8);
ALTER EXTENSION postgis ADD FUNCTION ST_line_interpolate_point (geometry, float8);
ALTER EXTENSION postgis ADD FUNCTION ST_LineSubstring (geometry, float8, float8);
ALTER EXTENSION postgis ADD FUNCTION ST_line_substring (geometry, float8, float8);
ALTER EXTENSION postgis ADD FUNCTION ST_LineLocatePoint (geom1 geometry, geom2 geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_line_locate_point (geom1 geometry, geom2 geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_locate_between_measures (geometry, float8, float8);
ALTER EXTENSION postgis ADD FUNCTION ST_locate_along_measure (geometry, float8);
ALTER EXTENSION postgis ADD FUNCTION ST_AddMeasure (geometry, float8, float8);
ALTER EXTENSION postgis ADD FUNCTION ST_ClosestPointOfApproach (geometry, geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_DistanceCPA (geometry, geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_CPAWithin (geometry, geometry, float8);
ALTER EXTENSION postgis ADD FUNCTION ST_IsValidTrajectory (geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_Intersection (geom1 geometry, geom2 geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_Buffer (geometry,float8);
ALTER EXTENSION postgis ADD FUNCTION _ST_Buffer (geometry,float8,cstring);
ALTER EXTENSION postgis ADD FUNCTION ST_Buffer (geometry,float8,integer);
ALTER EXTENSION postgis ADD FUNCTION ST_Buffer (geometry,float8,text);
ALTER EXTENSION postgis ADD FUNCTION ST_OffsetCurve (line geometry, distance float8, params text );
ALTER EXTENSION postgis ADD FUNCTION ST_ConvexHull (geometry);
ALTER EXTENSION postgis ADD FUNCTION _ST_LineCrossingDirection (geom1 geometry, geom2 geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_LineCrossingDirection (geom1 geometry, geom2 geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_SimplifyPreserveTopology (geometry, float8);
ALTER EXTENSION postgis ADD FUNCTION ST_IsValidReason (geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_IsValidDetail (geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_IsValidDetail (geometry, int4);
ALTER EXTENSION postgis ADD FUNCTION ST_IsValidReason (geometry, int4);
ALTER EXTENSION postgis ADD FUNCTION ST_IsValid (geometry, int4);
ALTER EXTENSION postgis ADD FUNCTION ST_HausdorffDistance (geom1 geometry, geom2 geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_HausdorffDistance (geom1 geometry, geom2 geometry, float8);
ALTER EXTENSION postgis ADD FUNCTION ST_Difference (geom1 geometry, geom2 geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_Boundary (geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_SymDifference (geom1 geometry, geom2 geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_symmetricdifference (geom1 geometry, geom2 geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_Union (geom1 geometry, geom2 geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_UnaryUnion (geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_RemoveRepeatedPoints (geom geometry, tolerance float8 );
ALTER EXTENSION postgis ADD FUNCTION ST_ClipByBox2d (geom geometry, box box2d);
ALTER EXTENSION postgis ADD FUNCTION ST_Subdivide (geom geometry, maxvertices integer );
ALTER EXTENSION postgis ADD FUNCTION ST_MakeValid (geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_CleanGeometry (geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_Split (geom1 geometry, geom2 geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_SharedPaths (geom1 geometry, geom2 geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_Snap (geom1 geometry, geom2 geometry, float8);
ALTER EXTENSION postgis ADD FUNCTION ST_RelateMatch (text, text);
ALTER EXTENSION postgis ADD FUNCTION ST_Node (g geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_DelaunayTriangles (g1 geometry, tolerance float8 , flags int4 );
ALTER EXTENSION postgis ADD FUNCTION ST_CombineBBox (box3d,geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_Combine_BBox (box3d,geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_CombineBbox (box2d,geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_Combine_BBox (box2d,geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_Collect (geom1 geometry, geom2 geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_Collect (geometry[]);
ALTER EXTENSION postgis ADD FUNCTION pgis_geometry_accum_transfn (pgis_abs, geometry);
ALTER EXTENSION postgis ADD FUNCTION pgis_geometry_accum_transfn (pgis_abs, geometry, float8);
ALTER EXTENSION postgis ADD FUNCTION pgis_geometry_accum_finalfn (pgis_abs);
ALTER EXTENSION postgis ADD FUNCTION pgis_geometry_union_finalfn (pgis_abs);
ALTER EXTENSION postgis ADD FUNCTION pgis_geometry_collect_finalfn (pgis_abs);
ALTER EXTENSION postgis ADD FUNCTION pgis_geometry_polygonize_finalfn (pgis_abs);
ALTER EXTENSION postgis ADD FUNCTION pgis_geometry_clusterintersecting_finalfn (pgis_abs);
ALTER EXTENSION postgis ADD FUNCTION pgis_geometry_clusterwithin_finalfn (pgis_abs);
ALTER EXTENSION postgis ADD FUNCTION pgis_geometry_makeline_finalfn (pgis_abs);
ALTER EXTENSION postgis ADD FUNCTION ST_Union  (geometry[]);
ALTER EXTENSION postgis ADD FUNCTION ST_Relate (geom1 geometry, geom2 geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_Relate (geom1 geometry, geom2 geometry, int4);
ALTER EXTENSION postgis ADD FUNCTION ST_Relate (geom1 geometry, geom2 geometry,text);
ALTER EXTENSION postgis ADD FUNCTION ST_Disjoint (geom1 geometry, geom2 geometry);
ALTER EXTENSION postgis ADD FUNCTION _ST_Touches (geom1 geometry, geom2 geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_Touches (geom1 geometry, geom2 geometry);
ALTER EXTENSION postgis ADD FUNCTION _ST_DWithin (geom1 geometry, geom2 geometry,float8);
ALTER EXTENSION postgis ADD FUNCTION ST_DWithin (geom1 geometry, geom2 geometry, float8);
ALTER EXTENSION postgis ADD FUNCTION _ST_Intersects (geom1 geometry, geom2 geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_Intersects (geom1 geometry, geom2 geometry);
ALTER EXTENSION postgis ADD FUNCTION _ST_Crosses (geom1 geometry, geom2 geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_Crosses (geom1 geometry, geom2 geometry);
ALTER EXTENSION postgis ADD FUNCTION _ST_Contains (geom1 geometry, geom2 geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_Contains (geom1 geometry, geom2 geometry);
ALTER EXTENSION postgis ADD FUNCTION _ST_CoveredBy (geom1 geometry, geom2 geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_CoveredBy (geom1 geometry, geom2 geometry);
ALTER EXTENSION postgis ADD FUNCTION _ST_Covers (geom1 geometry, geom2 geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_Covers (geom1 geometry, geom2 geometry);
ALTER EXTENSION postgis ADD FUNCTION _ST_ContainsProperly (geom1 geometry, geom2 geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_ContainsProperly (geom1 geometry, geom2 geometry);
ALTER EXTENSION postgis ADD FUNCTION _ST_Overlaps (geom1 geometry, geom2 geometry);
ALTER EXTENSION postgis ADD FUNCTION _ST_Within (geom1 geometry, geom2 geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_Within (geom1 geometry, geom2 geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_Overlaps (geom1 geometry, geom2 geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_IsValid (geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_Centroid (geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_IsRing (geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_PointOnSurface (geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_IsSimple (geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_IsCollection (geometry);
ALTER EXTENSION postgis ADD FUNCTION _ST_Equals (geom1 geometry, geom2 geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_Equals (geom1 geometry, geom2 geometry);
ALTER EXTENSION postgis ADD FUNCTION Equals (geom1 geometry, geom2 geometry);
ALTER EXTENSION postgis ADD FUNCTION _ST_GeomFromGML (text, int4);
ALTER EXTENSION postgis ADD FUNCTION ST_GeomFromGML (text, int4);
ALTER EXTENSION postgis ADD FUNCTION ST_GeomFromGML (text);
ALTER EXTENSION postgis ADD FUNCTION ST_GMLToSQL (text);
ALTER EXTENSION postgis ADD FUNCTION ST_GMLToSQL (text, int4);
ALTER EXTENSION postgis ADD FUNCTION ST_GeomFromKML (text);
ALTER EXTENSION postgis ADD FUNCTION ST_GeomFromGeoJson (text);
ALTER EXTENSION postgis ADD FUNCTION postgis_libjson_version ();
ALTER EXTENSION postgis ADD FUNCTION ST_LineFromEncodedPolyline (text, int4 );
ALTER EXTENSION postgis ADD FUNCTION ST_AsEncodedPolyline (geom geometry, int4 );
ALTER EXTENSION postgis ADD FUNCTION ST_AsSVG (geom geometry,rel int4 ,maxdecimaldigits int4 );
ALTER EXTENSION postgis ADD FUNCTION _ST_AsGML (int4, geometry, int4, int4, text, text);
ALTER EXTENSION postgis ADD FUNCTION ST_AsGML (geom geometry, maxdecimaldigits int4 , options int4 );
ALTER EXTENSION postgis ADD FUNCTION ST_AsGML (version int4, geom geometry, maxdecimaldigits int4 , options int4 , nprefix text , id text );
ALTER EXTENSION postgis ADD FUNCTION _ST_AsKML (int4,geometry, int4, text);
ALTER EXTENSION postgis ADD FUNCTION ST_AsKML (geom geometry, maxdecimaldigits int4 );
ALTER EXTENSION postgis ADD FUNCTION ST_AsKML (version int4, geom geometry, maxdecimaldigits int4 , nprefix text );
ALTER EXTENSION postgis ADD FUNCTION ST_AsGeoJson (geom geometry, maxdecimaldigits int4 , options int4 );
ALTER EXTENSION postgis ADD FUNCTION _ST_AsGeoJson (int4, geometry, int4, int4);
ALTER EXTENSION postgis ADD FUNCTION ST_AsGeoJson (gj_version int4, geom geometry, maxdecimaldigits int4 , options int4 );
ALTER EXTENSION postgis ADD FUNCTION ST_GeoHash (geom geometry, maxchars int4 );
ALTER EXTENSION postgis ADD FUNCTION ST_Box2dFromGeoHash (text, int4 );
ALTER EXTENSION postgis ADD FUNCTION ST_PointFromGeoHash (text, int4 );
ALTER EXTENSION postgis ADD FUNCTION ST_GeomFromGeoHash (text, int4 );
ALTER EXTENSION postgis ADD FUNCTION ST_NumPoints (geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_NumGeometries (geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_GeometryN (geometry,integer);
ALTER EXTENSION postgis ADD FUNCTION ST_Dimension (geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_ExteriorRing (geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_NumInteriorRings (geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_NumInteriorRing (geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_InteriorRingN (geometry,integer);
ALTER EXTENSION postgis ADD FUNCTION GeometryType (geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_GeometryType (geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_PointN (geometry,integer);
ALTER EXTENSION postgis ADD FUNCTION ST_NumPatches (geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_PatchN (geometry, integer);
ALTER EXTENSION postgis ADD FUNCTION ST_StartPoint (geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_EndPoint (geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_IsClosed (geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_IsEmpty (geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_SRID (geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_SetSRID (geometry,int4);
ALTER EXTENSION postgis ADD FUNCTION ST_AsBinary (geometry,text);
ALTER EXTENSION postgis ADD FUNCTION ST_AsBinary (geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_AsText (geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_GeometryFromText (text);
ALTER EXTENSION postgis ADD FUNCTION ST_GeometryFromText (text, int4);
ALTER EXTENSION postgis ADD FUNCTION ST_GeomFromText (text);
ALTER EXTENSION postgis ADD FUNCTION ST_GeomFromText (text, int4);
ALTER EXTENSION postgis ADD FUNCTION ST_WKTToSQL (text);
ALTER EXTENSION postgis ADD FUNCTION ST_PointFromText (text);
ALTER EXTENSION postgis ADD FUNCTION ST_PointFromText (text, int4);
ALTER EXTENSION postgis ADD FUNCTION ST_LineFromText (text);
ALTER EXTENSION postgis ADD FUNCTION ST_LineFromText (text, int4);
ALTER EXTENSION postgis ADD FUNCTION ST_PolyFromText (text);
ALTER EXTENSION postgis ADD FUNCTION ST_PolyFromText (text, int4);
ALTER EXTENSION postgis ADD FUNCTION ST_PolygonFromText (text, int4);
ALTER EXTENSION postgis ADD FUNCTION ST_PolygonFromText (text);
ALTER EXTENSION postgis ADD FUNCTION ST_MLineFromText (text, int4);
ALTER EXTENSION postgis ADD FUNCTION ST_MLineFromText (text);
ALTER EXTENSION postgis ADD FUNCTION ST_MultiLineStringFromText (text);
ALTER EXTENSION postgis ADD FUNCTION ST_MultiLineStringFromText (text, int4);
ALTER EXTENSION postgis ADD FUNCTION ST_MPointFromText (text, int4);
ALTER EXTENSION postgis ADD FUNCTION ST_MPointFromText (text);
ALTER EXTENSION postgis ADD FUNCTION ST_MultiPointFromText (text);
ALTER EXTENSION postgis ADD FUNCTION ST_MPolyFromText (text, int4);
ALTER EXTENSION postgis ADD FUNCTION ST_MPolyFromText (text);
ALTER EXTENSION postgis ADD FUNCTION ST_MultiPolygonFromText (text, int4);
ALTER EXTENSION postgis ADD FUNCTION ST_MultiPolygonFromText (text);
ALTER EXTENSION postgis ADD FUNCTION ST_GeomCollFromText (text, int4);
ALTER EXTENSION postgis ADD FUNCTION ST_GeomCollFromText (text);
ALTER EXTENSION postgis ADD FUNCTION ST_GeomFromWKB (bytea);
ALTER EXTENSION postgis ADD FUNCTION ST_GeomFromWKB (bytea, int);
ALTER EXTENSION postgis ADD FUNCTION ST_PointFromWKB (bytea, int);
ALTER EXTENSION postgis ADD FUNCTION ST_PointFromWKB (bytea);
ALTER EXTENSION postgis ADD FUNCTION ST_LineFromWKB (bytea, int);
ALTER EXTENSION postgis ADD FUNCTION ST_LineFromWKB (bytea);
ALTER EXTENSION postgis ADD FUNCTION ST_LinestringFromWKB (bytea, int);
ALTER EXTENSION postgis ADD FUNCTION ST_LinestringFromWKB (bytea);
ALTER EXTENSION postgis ADD FUNCTION ST_PolyFromWKB (bytea, int);
ALTER EXTENSION postgis ADD FUNCTION ST_PolyFromWKB (bytea);
ALTER EXTENSION postgis ADD FUNCTION ST_PolygonFromWKB (bytea, int);
ALTER EXTENSION postgis ADD FUNCTION ST_PolygonFromWKB (bytea);
ALTER EXTENSION postgis ADD FUNCTION ST_MPointFromWKB (bytea, int);
ALTER EXTENSION postgis ADD FUNCTION ST_MPointFromWKB (bytea);
ALTER EXTENSION postgis ADD FUNCTION ST_MultiPointFromWKB (bytea, int);
ALTER EXTENSION postgis ADD FUNCTION ST_MultiPointFromWKB (bytea);
ALTER EXTENSION postgis ADD FUNCTION ST_MultiLineFromWKB (bytea);
ALTER EXTENSION postgis ADD FUNCTION ST_MLineFromWKB (bytea, int);
ALTER EXTENSION postgis ADD FUNCTION ST_MLineFromWKB (bytea);
ALTER EXTENSION postgis ADD FUNCTION ST_MPolyFromWKB (bytea, int);
ALTER EXTENSION postgis ADD FUNCTION ST_MPolyFromWKB (bytea);
ALTER EXTENSION postgis ADD FUNCTION ST_MultiPolyFromWKB (bytea, int);
ALTER EXTENSION postgis ADD FUNCTION ST_MultiPolyFromWKB (bytea);
ALTER EXTENSION postgis ADD FUNCTION ST_GeomCollFromWKB (bytea, int);
ALTER EXTENSION postgis ADD FUNCTION ST_GeomCollFromWKB (bytea);
ALTER EXTENSION postgis ADD FUNCTION _ST_MaxDistance (geom1 geometry, geom2 geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_MaxDistance (geom1 geometry, geom2 geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_ClosestPoint (geom1 geometry, geom2 geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_ShortestLine (geom1 geometry, geom2 geometry);
ALTER EXTENSION postgis ADD FUNCTION _ST_LongestLine (geom1 geometry, geom2 geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_LongestLine (geom1 geometry, geom2 geometry);
ALTER EXTENSION postgis ADD FUNCTION _ST_DFullyWithin (geom1 geometry, geom2 geometry,float8);
ALTER EXTENSION postgis ADD FUNCTION ST_DFullyWithin (geom1 geometry, geom2 geometry, float8);
ALTER EXTENSION postgis ADD FUNCTION ST_SwapOrdinates (geom geometry, ords cstring);
ALTER EXTENSION postgis ADD FUNCTION ST_FlipCoordinates (geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_BdPolyFromText (text, integer);
ALTER EXTENSION postgis ADD FUNCTION ST_BdMPolyFromText (text, integer);
ALTER EXTENSION postgis ADD FUNCTION UnlockRows (text);
ALTER EXTENSION postgis ADD FUNCTION LockRow (text, text, text, text, timestamp);
ALTER EXTENSION postgis ADD FUNCTION LockRow (text, text, text, text);
ALTER EXTENSION postgis ADD FUNCTION LockRow (text, text, text);
ALTER EXTENSION postgis ADD FUNCTION LockRow (text, text, text, timestamp);
ALTER EXTENSION postgis ADD FUNCTION AddAuth (text);
ALTER EXTENSION postgis ADD FUNCTION CheckAuth (text, text, text);
ALTER EXTENSION postgis ADD FUNCTION CheckAuth (text, text);
ALTER EXTENSION postgis ADD FUNCTION CheckAuthTrigger ();
ALTER EXTENSION postgis ADD FUNCTION GetTransactionID ();
ALTER EXTENSION postgis ADD FUNCTION EnableLongTransactions ();
ALTER EXTENSION postgis ADD FUNCTION LongTransactionsEnabled ();
ALTER EXTENSION postgis ADD FUNCTION DisableLongTransactions ();
ALTER EXTENSION postgis ADD FUNCTION geography (geography, integer, boolean);
ALTER EXTENSION postgis ADD FUNCTION geography (bytea);
ALTER EXTENSION postgis ADD FUNCTION bytea (geography);
ALTER EXTENSION postgis ADD FUNCTION ST_AsText (geography);
ALTER EXTENSION postgis ADD FUNCTION ST_AsText (text);
ALTER EXTENSION postgis ADD FUNCTION ST_GeographyFromText (text);
ALTER EXTENSION postgis ADD FUNCTION ST_GeogFromText (text);
ALTER EXTENSION postgis ADD FUNCTION ST_GeogFromWKB (bytea);
ALTER EXTENSION postgis ADD FUNCTION postgis_typmod_dims (integer);
ALTER EXTENSION postgis ADD FUNCTION postgis_typmod_srid (integer);
ALTER EXTENSION postgis ADD FUNCTION postgis_typmod_type (integer);
ALTER EXTENSION postgis ADD FUNCTION geography (geometry);
ALTER EXTENSION postgis ADD FUNCTION geometry (geography);
ALTER EXTENSION postgis ADD FUNCTION geography_gist_consistent (internal,geography,int4);
ALTER EXTENSION postgis ADD FUNCTION geography_gist_compress (internal);
ALTER EXTENSION postgis ADD FUNCTION geography_gist_penalty (internal,internal,internal);
ALTER EXTENSION postgis ADD FUNCTION geography_gist_picksplit (internal, internal);
ALTER EXTENSION postgis ADD FUNCTION geography_gist_union (bytea, internal);
ALTER EXTENSION postgis ADD FUNCTION geography_gist_same (box2d, box2d, internal);
ALTER EXTENSION postgis ADD FUNCTION geography_gist_decompress (internal);
ALTER EXTENSION postgis ADD FUNCTION geography_overlaps (geography, geography);
ALTER EXTENSION postgis ADD FUNCTION geography_distance_knn (geography, geography);
ALTER EXTENSION postgis ADD FUNCTION geography_gist_distance (internal, geography, int4);
ALTER EXTENSION postgis ADD FUNCTION geography_lt (geography, geography);
ALTER EXTENSION postgis ADD FUNCTION geography_le (geography, geography);
ALTER EXTENSION postgis ADD FUNCTION geography_gt (geography, geography);
ALTER EXTENSION postgis ADD FUNCTION geography_ge (geography, geography);
ALTER EXTENSION postgis ADD FUNCTION geography_eq (geography, geography);
ALTER EXTENSION postgis ADD FUNCTION geography_cmp (geography, geography);
ALTER EXTENSION postgis ADD FUNCTION ST_AsSVG (geog geography,rel int4 ,maxdecimaldigits int4 );
ALTER EXTENSION postgis ADD FUNCTION ST_AsSVG (text);
ALTER EXTENSION postgis ADD FUNCTION _ST_AsGML (int4, geography, int4, int4, text, text);
ALTER EXTENSION postgis ADD FUNCTION ST_AsGML (text);
ALTER EXTENSION postgis ADD FUNCTION ST_AsGML (geog geography, maxdecimaldigits int4 , options int4 );
ALTER EXTENSION postgis ADD FUNCTION ST_AsGML (version int4, geog geography, maxdecimaldigits int4 , options int4 , nprefix text , id text );
ALTER EXTENSION postgis ADD FUNCTION _ST_AsKML (int4, geography, int4, text);
ALTER EXTENSION postgis ADD FUNCTION ST_AsKML (geog geography, maxdecimaldigits int4 );
ALTER EXTENSION postgis ADD FUNCTION ST_AsKML (text);
ALTER EXTENSION postgis ADD FUNCTION ST_AsKML (version int4, geog geography, maxdecimaldigits int4 , nprefix text );
ALTER EXTENSION postgis ADD FUNCTION _ST_AsGeoJson (int4, geography, int4, int4);
ALTER EXTENSION postgis ADD FUNCTION ST_AsGeoJson (text);
ALTER EXTENSION postgis ADD FUNCTION ST_AsGeoJson (geog geography, maxdecimaldigits int4 , options int4 );
ALTER EXTENSION postgis ADD FUNCTION ST_AsGeoJson (gj_version int4, geog geography, maxdecimaldigits int4 , options int4 );
ALTER EXTENSION postgis ADD FUNCTION _ST_Distance (geography, geography, float8, boolean);
ALTER EXTENSION postgis ADD FUNCTION _ST_DWithin (geography, geography, float8, boolean);
ALTER EXTENSION postgis ADD FUNCTION ST_Distance (geography, geography, boolean);
ALTER EXTENSION postgis ADD FUNCTION ST_Distance (geography, geography);
ALTER EXTENSION postgis ADD FUNCTION ST_Distance (text, text);
ALTER EXTENSION postgis ADD FUNCTION _ST_Expand (geography, float8);
ALTER EXTENSION postgis ADD FUNCTION ST_DWithin (geography, geography, float8, boolean);
ALTER EXTENSION postgis ADD FUNCTION ST_DWithin (geography, geography, float8);
ALTER EXTENSION postgis ADD FUNCTION ST_DWithin (text, text, float8);
ALTER EXTENSION postgis ADD FUNCTION _ST_DistanceUnCached (geography, geography, float8, boolean);
ALTER EXTENSION postgis ADD FUNCTION _ST_DistanceUnCached (geography, geography, boolean);
ALTER EXTENSION postgis ADD FUNCTION _ST_DistanceUnCached (geography, geography);
ALTER EXTENSION postgis ADD FUNCTION _ST_DistanceTree (geography, geography, float8, boolean);
ALTER EXTENSION postgis ADD FUNCTION _ST_DistanceTree (geography, geography);
ALTER EXTENSION postgis ADD FUNCTION _ST_DWithinUnCached (geography, geography, float8, boolean);
ALTER EXTENSION postgis ADD FUNCTION _ST_DWithinUnCached (geography, geography, float8);
ALTER EXTENSION postgis ADD FUNCTION ST_Area (geog geography, use_spheroid boolean );
ALTER EXTENSION postgis ADD FUNCTION ST_Area (text);
ALTER EXTENSION postgis ADD FUNCTION ST_Length (geog geography, use_spheroid boolean );
ALTER EXTENSION postgis ADD FUNCTION ST_Length (text);
ALTER EXTENSION postgis ADD FUNCTION ST_Project (geog geography, distance float8, azimuth float8);
ALTER EXTENSION postgis ADD FUNCTION ST_Azimuth (geog1 geography, geog2 geography);
ALTER EXTENSION postgis ADD FUNCTION ST_Perimeter (geog geography, use_spheroid boolean );
ALTER EXTENSION postgis ADD FUNCTION _ST_PointOutside (geography);
ALTER EXTENSION postgis ADD FUNCTION _ST_Covers (geography, geography);
ALTER EXTENSION postgis ADD FUNCTION ST_Covers (geography, geography);
ALTER EXTENSION postgis ADD FUNCTION ST_Covers (text, text);
ALTER EXTENSION postgis ADD FUNCTION ST_CoveredBy (geography, geography);
ALTER EXTENSION postgis ADD FUNCTION ST_CoveredBy (text, text);
ALTER EXTENSION postgis ADD FUNCTION ST_Segmentize (geog geography, max_segment_length float8);
ALTER EXTENSION postgis ADD FUNCTION ST_Intersects (geography, geography);
ALTER EXTENSION postgis ADD FUNCTION ST_Intersects (text, text);
ALTER EXTENSION postgis ADD FUNCTION _ST_BestSRID (geography, geography);
ALTER EXTENSION postgis ADD FUNCTION _ST_BestSRID (geography);
ALTER EXTENSION postgis ADD FUNCTION ST_Buffer (geography, float8);
ALTER EXTENSION postgis ADD FUNCTION ST_Buffer (text, float8);
ALTER EXTENSION postgis ADD FUNCTION ST_Intersection (geography, geography);
ALTER EXTENSION postgis ADD FUNCTION ST_Intersection (text, text);
ALTER EXTENSION postgis ADD FUNCTION ST_AsBinary (geography);
ALTER EXTENSION postgis ADD FUNCTION ST_AsBinary (geography,text);
ALTER EXTENSION postgis ADD FUNCTION ST_AsEWKT (geography);
ALTER EXTENSION postgis ADD FUNCTION ST_AsEWKT (text);
ALTER EXTENSION postgis ADD FUNCTION GeometryType (geography);
ALTER EXTENSION postgis ADD FUNCTION ST_Summary (geography);
ALTER EXTENSION postgis ADD FUNCTION ST_GeoHash (geog geography, maxchars int4 );
ALTER EXTENSION postgis ADD FUNCTION ST_SRID (geog geography);
ALTER EXTENSION postgis ADD FUNCTION ST_SetSRID (geog geography, srid int4);
ALTER EXTENSION postgis ADD FUNCTION ST_DistanceSphere (geom1 geometry, geom2 geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_distance_sphere (geom1 geometry, geom2 geometry);
ALTER EXTENSION postgis ADD FUNCTION postgis_type_name (geomname varchar, coord_dimension integer, use_new_name boolean );
ALTER EXTENSION postgis ADD FUNCTION postgis_constraint_srid (geomschema text, geomtable text, geomcolumn text);
ALTER EXTENSION postgis ADD FUNCTION postgis_constraint_dims (geomschema text, geomtable text, geomcolumn text);
ALTER EXTENSION postgis ADD FUNCTION postgis_constraint_type (geomschema text, geomtable text, geomcolumn text);
ALTER EXTENSION postgis ADD FUNCTION ST_3DDistance (geom1 geometry, geom2 geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_3DMaxDistance (geom1 geometry, geom2 geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_3DClosestPoint (geom1 geometry, geom2 geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_3DShortestLine (geom1 geometry, geom2 geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_3DLongestLine (geom1 geometry, geom2 geometry);
ALTER EXTENSION postgis ADD FUNCTION _ST_3DDWithin (geom1 geometry, geom2 geometry,float8);
ALTER EXTENSION postgis ADD FUNCTION ST_3DDWithin (geom1 geometry, geom2 geometry,float8);
ALTER EXTENSION postgis ADD FUNCTION _ST_3DDFullyWithin (geom1 geometry, geom2 geometry,float8);
ALTER EXTENSION postgis ADD FUNCTION ST_3DDFullyWithin (geom1 geometry, geom2 geometry,float8);
ALTER EXTENSION postgis ADD FUNCTION _ST_3DIntersects (geom1 geometry, geom2 geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_3DIntersects (geom1 geometry, geom2 geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_CoordDim (Geometry geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_CurveToLine (geometry, integer);
ALTER EXTENSION postgis ADD FUNCTION ST_CurveToLine (geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_HasArc (Geometry geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_LineToCurve (Geometry geometry);
ALTER EXTENSION postgis ADD FUNCTION _ST_OrderingEquals (GeometryA geometry, GeometryB geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_OrderingEquals (GeometryA geometry, GeometryB geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_Point (float8, float8);
ALTER EXTENSION postgis ADD FUNCTION ST_Polygon (geometry, int);
ALTER EXTENSION postgis ADD FUNCTION ST_WKBToSQL (WKB bytea);
ALTER EXTENSION postgis ADD FUNCTION ST_LocateBetween (Geometry geometry, FromMeasure float8, ToMeasure float8, LeftRightOffset float8 );
ALTER EXTENSION postgis ADD FUNCTION ST_LocateAlong (Geometry geometry, Measure float8, LeftRightOffset float8 );
ALTER EXTENSION postgis ADD FUNCTION ST_LocateBetweenElevations (Geometry geometry, FromElevation float8, ToElevation float8);
ALTER EXTENSION postgis ADD FUNCTION ST_InterpolatePoint (Line geometry, Point geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_MinimumBoundingCircle (inputgeom geometry, segs_per_quarter integer );
ALTER EXTENSION postgis ADD FUNCTION _st_concavehull (param_inputgeom geometry);
ALTER EXTENSION postgis ADD FUNCTION ST_ConcaveHull (param_geom geometry, param_pctconvex float, param_allow_holes boolean );
ALTER EXTENSION postgis ADD FUNCTION _ST_AsX3D (int4, geometry, int4, int4, text);
ALTER EXTENSION postgis ADD FUNCTION ST_AsX3D (geom geometry, maxdecimaldigits integer , options integer );
ALTER EXTENSION postgis ADD FUNCTION postgis_raster_lib_version ();
ALTER EXTENSION postgis ADD FUNCTION postgis_raster_scripts_installed ();
ALTER EXTENSION postgis ADD FUNCTION postgis_raster_lib_build_date ();
ALTER EXTENSION postgis ADD FUNCTION postgis_gdal_version ();
ALTER EXTENSION postgis ADD FUNCTION st_envelope (raster);
ALTER EXTENSION postgis ADD FUNCTION st_convexhull (raster);
ALTER EXTENSION postgis ADD FUNCTION st_minconvexhull (
	rast raster,
	nband integer );
ALTER EXTENSION postgis ADD FUNCTION box3d (raster);
ALTER EXTENSION postgis ADD FUNCTION st_height (raster);
ALTER EXTENSION postgis ADD FUNCTION st_numbands (raster);
ALTER EXTENSION postgis ADD FUNCTION st_scalex (raster);
ALTER EXTENSION postgis ADD FUNCTION st_scaley (raster);
ALTER EXTENSION postgis ADD FUNCTION st_skewx (raster);
ALTER EXTENSION postgis ADD FUNCTION st_skewy (raster);
ALTER EXTENSION postgis ADD FUNCTION st_srid (raster);
ALTER EXTENSION postgis ADD FUNCTION st_upperleftx (raster);
ALTER EXTENSION postgis ADD FUNCTION st_upperlefty (raster);
ALTER EXTENSION postgis ADD FUNCTION st_width (raster);
ALTER EXTENSION postgis ADD FUNCTION st_pixelwidth (raster);
ALTER EXTENSION postgis ADD FUNCTION st_pixelheight (raster);
ALTER EXTENSION postgis ADD FUNCTION st_geotransform (raster,
    OUT imag double precision,
    OUT jmag double precision,
    OUT theta_i double precision,
    OUT theta_ij double precision,
    OUT xoffset double precision,
    OUT yoffset double precision);
ALTER EXTENSION postgis ADD FUNCTION st_rotation (raster);
ALTER EXTENSION postgis ADD FUNCTION st_metadata (
	rast raster,
	OUT upperleftx double precision,
	OUT upperlefty double precision,
	OUT width int,
	OUT height int,
	OUT scalex double precision,
	OUT scaley double precision,
	OUT skewx double precision,
	OUT skewy double precision,
	OUT srid int,
	OUT numbands int
);
ALTER EXTENSION postgis ADD FUNCTION st_summary (rast raster);
ALTER EXTENSION postgis ADD FUNCTION ST_MemSize (raster);
ALTER EXTENSION postgis ADD FUNCTION st_makeemptyraster (width int, height int, upperleftx float8, upperlefty float8, scalex float8, scaley float8, skewx float8, skewy float8, srid int4 );
ALTER EXTENSION postgis ADD FUNCTION st_makeemptyraster (width int, height int, upperleftx float8, upperlefty float8, pixelsize float8);
ALTER EXTENSION postgis ADD FUNCTION st_makeemptyraster (rast raster);
ALTER EXTENSION postgis ADD FUNCTION st_addband (rast raster, addbandargset addbandarg[]);
ALTER EXTENSION postgis ADD FUNCTION st_addband (
	rast raster,
	index int,
	pixeltype text,
	initialvalue float8 ,
	nodataval float8 );
ALTER EXTENSION postgis ADD FUNCTION st_addband (
	rast raster,
	pixeltype text,
	initialvalue float8 ,
	nodataval float8 );
ALTER EXTENSION postgis ADD FUNCTION st_addband (
	torast raster,
	fromrast raster,
	fromband int ,
	torastindex int );
ALTER EXTENSION postgis ADD FUNCTION st_addband (
	torast raster,
	fromrasts raster[], fromband integer ,
	torastindex int );
ALTER EXTENSION postgis ADD FUNCTION st_addband (
	rast raster,
	index int,
	outdbfile text, outdbindex int[],
	nodataval double precision );
ALTER EXTENSION postgis ADD FUNCTION st_addband (
	rast raster,
	outdbfile text, outdbindex int[],
	index int ,
	nodataval double precision );
ALTER EXTENSION postgis ADD FUNCTION st_band (rast raster, nbands int[] );
ALTER EXTENSION postgis ADD FUNCTION st_band (rast raster, nband int);
ALTER EXTENSION postgis ADD FUNCTION st_band (rast raster, nbands text, delimiter char );
ALTER EXTENSION postgis ADD FUNCTION _st_summarystats (
	rast raster,
	nband int ,
	exclude_nodata_value boolean ,
	sample_percent double precision );
ALTER EXTENSION postgis ADD FUNCTION st_summarystats (
	rast raster,
	nband int ,
	exclude_nodata_value boolean );
ALTER EXTENSION postgis ADD FUNCTION st_summarystats (
	rast raster,
	exclude_nodata_value boolean
);
ALTER EXTENSION postgis ADD FUNCTION st_approxsummarystats (
	rast raster,
	nband int ,
	exclude_nodata_value boolean ,
	sample_percent double precision );
ALTER EXTENSION postgis ADD FUNCTION st_approxsummarystats (
	rast raster,
	nband int,
	sample_percent double precision
);
ALTER EXTENSION postgis ADD FUNCTION st_approxsummarystats (
	rast raster,
	exclude_nodata_value boolean,
	sample_percent double precision );
ALTER EXTENSION postgis ADD FUNCTION st_approxsummarystats (
	rast raster,
	sample_percent double precision
);
ALTER EXTENSION postgis ADD FUNCTION _st_summarystats_finalfn (internal);
ALTER EXTENSION postgis ADD FUNCTION _st_summarystats_transfn (
	internal,
	raster, integer,
	boolean, double precision
);
ALTER EXTENSION postgis ADD FUNCTION _st_summarystats_transfn (
	internal,
	raster, boolean, double precision
);
ALTER EXTENSION postgis ADD FUNCTION _st_summarystats_transfn (
	internal,
	raster, int, boolean
);
ALTER EXTENSION postgis ADD FUNCTION _st_summarystats (
	rastertable text,
	rastercolumn text,
	nband integer ,
	exclude_nodata_value boolean ,
	sample_percent double precision );
ALTER EXTENSION postgis ADD FUNCTION st_summarystats (
	rastertable text,
	rastercolumn text,
	nband integer ,
	exclude_nodata_value boolean );
ALTER EXTENSION postgis ADD FUNCTION st_summarystats (
	rastertable text,
	rastercolumn text,
	exclude_nodata_value boolean
);
ALTER EXTENSION postgis ADD FUNCTION st_approxsummarystats (
	rastertable text,
	rastercolumn text,
	nband integer ,
	exclude_nodata_value boolean ,
	sample_percent double precision );
ALTER EXTENSION postgis ADD FUNCTION st_approxsummarystats (
	rastertable text,
	rastercolumn text,
	nband integer,
	sample_percent double precision
);
ALTER EXTENSION postgis ADD FUNCTION st_approxsummarystats (
	rastertable text,
	rastercolumn text,
	exclude_nodata_value boolean
);
ALTER EXTENSION postgis ADD FUNCTION st_approxsummarystats (
	rastertable text,
	rastercolumn text,
	sample_percent double precision
);
ALTER EXTENSION postgis ADD FUNCTION _st_count (rast raster, nband int , exclude_nodata_value boolean , sample_percent double precision );
ALTER EXTENSION postgis ADD FUNCTION st_count (rast raster, nband int , exclude_nodata_value boolean );
ALTER EXTENSION postgis ADD FUNCTION st_count (rast raster, exclude_nodata_value boolean);
ALTER EXTENSION postgis ADD FUNCTION st_approxcount (rast raster, nband int , exclude_nodata_value boolean , sample_percent double precision );
ALTER EXTENSION postgis ADD FUNCTION st_approxcount (rast raster, nband int, sample_percent double precision);
ALTER EXTENSION postgis ADD FUNCTION st_approxcount (rast raster, exclude_nodata_value boolean, sample_percent double precision );
ALTER EXTENSION postgis ADD FUNCTION st_approxcount (rast raster, sample_percent double precision);
ALTER EXTENSION postgis ADD FUNCTION _st_countagg_finalfn (agg agg_count);
ALTER EXTENSION postgis ADD FUNCTION __st_countagg_transfn (
	agg agg_count,
	rast raster,
 	nband integer , exclude_nodata_value boolean ,
	sample_percent double precision );
ALTER EXTENSION postgis ADD FUNCTION _st_countagg_transfn (
	agg agg_count,
	rast raster,
 	nband integer, exclude_nodata_value boolean,
	sample_percent double precision
);
ALTER EXTENSION postgis ADD FUNCTION _st_countagg_transfn (
	agg agg_count,
	rast raster,
 	nband integer, exclude_nodata_value boolean
);
ALTER EXTENSION postgis ADD FUNCTION _st_countagg_transfn (
	agg agg_count,
	rast raster,
 	exclude_nodata_value boolean
);
ALTER EXTENSION postgis ADD FUNCTION _st_count (rastertable text, rastercolumn text, nband integer , exclude_nodata_value boolean , sample_percent double precision );
ALTER EXTENSION postgis ADD FUNCTION st_count (rastertable text, rastercolumn text, nband int , exclude_nodata_value boolean );
ALTER EXTENSION postgis ADD FUNCTION st_count (rastertable text, rastercolumn text, exclude_nodata_value boolean);
ALTER EXTENSION postgis ADD FUNCTION st_approxcount (rastertable text, rastercolumn text, nband int , exclude_nodata_value boolean , sample_percent double precision );
ALTER EXTENSION postgis ADD FUNCTION st_approxcount (rastertable text, rastercolumn text, nband int, sample_percent double precision);
ALTER EXTENSION postgis ADD FUNCTION st_approxcount (rastertable text, rastercolumn text, exclude_nodata_value boolean, sample_percent double precision );
ALTER EXTENSION postgis ADD FUNCTION st_approxcount (rastertable text, rastercolumn text, sample_percent double precision);
ALTER EXTENSION postgis ADD FUNCTION _st_histogram (
	rast raster, nband int ,
	exclude_nodata_value boolean ,
	sample_percent double precision ,
	bins int , width double precision[] ,
	right boolean ,
	min double precision , max double precision ,
	OUT min double precision,
	OUT max double precision,
	OUT count bigint,
	OUT percent double precision
);
ALTER EXTENSION postgis ADD FUNCTION st_histogram (
	rast raster, nband int ,
	exclude_nodata_value boolean ,
	bins int , width double precision[] ,
	right boolean ,
	OUT min double precision,
	OUT max double precision,
	OUT count bigint,
	OUT percent double precision
);
ALTER EXTENSION postgis ADD FUNCTION st_histogram (
	rast raster, nband int,
	exclude_nodata_value boolean,
	bins int,
	right boolean,
	OUT min double precision,
	OUT max double precision,
	OUT count bigint,
	OUT percent double precision
);
ALTER EXTENSION postgis ADD FUNCTION st_histogram (
	rast raster, nband int,
	bins int, width double precision[] ,
	right boolean ,
	OUT min double precision,
	OUT max double precision,
	OUT count bigint,
	OUT percent double precision
);
ALTER EXTENSION postgis ADD FUNCTION st_histogram (
	rast raster, nband int,
	bins int,
	right boolean,
	OUT min double precision,
	OUT max double precision,
	OUT count bigint,
	OUT percent double precision
);
ALTER EXTENSION postgis ADD FUNCTION st_approxhistogram (
	rast raster, nband int ,
	exclude_nodata_value boolean ,
	sample_percent double precision ,
	bins int , width double precision[] ,
	right boolean ,
	OUT min double precision,
	OUT max double precision,
	OUT count bigint,
	OUT percent double precision
);
ALTER EXTENSION postgis ADD FUNCTION st_approxhistogram (
	rast raster, nband int,
	exclude_nodata_value boolean,
	sample_percent double precision,
	bins int,
	right boolean,
	OUT min double precision,
	OUT max double precision,
	OUT count bigint,
	OUT percent double precision
);
ALTER EXTENSION postgis ADD FUNCTION st_approxhistogram (
	rast raster, nband int,
	sample_percent double precision,
	OUT min double precision,
	OUT max double precision,
	OUT count bigint,
	OUT percent double precision
);
ALTER EXTENSION postgis ADD FUNCTION st_approxhistogram (
	rast raster,
	sample_percent double precision,
	OUT min double precision,
	OUT max double precision,
	OUT count bigint,
	OUT percent double precision
);
ALTER EXTENSION postgis ADD FUNCTION st_approxhistogram (
	rast raster, nband int,
	sample_percent double precision,
	bins int, width double precision[] ,
	right boolean ,
	OUT min double precision,
	OUT max double precision,
	OUT count bigint,
	OUT percent double precision
);
ALTER EXTENSION postgis ADD FUNCTION st_approxhistogram (
	rast raster, nband int,
	sample_percent double precision,
	bins int, right boolean,
	OUT min double precision,
	OUT max double precision,
	OUT count bigint,
	OUT percent double precision
);
ALTER EXTENSION postgis ADD FUNCTION _st_histogram (
	rastertable text, rastercolumn text,
	nband int ,
	exclude_nodata_value boolean ,
	sample_percent double precision ,
	bins int , width double precision[] ,
	right boolean ,
	OUT min double precision,
	OUT max double precision,
	OUT count bigint,
	OUT percent double precision
);
ALTER EXTENSION postgis ADD FUNCTION st_histogram (
	rastertable text, rastercolumn text, nband int ,
	exclude_nodata_value boolean ,
	bins int , width double precision[] ,
	right boolean ,
	OUT min double precision,
	OUT max double precision,
	OUT count bigint,
	OUT percent double precision
);
ALTER EXTENSION postgis ADD FUNCTION st_histogram (
	rastertable text, rastercolumn text, nband int,
	exclude_nodata_value boolean,
	bins int,
	right boolean,
	OUT min double precision,
	OUT max double precision,
	OUT count bigint,
	OUT percent double precision
);
ALTER EXTENSION postgis ADD FUNCTION st_histogram (
	rastertable text, rastercolumn text, nband int,
	bins int, width double precision[] ,
	right boolean ,
	OUT min double precision,
	OUT max double precision,
	OUT count bigint,
	OUT percent double precision
);
ALTER EXTENSION postgis ADD FUNCTION st_histogram (
	rastertable text, rastercolumn text, nband int,
	bins int,
	right boolean,
	OUT min double precision,
	OUT max double precision,
	OUT count bigint,
	OUT percent double precision
);
ALTER EXTENSION postgis ADD FUNCTION st_approxhistogram (
	rastertable text, rastercolumn text,
	nband int ,
	exclude_nodata_value boolean ,
	sample_percent double precision ,
	bins int , width double precision[] ,
	right boolean ,
	OUT min double precision,
	OUT max double precision,
	OUT count bigint,
	OUT percent double precision
);
ALTER EXTENSION postgis ADD FUNCTION st_approxhistogram (
	rastertable text, rastercolumn text, nband int,
	exclude_nodata_value boolean,
	sample_percent double precision,
	bins int,
	right boolean,
	OUT min double precision,
	OUT max double precision,
	OUT count bigint,
	OUT percent double precision
);
ALTER EXTENSION postgis ADD FUNCTION st_approxhistogram (
	rastertable text, rastercolumn text, nband int,
	sample_percent double precision,
	OUT min double precision,
	OUT max double precision,
	OUT count bigint,
	OUT percent double precision
);
ALTER EXTENSION postgis ADD FUNCTION st_approxhistogram (
	rastertable text, rastercolumn text,
	sample_percent double precision,
	OUT min double precision,
	OUT max double precision,
	OUT count bigint,
	OUT percent double precision
);
ALTER EXTENSION postgis ADD FUNCTION st_approxhistogram (
	rastertable text, rastercolumn text, nband int,
	sample_percent double precision,
	bins int, width double precision[] ,
	right boolean ,
	OUT min double precision,
	OUT max double precision,
	OUT count bigint,
	OUT percent double precision
);
ALTER EXTENSION postgis ADD FUNCTION st_approxhistogram (
	rastertable text, rastercolumn text, nband int,
	sample_percent double precision,
	bins int,
	right boolean,
	OUT min double precision,
	OUT max double precision,
	OUT count bigint,
	OUT percent double precision
);
ALTER EXTENSION postgis ADD FUNCTION _st_quantile (
	rast raster,
	nband int ,
	exclude_nodata_value boolean ,
	sample_percent double precision ,
	quantiles double precision[] ,
	OUT quantile double precision,
	OUT value double precision
);
ALTER EXTENSION postgis ADD FUNCTION st_quantile (
	rast raster,
	nband int ,
	exclude_nodata_value boolean ,
	quantiles double precision[] ,
	OUT quantile double precision,
	OUT value double precision
);
ALTER EXTENSION postgis ADD FUNCTION st_quantile (
	rast raster,
	nband int,
	quantiles double precision[],
	OUT quantile double precision,
	OUT value double precision
);
ALTER EXTENSION postgis ADD FUNCTION st_quantile (
	rast raster,
	quantiles double precision[],
	OUT quantile double precision,
	OUT value double precision
);
ALTER EXTENSION postgis ADD FUNCTION st_quantile (rast raster, nband int, exclude_nodata_value boolean, quantile double precision);
ALTER EXTENSION postgis ADD FUNCTION st_quantile (rast raster, nband int, quantile double precision);
ALTER EXTENSION postgis ADD FUNCTION st_quantile (rast raster, exclude_nodata_value boolean, quantile double precision );
ALTER EXTENSION postgis ADD FUNCTION st_quantile (rast raster, quantile double precision);
ALTER EXTENSION postgis ADD FUNCTION st_approxquantile (
	rast raster,
	nband int ,
	exclude_nodata_value boolean ,
	sample_percent double precision ,
	quantiles double precision[] ,
	OUT quantile double precision,
	OUT value double precision
);
ALTER EXTENSION postgis ADD FUNCTION st_approxquantile (
	rast raster,
	nband int,
	sample_percent double precision,
	quantiles double precision[] ,
	OUT quantile double precision,
	OUT value double precision
);
ALTER EXTENSION postgis ADD FUNCTION st_approxquantile (
	rast raster,
	sample_percent double precision,
	quantiles double precision[] ,
	OUT quantile double precision,
	OUT value double precision
);
ALTER EXTENSION postgis ADD FUNCTION st_approxquantile (
	rast raster,
	quantiles double precision[],
	OUT quantile double precision,
	OUT value double precision
);
ALTER EXTENSION postgis ADD FUNCTION st_approxquantile (rast raster, nband int, exclude_nodata_value boolean, sample_percent double precision, quantile double precision);
ALTER EXTENSION postgis ADD FUNCTION st_approxquantile (rast raster, nband int, sample_percent double precision, quantile double precision);
ALTER EXTENSION postgis ADD FUNCTION st_approxquantile (rast raster, sample_percent double precision, quantile double precision);
ALTER EXTENSION postgis ADD FUNCTION st_approxquantile (rast raster, exclude_nodata_value boolean, quantile double precision );
ALTER EXTENSION postgis ADD FUNCTION st_approxquantile (rast raster, quantile double precision);
ALTER EXTENSION postgis ADD FUNCTION _st_quantile (
	rastertable text,
	rastercolumn text,
	nband int ,
	exclude_nodata_value boolean ,
	sample_percent double precision ,
	quantiles double precision[] ,
	OUT quantile double precision,
	OUT value double precision
);
ALTER EXTENSION postgis ADD FUNCTION st_quantile (
	rastertable text,
	rastercolumn text,
	nband int ,
	exclude_nodata_value boolean ,
	quantiles double precision[] ,
	OUT quantile double precision,
	OUT value double precision
);
ALTER EXTENSION postgis ADD FUNCTION st_quantile (
	rastertable text,
	rastercolumn text,
	nband int,
	quantiles double precision[],
	OUT quantile double precision,
	OUT value double precision
);
ALTER EXTENSION postgis ADD FUNCTION st_quantile (
	rastertable text,
	rastercolumn text,
	quantiles double precision[],
	OUT quantile double precision,
	OUT value double precision
);
ALTER EXTENSION postgis ADD FUNCTION st_quantile (rastertable text, rastercolumn text, nband int, exclude_nodata_value boolean, quantile double precision);
ALTER EXTENSION postgis ADD FUNCTION st_quantile (rastertable text, rastercolumn text, nband int, quantile double precision);
ALTER EXTENSION postgis ADD FUNCTION st_quantile (rastertable text, rastercolumn text, exclude_nodata_value boolean, quantile double precision );
ALTER EXTENSION postgis ADD FUNCTION st_quantile (rastertable text, rastercolumn text, quantile double precision);
ALTER EXTENSION postgis ADD FUNCTION st_approxquantile (
	rastertable text,
	rastercolumn text,
	nband int ,
	exclude_nodata_value boolean ,
	sample_percent double precision ,
	quantiles double precision[] ,
	OUT quantile double precision,
	OUT value double precision
);
ALTER EXTENSION postgis ADD FUNCTION st_approxquantile (
	rastertable text,
	rastercolumn text,
	nband int,
	sample_percent double precision,
	quantiles double precision[] ,
	OUT quantile double precision,
	OUT value double precision
);
ALTER EXTENSION postgis ADD FUNCTION st_approxquantile (
	rastertable text,
	rastercolumn text,
	sample_percent double precision,
	quantiles double precision[] ,
	OUT quantile double precision,
	OUT value double precision
);
ALTER EXTENSION postgis ADD FUNCTION st_approxquantile (
	rastertable text,
	rastercolumn text,
	quantiles double precision[],
	OUT quantile double precision,
	OUT value double precision
);
ALTER EXTENSION postgis ADD FUNCTION st_approxquantile (rastertable text, rastercolumn text, nband int, exclude_nodata_value boolean, sample_percent double precision, quantile double precision);
ALTER EXTENSION postgis ADD FUNCTION st_approxquantile (rastertable text, rastercolumn text, nband int, sample_percent double precision, quantile double precision);
ALTER EXTENSION postgis ADD FUNCTION st_approxquantile (rastertable text, rastercolumn text, sample_percent double precision, quantile double precision);
ALTER EXTENSION postgis ADD FUNCTION st_approxquantile (rastertable text, rastercolumn text, exclude_nodata_value boolean, quantile double precision );
ALTER EXTENSION postgis ADD FUNCTION st_approxquantile (rastertable text, rastercolumn text, quantile double precision);
ALTER EXTENSION postgis ADD FUNCTION _st_valuecount (
	rast raster, nband integer ,
	exclude_nodata_value boolean ,
	searchvalues double precision[] ,
	roundto double precision ,
	OUT value double precision,
	OUT count integer,
	OUT percent double precision
);
ALTER EXTENSION postgis ADD FUNCTION st_valuecount (
	rast raster, nband integer ,
	exclude_nodata_value boolean ,
	searchvalues double precision[] ,
	roundto double precision ,
	OUT value double precision, OUT count integer
);
ALTER EXTENSION postgis ADD FUNCTION st_valuecount (rast raster, nband integer, searchvalues double precision[], roundto double precision , OUT value double precision, OUT count integer);
ALTER EXTENSION postgis ADD FUNCTION st_valuecount (rast raster, searchvalues double precision[], roundto double precision , OUT value double precision, OUT count integer);
ALTER EXTENSION postgis ADD FUNCTION st_valuecount (rast raster, nband integer, exclude_nodata_value boolean, searchvalue double precision, roundto double precision );
ALTER EXTENSION postgis ADD FUNCTION st_valuecount (rast raster, nband integer, searchvalue double precision, roundto double precision );
ALTER EXTENSION postgis ADD FUNCTION st_valuecount (rast raster, searchvalue double precision, roundto double precision );
ALTER EXTENSION postgis ADD FUNCTION st_valuepercent (
	rast raster, nband integer ,
	exclude_nodata_value boolean ,
	searchvalues double precision[] ,
	roundto double precision ,
	OUT value double precision, OUT percent double precision
);
ALTER EXTENSION postgis ADD FUNCTION st_valuepercent (rast raster, nband integer, searchvalues double precision[], roundto double precision , OUT value double precision, OUT percent double precision);
ALTER EXTENSION postgis ADD FUNCTION st_valuepercent (rast raster, searchvalues double precision[], roundto double precision , OUT value double precision, OUT percent double precision);
ALTER EXTENSION postgis ADD FUNCTION st_valuepercent (rast raster, nband integer, exclude_nodata_value boolean, searchvalue double precision, roundto double precision );
ALTER EXTENSION postgis ADD FUNCTION st_valuepercent (rast raster, nband integer, searchvalue double precision, roundto double precision );
ALTER EXTENSION postgis ADD FUNCTION st_valuepercent (rast raster, searchvalue double precision, roundto double precision );
ALTER EXTENSION postgis ADD FUNCTION _st_valuecount (
	rastertable text,
	rastercolumn text,
	nband integer ,
	exclude_nodata_value boolean ,
	searchvalues double precision[] ,
	roundto double precision ,
	OUT value double precision,
	OUT count integer,
	OUT percent double precision
);
ALTER EXTENSION postgis ADD FUNCTION st_valuecount (
	rastertable text, rastercolumn text,
	nband integer ,
	exclude_nodata_value boolean ,
	searchvalues double precision[] ,
	roundto double precision ,
	OUT value double precision, OUT count integer
);
ALTER EXTENSION postgis ADD FUNCTION st_valuecount (rastertable text, rastercolumn text, nband integer, searchvalues double precision[], roundto double precision , OUT value double precision, OUT count integer);
ALTER EXTENSION postgis ADD FUNCTION st_valuecount (rastertable text, rastercolumn text, searchvalues double precision[], roundto double precision , OUT value double precision, OUT count integer);
ALTER EXTENSION postgis ADD FUNCTION st_valuecount (rastertable text, rastercolumn text, nband integer, exclude_nodata_value boolean, searchvalue double precision, roundto double precision );
ALTER EXTENSION postgis ADD FUNCTION st_valuecount (rastertable text, rastercolumn text, nband integer, searchvalue double precision, roundto double precision );
ALTER EXTENSION postgis ADD FUNCTION st_valuecount (rastertable text, rastercolumn text, searchvalue double precision, roundto double precision );
ALTER EXTENSION postgis ADD FUNCTION st_valuepercent (
	rastertable text, rastercolumn text,
	nband integer ,
	exclude_nodata_value boolean ,
	searchvalues double precision[] ,
	roundto double precision ,
	OUT value double precision, OUT percent double precision
);
ALTER EXTENSION postgis ADD FUNCTION st_valuepercent (rastertable text, rastercolumn text, nband integer, searchvalues double precision[], roundto double precision , OUT value double precision, OUT percent double precision);
ALTER EXTENSION postgis ADD FUNCTION st_valuepercent (rastertable text, rastercolumn text, searchvalues double precision[], roundto double precision , OUT value double precision, OUT percent double precision);
ALTER EXTENSION postgis ADD FUNCTION st_valuepercent (rastertable text, rastercolumn text, nband integer, exclude_nodata_value boolean, searchvalue double precision, roundto double precision );
ALTER EXTENSION postgis ADD FUNCTION st_valuepercent (rastertable text, rastercolumn text, nband integer, searchvalue double precision, roundto double precision );
ALTER EXTENSION postgis ADD FUNCTION st_valuepercent (rastertable text, rastercolumn text, searchvalue double precision, roundto double precision );
ALTER EXTENSION postgis ADD FUNCTION _st_reclass (rast raster, VARIADIC reclassargset reclassarg[]);
ALTER EXTENSION postgis ADD FUNCTION st_reclass (rast raster, VARIADIC reclassargset reclassarg[]);
ALTER EXTENSION postgis ADD FUNCTION st_reclass (rast raster, nband int, reclassexpr text, pixeltype text, nodataval double precision );
ALTER EXTENSION postgis ADD FUNCTION st_reclass (rast raster, reclassexpr text, pixeltype text);
ALTER EXTENSION postgis ADD FUNCTION _st_colormap (
	rast raster, nband int,
	colormap text,
	method text );
ALTER EXTENSION postgis ADD FUNCTION st_colormap (
	rast raster, nband int ,
	colormap text ,
	method text );
ALTER EXTENSION postgis ADD FUNCTION st_colormap (
	rast raster,
	colormap text,
	method text );
ALTER EXTENSION postgis ADD FUNCTION st_fromgdalraster (gdaldata bytea, srid integer );
ALTER EXTENSION postgis ADD FUNCTION st_gdaldrivers (OUT idx int, OUT short_name text, OUT long_name text, OUT create_options text);
ALTER EXTENSION postgis ADD FUNCTION st_asgdalraster (rast raster, format text, options text[] , srid integer );
ALTER EXTENSION postgis ADD FUNCTION st_astiff (rast raster, options text[] , srid integer );
ALTER EXTENSION postgis ADD FUNCTION st_astiff (rast raster, nbands int[], options text[] , srid integer );
ALTER EXTENSION postgis ADD FUNCTION st_astiff (rast raster, compression text, srid integer );
ALTER EXTENSION postgis ADD FUNCTION st_astiff (rast raster, nbands int[], compression text, srid integer );
ALTER EXTENSION postgis ADD FUNCTION st_asjpeg (rast raster, options text[] );
ALTER EXTENSION postgis ADD FUNCTION st_asjpeg (rast raster, nbands int[], options text[] );
ALTER EXTENSION postgis ADD FUNCTION st_asjpeg (rast raster, nbands int[], quality int);
ALTER EXTENSION postgis ADD FUNCTION st_asjpeg (rast raster, nband int, options text[] );
ALTER EXTENSION postgis ADD FUNCTION st_asjpeg (rast raster, nband int, quality int);
ALTER EXTENSION postgis ADD FUNCTION st_aspng (rast raster, options text[] );
ALTER EXTENSION postgis ADD FUNCTION st_aspng (rast raster, nbands int[], options text[] );
ALTER EXTENSION postgis ADD FUNCTION st_aspng (rast raster, nbands int[], compression int);
ALTER EXTENSION postgis ADD FUNCTION st_aspng (rast raster, nband int, options text[] );
ALTER EXTENSION postgis ADD FUNCTION st_aspng (rast raster, nband int, compression int);
ALTER EXTENSION postgis ADD FUNCTION _st_asraster (
	geom geometry,
	scalex double precision , scaley double precision ,
	width integer , height integer ,
	pixeltype text[] ,
	value double precision[] ,
	nodataval double precision[] ,
	upperleftx double precision , upperlefty double precision ,
	gridx double precision , gridy double precision ,
	skewx double precision , skewy double precision ,
	touched boolean );
ALTER EXTENSION postgis ADD FUNCTION st_asraster (
	geom geometry,
	scalex double precision, scaley double precision,
	gridx double precision , gridy double precision ,
	pixeltype text[] ,
	value double precision[] ,
	nodataval double precision[] ,
	skewx double precision , skewy double precision ,
	touched boolean );
ALTER EXTENSION postgis ADD FUNCTION st_asraster (
	geom geometry,
	scalex double precision, scaley double precision,
	pixeltype text[],
	value double precision[] ,
	nodataval double precision[] ,
	upperleftx double precision , upperlefty double precision ,
	skewx double precision , skewy double precision ,
	touched boolean );
ALTER EXTENSION postgis ADD FUNCTION st_asraster (
	geom geometry,
	width integer, height integer,
	gridx double precision , gridy double precision ,
	pixeltype text[] ,
	value double precision[] ,
	nodataval double precision[] ,
	skewx double precision , skewy double precision ,
	touched boolean );
ALTER EXTENSION postgis ADD FUNCTION st_asraster (
	geom geometry,
	width integer, height integer,
	pixeltype text[],
	value double precision[] ,
	nodataval double precision[] ,
	upperleftx double precision , upperlefty double precision ,
	skewx double precision , skewy double precision ,
	touched boolean );
ALTER EXTENSION postgis ADD FUNCTION st_asraster (
	geom geometry,
	scalex double precision, scaley double precision,
	gridx double precision, gridy double precision,
	pixeltype text,
	value double precision ,
	nodataval double precision ,
	skewx double precision , skewy double precision ,
	touched boolean );
ALTER EXTENSION postgis ADD FUNCTION st_asraster (
	geom geometry,
	scalex double precision, scaley double precision,
	pixeltype text,
	value double precision ,
	nodataval double precision ,
	upperleftx double precision , upperlefty double precision ,
	skewx double precision , skewy double precision ,
	touched boolean );
ALTER EXTENSION postgis ADD FUNCTION st_asraster (
	geom geometry,
	width integer, height integer,
	gridx double precision, gridy double precision,
	pixeltype text,
	value double precision ,
	nodataval double precision ,
	skewx double precision , skewy double precision ,
	touched boolean );
ALTER EXTENSION postgis ADD FUNCTION st_asraster (
	geom geometry,
	width integer, height integer,
	pixeltype text,
	value double precision ,
	nodataval double precision ,
	upperleftx double precision , upperlefty double precision ,
	skewx double precision , skewy double precision ,
	touched boolean );
ALTER EXTENSION postgis ADD FUNCTION st_asraster (
	geom geometry,
	ref raster,
	pixeltype text[] ,
	value double precision[] ,
	nodataval double precision[] ,
	touched boolean );
ALTER EXTENSION postgis ADD FUNCTION st_asraster (
	geom geometry,
	ref raster,
	pixeltype text,
	value double precision ,
	nodataval double precision ,
	touched boolean );
ALTER EXTENSION postgis ADD FUNCTION _st_gdalwarp (
	rast raster,
	algorithm text , maxerr double precision ,
	srid integer ,
	scalex double precision , scaley double precision ,
	gridx double precision , gridy double precision ,
	skewx double precision , skewy double precision ,
	width integer , height integer );
ALTER EXTENSION postgis ADD FUNCTION st_resample (
	rast raster,
	scalex double precision , scaley double precision ,
	gridx double precision , gridy double precision ,
	skewx double precision , skewy double precision ,
	algorithm text , maxerr double precision );
ALTER EXTENSION postgis ADD FUNCTION st_resample (
	rast raster,
	width integer, height integer,
	gridx double precision , gridy double precision ,
	skewx double precision , skewy double precision ,
	algorithm text , maxerr double precision );
ALTER EXTENSION postgis ADD FUNCTION st_resample (
	rast raster,
	ref raster,
	algorithm text ,
	maxerr double precision ,
	usescale boolean );
ALTER EXTENSION postgis ADD FUNCTION st_resample (
	rast raster,
	ref raster,
	usescale boolean,
	algorithm text ,
	maxerr double precision );
ALTER EXTENSION postgis ADD FUNCTION st_transform (rast raster, srid integer, algorithm text , maxerr double precision , scalex double precision , scaley double precision );
ALTER EXTENSION postgis ADD FUNCTION st_transform (rast raster, srid integer, scalex double precision, scaley double precision, algorithm text , maxerr double precision );
ALTER EXTENSION postgis ADD FUNCTION st_transform (rast raster, srid integer, scalexy double precision, algorithm text , maxerr double precision );
ALTER EXTENSION postgis ADD FUNCTION st_transform (
	rast raster, 
	alignto raster,
	algorithm text , maxerr double precision );
ALTER EXTENSION postgis ADD FUNCTION st_rescale (rast raster, scalex double precision, scaley double precision, algorithm text , maxerr double precision );
ALTER EXTENSION postgis ADD FUNCTION st_rescale (rast raster, scalexy double precision, algorithm text , maxerr double precision );
ALTER EXTENSION postgis ADD FUNCTION st_reskew (rast raster, skewx double precision, skewy double precision, algorithm text , maxerr double precision );
ALTER EXTENSION postgis ADD FUNCTION st_reskew (rast raster, skewxy double precision, algorithm text , maxerr double precision );
ALTER EXTENSION postgis ADD FUNCTION st_snaptogrid (
	rast raster,
	gridx double precision, gridy double precision,
	algorithm text , maxerr double precision ,
	scalex double precision , scaley double precision );
ALTER EXTENSION postgis ADD FUNCTION st_snaptogrid (
	rast raster,
	gridx double precision, gridy double precision,
	scalex double precision, scaley double precision,
	algorithm text , maxerr double precision );
ALTER EXTENSION postgis ADD FUNCTION st_snaptogrid (
	rast raster,
	gridx double precision, gridy double precision,
	scalexy double precision,
	algorithm text , maxerr double precision );
ALTER EXTENSION postgis ADD FUNCTION st_resize (
	rast raster,
	width text, height text,
	algorithm text , maxerr double precision );
ALTER EXTENSION postgis ADD FUNCTION st_resize (
	rast raster,
	width integer, height integer,
	algorithm text , maxerr double precision );
ALTER EXTENSION postgis ADD FUNCTION st_resize (
	rast raster,
	percentwidth double precision, percentheight double precision,
	algorithm text , maxerr double precision );
ALTER EXTENSION postgis ADD FUNCTION st_mapalgebraexpr (rast raster, band integer, pixeltype text,
        expression text, nodataval double precision );
ALTER EXTENSION postgis ADD FUNCTION st_mapalgebraexpr (rast raster, pixeltype text, expression text,
        nodataval double precision );
ALTER EXTENSION postgis ADD FUNCTION st_mapalgebrafct (rast raster, band integer,
        pixeltype text, onerastuserfunc regprocedure, variadic args text[]);
ALTER EXTENSION postgis ADD FUNCTION st_mapalgebrafct (rast raster, band integer,
        pixeltype text, onerastuserfunc regprocedure);
ALTER EXTENSION postgis ADD FUNCTION st_mapalgebrafct (rast raster, band integer,
        onerastuserfunc regprocedure, variadic args text[]);
ALTER EXTENSION postgis ADD FUNCTION st_mapalgebrafct (rast raster, band integer,
        onerastuserfunc regprocedure);
ALTER EXTENSION postgis ADD FUNCTION st_mapalgebrafct (rast raster, pixeltype text,
        onerastuserfunc regprocedure, variadic args text[]);
ALTER EXTENSION postgis ADD FUNCTION st_mapalgebrafct (rast raster, pixeltype text,
        onerastuserfunc regprocedure);
ALTER EXTENSION postgis ADD FUNCTION st_mapalgebrafct (rast raster, onerastuserfunc regprocedure,
        variadic args text[]);
ALTER EXTENSION postgis ADD FUNCTION st_mapalgebrafct (rast raster, onerastuserfunc regprocedure);
ALTER EXTENSION postgis ADD FUNCTION st_mapalgebraexpr (
	rast1 raster, band1 integer,
	rast2 raster, band2 integer,
	expression text,
	pixeltype text , extenttype text ,
	nodata1expr text , nodata2expr text ,
	nodatanodataval double precision );
ALTER EXTENSION postgis ADD FUNCTION st_mapalgebraexpr (
	rast1 raster,
	rast2 raster,
	expression text,
	pixeltype text , extenttype text ,
	nodata1expr text , nodata2expr text ,
	nodatanodataval double precision );
ALTER EXTENSION postgis ADD FUNCTION st_mapalgebrafct (
	rast1 raster, band1 integer,
	rast2 raster, band2 integer,
	tworastuserfunc regprocedure,
	pixeltype text , extenttype text ,
	VARIADIC userargs text[] );
ALTER EXTENSION postgis ADD FUNCTION st_mapalgebrafct (
	rast1 raster,
	rast2 raster,
	tworastuserfunc regprocedure,
	pixeltype text , extenttype text ,
	VARIADIC userargs text[] );
ALTER EXTENSION postgis ADD FUNCTION st_mapalgebrafctngb (
    rast raster,
    band integer,
    pixeltype text,
    ngbwidth integer,
    ngbheight integer,
    onerastngbuserfunc regprocedure,
    nodatamode text,
    variadic args text[]
);
ALTER EXTENSION postgis ADD FUNCTION st_max4ma (matrix float[][], nodatamode text, variadic args text[]);
ALTER EXTENSION postgis ADD FUNCTION st_min4ma (matrix float[][], nodatamode text, variadic args text[]);
ALTER EXTENSION postgis ADD FUNCTION st_sum4ma (matrix float[][], nodatamode text, variadic args text[]);
ALTER EXTENSION postgis ADD FUNCTION st_mean4ma (matrix float[][], nodatamode text, variadic args text[]);
ALTER EXTENSION postgis ADD FUNCTION st_range4ma (matrix float[][], nodatamode text, variadic args text[]);
ALTER EXTENSION postgis ADD FUNCTION st_distinct4ma (matrix float[][], nodatamode TEXT, VARIADIC args TEXT[]);
ALTER EXTENSION postgis ADD FUNCTION st_stddev4ma (matrix float[][], nodatamode TEXT, VARIADIC args TEXT[]);
ALTER EXTENSION postgis ADD FUNCTION _st_mapalgebra (
	rastbandargset rastbandarg[],
	callbackfunc regprocedure,
	pixeltype text ,
	distancex integer , distancey integer ,
	extenttype text , customextent raster ,
	mask double precision[][] , weighted boolean ,
	VARIADIC userargs text[] );
ALTER EXTENSION postgis ADD FUNCTION st_mapalgebra (
	rastbandargset rastbandarg[],
	callbackfunc regprocedure,
	pixeltype text ,
	extenttype text , customextent raster ,
	distancex integer , distancey integer ,
	VARIADIC userargs text[] );
ALTER EXTENSION postgis ADD FUNCTION st_mapalgebra (
	rast raster, nband int[],
	callbackfunc regprocedure,
	pixeltype text ,
	extenttype text , customextent raster ,
	distancex integer , distancey integer ,
	VARIADIC userargs text[] );
ALTER EXTENSION postgis ADD FUNCTION st_mapalgebra (
	rast raster, nband int,
	callbackfunc regprocedure,
	pixeltype text ,
	extenttype text , customextent raster ,
	distancex integer , distancey integer ,
	VARIADIC userargs text[] );
ALTER EXTENSION postgis ADD FUNCTION st_mapalgebra (
	rast1 raster, nband1 int,
	rast2 raster, nband2 int,
	callbackfunc regprocedure,
	pixeltype text ,
	extenttype text , customextent raster ,
	distancex integer , distancey integer ,
	VARIADIC userargs text[] );
ALTER EXTENSION postgis ADD FUNCTION st_mapalgebra (
	rast raster, nband int,
	callbackfunc regprocedure,
	mask double precision [][], weighted boolean,
	pixeltype text ,
	extenttype text , customextent raster ,
	VARIADIC userargs text[] );
ALTER EXTENSION postgis ADD FUNCTION _st_mapalgebra (
	rastbandargset rastbandarg[],
	expression text,
	pixeltype text , extenttype text ,
	nodata1expr text , nodata2expr text ,
	nodatanodataval double precision );
ALTER EXTENSION postgis ADD FUNCTION st_mapalgebra (
	rast raster, nband integer,
	pixeltype text,
	expression text, nodataval double precision );
ALTER EXTENSION postgis ADD FUNCTION st_mapalgebra (
	rast raster,
	pixeltype text,
	expression text, nodataval double precision );
ALTER EXTENSION postgis ADD FUNCTION st_mapalgebra (
	rast1 raster, band1 integer,
	rast2 raster, band2 integer,
	expression text,
	pixeltype text , extenttype text ,
	nodata1expr text , nodata2expr text ,
	nodatanodataval double precision );
ALTER EXTENSION postgis ADD FUNCTION st_mapalgebra (
	rast1 raster,
	rast2 raster,
	expression text,
	pixeltype text , extenttype text ,
	nodata1expr text , nodata2expr text ,
	nodatanodataval double precision );
ALTER EXTENSION postgis ADD FUNCTION _st_convertarray4ma (value double precision[][]);
ALTER EXTENSION postgis ADD FUNCTION st_max4ma (value double precision[][][], pos integer[][], VARIADIC userargs text[] );
ALTER EXTENSION postgis ADD FUNCTION st_min4ma (value double precision[][][], pos integer[][], VARIADIC userargs text[] );
ALTER EXTENSION postgis ADD FUNCTION st_sum4ma (value double precision[][][], pos integer[][], VARIADIC userargs text[] );
ALTER EXTENSION postgis ADD FUNCTION st_mean4ma (value double precision[][][], pos integer[][], VARIADIC userargs text[] );
ALTER EXTENSION postgis ADD FUNCTION st_range4ma (value double precision[][][], pos integer[][], VARIADIC userargs text[] );
ALTER EXTENSION postgis ADD FUNCTION st_distinct4ma (value double precision[][][], pos integer[][], VARIADIC userargs text[] );
ALTER EXTENSION postgis ADD FUNCTION st_stddev4ma (value double precision[][][], pos integer[][], VARIADIC userargs text[] );
ALTER EXTENSION postgis ADD FUNCTION st_invdistweight4ma (value double precision[][][], pos integer[][], VARIADIC userargs text[] );
ALTER EXTENSION postgis ADD FUNCTION st_mindist4ma (value double precision[][][], pos integer[][], VARIADIC userargs text[] );
ALTER EXTENSION postgis ADD FUNCTION _st_slope4ma (value double precision[][][], pos integer[][], VARIADIC userargs text[] );
ALTER EXTENSION postgis ADD FUNCTION st_slope (
	rast raster, nband integer,
	customextent raster,
	pixeltype text , units text ,
	scale double precision ,	interpolate_nodata boolean );
ALTER EXTENSION postgis ADD FUNCTION st_slope (
	rast raster, nband integer ,
	pixeltype text , units text ,
	scale double precision ,	interpolate_nodata boolean );
ALTER EXTENSION postgis ADD FUNCTION _st_aspect4ma (value double precision[][][], pos integer[][], VARIADIC userargs text[] );
ALTER EXTENSION postgis ADD FUNCTION st_aspect (
	rast raster, nband integer,
	customextent raster,
	pixeltype text , units text ,
	interpolate_nodata boolean );
ALTER EXTENSION postgis ADD FUNCTION st_aspect (
	rast raster, nband integer ,
	pixeltype text , units text ,
	interpolate_nodata boolean );
ALTER EXTENSION postgis ADD FUNCTION _st_hillshade4ma (value double precision[][][], pos integer[][], VARIADIC userargs text[] );
ALTER EXTENSION postgis ADD FUNCTION st_hillshade (
	rast raster, nband integer,
	customextent raster,
	pixeltype text ,
	azimuth double precision , altitude double precision ,
	max_bright double precision , scale double precision ,
	interpolate_nodata boolean );
ALTER EXTENSION postgis ADD FUNCTION st_hillshade (
	rast raster, nband integer ,
	pixeltype text ,
	azimuth double precision , altitude double precision ,
	max_bright double precision , scale double precision ,
	interpolate_nodata boolean );
ALTER EXTENSION postgis ADD FUNCTION _st_tpi4ma (value double precision[][][], pos integer[][], VARIADIC userargs text[] );
ALTER EXTENSION postgis ADD FUNCTION st_tpi (
	rast raster, nband integer,
	customextent raster,
	pixeltype text , interpolate_nodata boolean );
ALTER EXTENSION postgis ADD FUNCTION st_tpi (
	rast raster, nband integer ,
	pixeltype text , interpolate_nodata boolean );
ALTER EXTENSION postgis ADD FUNCTION _st_roughness4ma (value double precision[][][], pos integer[][], VARIADIC userargs text[] );
ALTER EXTENSION postgis ADD FUNCTION st_roughness (
	rast raster, nband integer,
	customextent raster,
	pixeltype text , interpolate_nodata boolean );
ALTER EXTENSION postgis ADD FUNCTION st_roughness (
	rast raster, nband integer ,
	pixeltype text , interpolate_nodata boolean );
ALTER EXTENSION postgis ADD FUNCTION _st_tri4ma (value double precision[][][], pos integer[][], VARIADIC userargs text[] );
ALTER EXTENSION postgis ADD FUNCTION st_tri (
	rast raster, nband integer,
	customextent raster,
	pixeltype text ,	interpolate_nodata boolean );
ALTER EXTENSION postgis ADD FUNCTION st_tri (
	rast raster, nband integer ,
	pixeltype text , interpolate_nodata boolean );
ALTER EXTENSION postgis ADD FUNCTION st_isempty (rast raster);
ALTER EXTENSION postgis ADD FUNCTION st_hasnoband (rast raster, nband int );
ALTER EXTENSION postgis ADD FUNCTION st_bandnodatavalue (rast raster, band integer );
ALTER EXTENSION postgis ADD FUNCTION st_bandisnodata (rast raster, band integer , forceChecking boolean );
ALTER EXTENSION postgis ADD FUNCTION st_bandisnodata (rast raster, forceChecking boolean);
ALTER EXTENSION postgis ADD FUNCTION st_bandpath (rast raster, band integer );
ALTER EXTENSION postgis ADD FUNCTION st_bandpixeltype (rast raster, band integer );
ALTER EXTENSION postgis ADD FUNCTION st_bandmetadata (
	rast raster,
	band int[],
	OUT bandnum int,
	OUT pixeltype text,
	OUT nodatavalue double precision,
	OUT isoutdb boolean,
	OUT path text
);
ALTER EXTENSION postgis ADD FUNCTION st_bandmetadata (
	rast raster,
	band int ,
	OUT pixeltype text,
	OUT nodatavalue double precision,
	OUT isoutdb boolean,
	OUT path text
);
ALTER EXTENSION postgis ADD FUNCTION st_value (rast raster, band integer, x integer, y integer, exclude_nodata_value boolean );
ALTER EXTENSION postgis ADD FUNCTION st_value (rast raster, x integer, y integer, exclude_nodata_value boolean );
ALTER EXTENSION postgis ADD FUNCTION st_value (rast raster, band integer, pt geometry, exclude_nodata_value boolean );
ALTER EXTENSION postgis ADD FUNCTION st_value (rast raster, pt geometry, exclude_nodata_value boolean );
ALTER EXTENSION postgis ADD FUNCTION st_pixelofvalue (
	rast raster,
	nband integer,
	search double precision[],
	exclude_nodata_value boolean ,
	OUT val double precision,
	OUT x integer,
	OUT y integer
);
ALTER EXTENSION postgis ADD FUNCTION st_pixelofvalue (
	rast raster,
	search double precision[],
	exclude_nodata_value boolean ,
	OUT val double precision,
	OUT x integer,
	OUT y integer
);
ALTER EXTENSION postgis ADD FUNCTION st_pixelofvalue (
	rast raster,
	nband integer,
	search double precision,
	exclude_nodata_value boolean ,
	OUT x integer,
	OUT y integer
);
ALTER EXTENSION postgis ADD FUNCTION st_pixelofvalue (
	rast raster,
	search double precision,
	exclude_nodata_value boolean ,
	OUT x integer,
	OUT y integer
);
ALTER EXTENSION postgis ADD FUNCTION st_georeference (rast raster, format text );
ALTER EXTENSION postgis ADD FUNCTION st_setscale (rast raster, scale float8);
ALTER EXTENSION postgis ADD FUNCTION st_setscale (rast raster, scalex float8, scaley float8);
ALTER EXTENSION postgis ADD FUNCTION st_setskew (rast raster, skew float8);
ALTER EXTENSION postgis ADD FUNCTION st_setskew (rast raster, skewx float8, skewy float8);
ALTER EXTENSION postgis ADD FUNCTION st_setsrid (rast raster, srid integer);
ALTER EXTENSION postgis ADD FUNCTION st_setupperleft (rast raster, upperleftx float8, upperlefty float8);
ALTER EXTENSION postgis ADD FUNCTION st_setrotation (rast raster, rotation float8);
ALTER EXTENSION postgis ADD FUNCTION st_setgeotransform (rast raster,
    imag double precision, 
    jmag double precision,
    theta_i double precision,
    theta_ij double precision,
    xoffset double precision,
    yoffset double precision);
ALTER EXTENSION postgis ADD FUNCTION st_setgeoreference (rast raster, georef text, format text );
ALTER EXTENSION postgis ADD FUNCTION st_setgeoreference (
	rast raster,
	upperleftx double precision, upperlefty double precision,
	scalex double precision, scaley double precision,
	skewx double precision, skewy double precision
);
ALTER EXTENSION postgis ADD FUNCTION _st_tile (
	rast raster,
	width integer, height integer,
	nband integer[] ,
	padwithnodata boolean , nodataval double precision );
ALTER EXTENSION postgis ADD FUNCTION st_tile (
	rast raster, nband integer[],
	width integer, height integer,
	padwithnodata boolean , nodataval double precision );
ALTER EXTENSION postgis ADD FUNCTION st_tile (
	rast raster, nband integer,
	width integer, height integer,
	padwithnodata boolean , nodataval double precision );
ALTER EXTENSION postgis ADD FUNCTION st_tile (
	rast raster,
	width integer, height integer,
	padwithnodata boolean , nodataval double precision );
ALTER EXTENSION postgis ADD FUNCTION st_setbandnodatavalue (rast raster, band integer, nodatavalue float8, forceChecking boolean );
ALTER EXTENSION postgis ADD FUNCTION st_setbandnodatavalue (rast raster, nodatavalue float8);
ALTER EXTENSION postgis ADD FUNCTION st_setbandisnodata (rast raster, band integer );
ALTER EXTENSION postgis ADD FUNCTION _st_setvalues (
	rast raster, nband integer,
	x integer, y integer,
	newvalueset double precision[][],
	noset boolean[][] ,
	hasnosetvalue boolean ,
	nosetvalue double precision ,
	keepnodata boolean );
ALTER EXTENSION postgis ADD FUNCTION st_setvalues (
	rast raster, nband integer,
	x integer, y integer,
	newvalueset double precision[][],
	noset boolean[][] ,
	keepnodata boolean );
ALTER EXTENSION postgis ADD FUNCTION st_setvalues (
	rast raster, nband integer,
	x integer, y integer,
	newvalueset double precision[][],
	nosetvalue double precision,
	keepnodata boolean );
ALTER EXTENSION postgis ADD FUNCTION st_setvalues (
	rast raster, nband integer,
	x integer, y integer,
	width integer, height integer,
	newvalue double precision,
	keepnodata boolean );
ALTER EXTENSION postgis ADD FUNCTION st_setvalues (
	rast raster,
	x integer, y integer,
	width integer, height integer,
	newvalue double precision,
	keepnodata boolean );
ALTER EXTENSION postgis ADD FUNCTION st_setvalues (
	rast raster, nband integer,
	geomvalset geomval[],
	keepnodata boolean );
ALTER EXTENSION postgis ADD FUNCTION st_setvalue (rast raster, band integer, x integer, y integer, newvalue float8);
ALTER EXTENSION postgis ADD FUNCTION st_setvalue (rast raster, x integer, y integer, newvalue float8);
ALTER EXTENSION postgis ADD FUNCTION st_setvalue (
	rast raster, nband integer,
	geom geometry, newvalue double precision
);
ALTER EXTENSION postgis ADD FUNCTION st_setvalue (
	rast raster,
	geom geometry, newvalue double precision
);
ALTER EXTENSION postgis ADD FUNCTION st_dumpaspolygons (rast raster, band integer , exclude_nodata_value boolean );
ALTER EXTENSION postgis ADD FUNCTION st_dumpvalues (
	rast raster, nband integer[] , exclude_nodata_value boolean ,
	OUT nband integer, OUT valarray double precision[][]
);
ALTER EXTENSION postgis ADD FUNCTION st_dumpvalues (rast raster, nband integer, exclude_nodata_value boolean );
ALTER EXTENSION postgis ADD FUNCTION st_polygon (rast raster, band integer );
ALTER EXTENSION postgis ADD FUNCTION _st_pixelaspolygons (
	rast raster,
	band integer ,
	columnx integer ,
	rowy integer ,
	exclude_nodata_value boolean ,
	OUT geom geometry,
	OUT val double precision,
	OUT x integer,
	OUT y integer
);
ALTER EXTENSION postgis ADD FUNCTION st_pixelaspolygons (
	rast raster,
	band integer ,
	exclude_nodata_value boolean ,
	OUT geom geometry,
	OUT val double precision,
	OUT x int,
	OUT y int
);
ALTER EXTENSION postgis ADD FUNCTION st_pixelaspolygon (rast raster, x integer, y integer);
ALTER EXTENSION postgis ADD FUNCTION st_pixelaspoints (
	rast raster,
	band integer ,
	exclude_nodata_value boolean ,
	OUT geom geometry,
	OUT val double precision,
	OUT x int,
	OUT y int
);
ALTER EXTENSION postgis ADD FUNCTION st_pixelaspoint (rast raster, x integer, y integer);
ALTER EXTENSION postgis ADD FUNCTION st_pixelascentroids (
	rast raster,
	band integer ,
	exclude_nodata_value boolean ,
	OUT geom geometry,
	OUT val double precision,
	OUT x int,
	OUT y int
);
ALTER EXTENSION postgis ADD FUNCTION st_pixelascentroid (rast raster, x integer, y integer);
ALTER EXTENSION postgis ADD FUNCTION _st_worldtorastercoord (
	rast raster,
	longitude double precision , latitude double precision ,
	OUT columnx integer,
	OUT rowy integer
);
ALTER EXTENSION postgis ADD FUNCTION st_worldtorastercoord (
	rast raster,
	longitude double precision, latitude double precision,
	OUT columnx integer,
	OUT rowy integer
);
ALTER EXTENSION postgis ADD FUNCTION st_worldtorastercoord (
	rast raster, pt geometry,
	OUT columnx integer,
	OUT rowy integer
);
ALTER EXTENSION postgis ADD FUNCTION st_worldtorastercoordx (rast raster, xw float8, yw float8);
ALTER EXTENSION postgis ADD FUNCTION st_worldtorastercoordx (rast raster, xw float8);
ALTER EXTENSION postgis ADD FUNCTION st_worldtorastercoordx (rast raster, pt geometry);
ALTER EXTENSION postgis ADD FUNCTION st_worldtorastercoordy (rast raster, xw float8, yw float8);
ALTER EXTENSION postgis ADD FUNCTION st_worldtorastercoordy (rast raster, yw float8);
ALTER EXTENSION postgis ADD FUNCTION st_worldtorastercoordy (rast raster, pt geometry);
ALTER EXTENSION postgis ADD FUNCTION _st_rastertoworldcoord (
	rast raster,
	columnx integer , rowy integer ,
	OUT longitude double precision,
	OUT latitude double precision
);
ALTER EXTENSION postgis ADD FUNCTION st_rastertoworldcoord (
	rast raster,
	columnx integer, rowy integer,
	OUT longitude double precision,
	OUT latitude double precision
);
ALTER EXTENSION postgis ADD FUNCTION st_rastertoworldcoordx (rast raster, xr int, yr int);
ALTER EXTENSION postgis ADD FUNCTION st_rastertoworldcoordx (rast raster, xr int);
ALTER EXTENSION postgis ADD FUNCTION st_rastertoworldcoordy (rast raster, xr int, yr int);
ALTER EXTENSION postgis ADD FUNCTION st_rastertoworldcoordy (rast raster, yr int);
ALTER EXTENSION postgis ADD FUNCTION st_minpossiblevalue (pixeltype text);
ALTER EXTENSION postgis ADD FUNCTION st_asbinary (raster, outasin boolean );
ALTER EXTENSION postgis ADD FUNCTION bytea (raster);
ALTER EXTENSION postgis ADD FUNCTION raster_hash (raster);
ALTER EXTENSION postgis ADD FUNCTION raster_eq (raster, raster);
ALTER EXTENSION postgis ADD FUNCTION raster_overleft (raster, raster);
ALTER EXTENSION postgis ADD FUNCTION raster_overright (raster, raster);
ALTER EXTENSION postgis ADD FUNCTION raster_left (raster, raster);
ALTER EXTENSION postgis ADD FUNCTION raster_right (raster, raster);
ALTER EXTENSION postgis ADD FUNCTION raster_overabove (raster, raster);
ALTER EXTENSION postgis ADD FUNCTION raster_overbelow (raster, raster);
ALTER EXTENSION postgis ADD FUNCTION raster_above (raster, raster);
ALTER EXTENSION postgis ADD FUNCTION raster_below (raster, raster);
ALTER EXTENSION postgis ADD FUNCTION raster_same (raster, raster);
ALTER EXTENSION postgis ADD FUNCTION raster_contained (raster, raster);
ALTER EXTENSION postgis ADD FUNCTION raster_contain (raster, raster);
ALTER EXTENSION postgis ADD FUNCTION raster_overlap (raster, raster);
ALTER EXTENSION postgis ADD FUNCTION raster_geometry_contain (raster, geometry);
ALTER EXTENSION postgis ADD FUNCTION raster_contained_by_geometry (raster, geometry);
ALTER EXTENSION postgis ADD FUNCTION raster_geometry_overlap (raster, geometry);
ALTER EXTENSION postgis ADD FUNCTION geometry_raster_contain (geometry, raster);
ALTER EXTENSION postgis ADD FUNCTION geometry_contained_by_raster (geometry, raster);
ALTER EXTENSION postgis ADD FUNCTION geometry_raster_overlap (geometry, raster);
ALTER EXTENSION postgis ADD FUNCTION st_samealignment (rast1 raster, rast2 raster);
ALTER EXTENSION postgis ADD FUNCTION st_samealignment (
	ulx1 double precision, uly1 double precision, scalex1 double precision, scaley1 double precision, skewx1 double precision, skewy1 double precision,
	ulx2 double precision, uly2 double precision, scalex2 double precision, scaley2 double precision, skewx2 double precision, skewy2 double precision
);
ALTER EXTENSION postgis ADD FUNCTION _st_samealignment_transfn (agg agg_samealignment, rast raster);
ALTER EXTENSION postgis ADD FUNCTION _st_samealignment_finalfn (agg agg_samealignment);
ALTER EXTENSION postgis ADD FUNCTION st_notsamealignmentreason (rast1 raster, rast2 raster);
ALTER EXTENSION postgis ADD FUNCTION st_iscoveragetile (rast raster, coverage raster, tilewidth integer, tileheight integer);
ALTER EXTENSION postgis ADD FUNCTION _st_intersects (rast1 raster, nband1 integer, rast2 raster, nband2 integer);
ALTER EXTENSION postgis ADD FUNCTION st_intersects (rast1 raster, nband1 integer, rast2 raster, nband2 integer);
ALTER EXTENSION postgis ADD FUNCTION st_intersects (rast1 raster, rast2 raster);
ALTER EXTENSION postgis ADD FUNCTION _st_intersects (geom geometry, rast raster, nband integer );
ALTER EXTENSION postgis ADD FUNCTION st_intersects (geom geometry, rast raster, nband integer );
ALTER EXTENSION postgis ADD FUNCTION st_intersects (rast raster, geom geometry, nband integer );
ALTER EXTENSION postgis ADD FUNCTION st_intersects (rast raster, nband integer, geom geometry);
ALTER EXTENSION postgis ADD FUNCTION _st_overlaps (rast1 raster, nband1 integer, rast2 raster, nband2 integer);
ALTER EXTENSION postgis ADD FUNCTION st_overlaps (rast1 raster, nband1 integer, rast2 raster, nband2 integer);
ALTER EXTENSION postgis ADD FUNCTION st_overlaps (rast1 raster, rast2 raster);
ALTER EXTENSION postgis ADD FUNCTION _st_touches (rast1 raster, nband1 integer, rast2 raster, nband2 integer);
ALTER EXTENSION postgis ADD FUNCTION st_touches (rast1 raster, nband1 integer, rast2 raster, nband2 integer);
ALTER EXTENSION postgis ADD FUNCTION st_touches (rast1 raster, rast2 raster);
ALTER EXTENSION postgis ADD FUNCTION _st_contains (rast1 raster, nband1 integer, rast2 raster, nband2 integer);
ALTER EXTENSION postgis ADD FUNCTION st_contains (rast1 raster, nband1 integer, rast2 raster, nband2 integer);
ALTER EXTENSION postgis ADD FUNCTION st_contains (rast1 raster, rast2 raster);
ALTER EXTENSION postgis ADD FUNCTION _st_containsproperly (rast1 raster, nband1 integer, rast2 raster, nband2 integer);
ALTER EXTENSION postgis ADD FUNCTION st_containsproperly (rast1 raster, nband1 integer, rast2 raster, nband2 integer);
ALTER EXTENSION postgis ADD FUNCTION st_containsproperly (rast1 raster, rast2 raster);
ALTER EXTENSION postgis ADD FUNCTION _st_covers (rast1 raster, nband1 integer, rast2 raster, nband2 integer);
ALTER EXTENSION postgis ADD FUNCTION st_covers (rast1 raster, nband1 integer, rast2 raster, nband2 integer);
ALTER EXTENSION postgis ADD FUNCTION st_covers (rast1 raster, rast2 raster);
ALTER EXTENSION postgis ADD FUNCTION _st_coveredby (rast1 raster, nband1 integer, rast2 raster, nband2 integer);
ALTER EXTENSION postgis ADD FUNCTION st_coveredby (rast1 raster, nband1 integer, rast2 raster, nband2 integer);
ALTER EXTENSION postgis ADD FUNCTION st_coveredby (rast1 raster, rast2 raster);
ALTER EXTENSION postgis ADD FUNCTION _st_within (rast1 raster, nband1 integer, rast2 raster, nband2 integer);
ALTER EXTENSION postgis ADD FUNCTION st_within (rast1 raster, nband1 integer, rast2 raster, nband2 integer);
ALTER EXTENSION postgis ADD FUNCTION st_within (rast1 raster, rast2 raster);
ALTER EXTENSION postgis ADD FUNCTION _st_dwithin (rast1 raster, nband1 integer, rast2 raster, nband2 integer, distance double precision);
ALTER EXTENSION postgis ADD FUNCTION st_dwithin (rast1 raster, nband1 integer, rast2 raster, nband2 integer, distance double precision);
ALTER EXTENSION postgis ADD FUNCTION st_dwithin (rast1 raster, rast2 raster, distance double precision);
ALTER EXTENSION postgis ADD FUNCTION _st_dfullywithin (rast1 raster, nband1 integer, rast2 raster, nband2 integer, distance double precision);
ALTER EXTENSION postgis ADD FUNCTION st_dfullywithin (rast1 raster, nband1 integer, rast2 raster, nband2 integer, distance double precision);
ALTER EXTENSION postgis ADD FUNCTION st_dfullywithin (rast1 raster, rast2 raster, distance double precision);
ALTER EXTENSION postgis ADD FUNCTION st_disjoint (rast1 raster, nband1 integer, rast2 raster, nband2 integer);
ALTER EXTENSION postgis ADD FUNCTION st_disjoint (rast1 raster, rast2 raster);
ALTER EXTENSION postgis ADD FUNCTION st_intersection (geomin geometry, rast raster, band integer );
ALTER EXTENSION postgis ADD FUNCTION st_intersection (rast raster, band integer, geomin geometry);
ALTER EXTENSION postgis ADD FUNCTION st_intersection (rast raster, geomin geometry);
ALTER EXTENSION postgis ADD FUNCTION st_intersection (
	rast1 raster, band1 int,
	rast2 raster, band2 int,
	returnband text ,
	nodataval double precision[] );
ALTER EXTENSION postgis ADD FUNCTION st_intersection (
	rast1 raster, band1 int,
	rast2 raster, band2 int,
	returnband text,
	nodataval double precision
);
ALTER EXTENSION postgis ADD FUNCTION st_intersection (
	rast1 raster, band1 int,
	rast2 raster, band2 int,
	nodataval double precision[]
);
ALTER EXTENSION postgis ADD FUNCTION st_intersection (
	rast1 raster, band1 int,
	rast2 raster, band2 int,
	nodataval double precision
);
ALTER EXTENSION postgis ADD FUNCTION st_intersection (
	rast1 raster,
	rast2 raster,
	returnband text ,
	nodataval double precision[] );
ALTER EXTENSION postgis ADD FUNCTION st_intersection (
	rast1 raster,
	rast2 raster,
	returnband text,
	nodataval double precision
);
ALTER EXTENSION postgis ADD FUNCTION st_intersection (
	rast1 raster,
	rast2 raster,
	nodataval double precision[]
);
ALTER EXTENSION postgis ADD FUNCTION st_intersection (
	rast1 raster,
	rast2 raster,
	nodataval double precision
);
ALTER EXTENSION postgis ADD FUNCTION _st_union_finalfn (internal);
ALTER EXTENSION postgis ADD FUNCTION _st_union_transfn (internal, raster, unionarg[]);
ALTER EXTENSION postgis ADD FUNCTION _st_union_transfn (internal, raster, integer, text);
ALTER EXTENSION postgis ADD FUNCTION _st_union_transfn (internal, raster, integer);
ALTER EXTENSION postgis ADD FUNCTION _st_union_transfn (internal, raster);
ALTER EXTENSION postgis ADD FUNCTION _st_union_transfn (internal, raster, text);
ALTER EXTENSION postgis ADD FUNCTION _st_clip (
	rast raster, nband integer[],
	geom geometry,
	nodataval double precision[] , crop boolean );
ALTER EXTENSION postgis ADD FUNCTION st_clip (
	rast raster, nband integer[],
	geom geometry,
	nodataval double precision[] , crop boolean );
ALTER EXTENSION postgis ADD FUNCTION st_clip (
	rast raster, nband integer,
	geom geometry,
	nodataval double precision, crop boolean );
ALTER EXTENSION postgis ADD FUNCTION st_clip (
	rast raster, nband integer,
	geom geometry,
	crop boolean
);
ALTER EXTENSION postgis ADD FUNCTION st_clip (
	rast raster,
	geom geometry,
	nodataval double precision[] , crop boolean );
ALTER EXTENSION postgis ADD FUNCTION st_clip (
	rast raster,
	geom geometry,
	nodataval double precision, crop boolean );
ALTER EXTENSION postgis ADD FUNCTION st_clip (
	rast raster,
	geom geometry,
	crop boolean
);
ALTER EXTENSION postgis ADD FUNCTION st_nearestvalue (
	rast raster, band integer,
	pt geometry,
	exclude_nodata_value boolean );
ALTER EXTENSION postgis ADD FUNCTION st_nearestvalue (
	rast raster,
	pt geometry,
	exclude_nodata_value boolean );
ALTER EXTENSION postgis ADD FUNCTION st_nearestvalue (
	rast raster, band integer,
	columnx integer, rowy integer,
	exclude_nodata_value boolean );
ALTER EXTENSION postgis ADD FUNCTION st_nearestvalue (
	rast raster,
	columnx integer, rowy integer,
	exclude_nodata_value boolean );
ALTER EXTENSION postgis ADD FUNCTION _st_neighborhood (
	rast raster, band integer,
	columnx integer, rowy integer,
	distancex integer, distancey integer,
	exclude_nodata_value boolean );
ALTER EXTENSION postgis ADD FUNCTION st_neighborhood (
	rast raster, band integer,
	columnx integer, rowy integer,
	distancex integer, distancey integer,
	exclude_nodata_value boolean );
ALTER EXTENSION postgis ADD FUNCTION st_neighborhood (
	rast raster,
	columnx integer, rowy integer,
	distancex integer, distancey integer,
	exclude_nodata_value boolean );
ALTER EXTENSION postgis ADD FUNCTION st_neighborhood (
	rast raster, band integer,
	pt geometry,
	distancex integer, distancey integer,
	exclude_nodata_value boolean );
ALTER EXTENSION postgis ADD FUNCTION st_neighborhood (
	rast raster,
	pt geometry,
	distancex integer, distancey integer,
	exclude_nodata_value boolean );
ALTER EXTENSION postgis ADD FUNCTION _add_raster_constraint (cn name, sql text);
ALTER EXTENSION postgis ADD FUNCTION _drop_raster_constraint (rastschema name, rasttable name, cn name);
ALTER EXTENSION postgis ADD FUNCTION _raster_constraint_info_srid (rastschema name, rasttable name, rastcolumn name);
ALTER EXTENSION postgis ADD FUNCTION _add_raster_constraint_srid (rastschema name, rasttable name, rastcolumn name);
ALTER EXTENSION postgis ADD FUNCTION _drop_raster_constraint_srid (rastschema name, rasttable name, rastcolumn name);
ALTER EXTENSION postgis ADD FUNCTION _raster_constraint_info_scale (rastschema name, rasttable name, rastcolumn name, axis char);
ALTER EXTENSION postgis ADD FUNCTION _add_raster_constraint_scale (rastschema name, rasttable name, rastcolumn name, axis char);
ALTER EXTENSION postgis ADD FUNCTION _drop_raster_constraint_scale (rastschema name, rasttable name, rastcolumn name, axis char);
ALTER EXTENSION postgis ADD FUNCTION _raster_constraint_info_blocksize (rastschema name, rasttable name, rastcolumn name, axis text);
ALTER EXTENSION postgis ADD FUNCTION _add_raster_constraint_blocksize (rastschema name, rasttable name, rastcolumn name, axis text);
ALTER EXTENSION postgis ADD FUNCTION _drop_raster_constraint_blocksize (rastschema name, rasttable name, rastcolumn name, axis text);
ALTER EXTENSION postgis ADD FUNCTION _raster_constraint_info_extent (rastschema name, rasttable name, rastcolumn name);
ALTER EXTENSION postgis ADD FUNCTION _add_raster_constraint_extent (rastschema name, rasttable name, rastcolumn name);
ALTER EXTENSION postgis ADD FUNCTION _drop_raster_constraint_extent (rastschema name, rasttable name, rastcolumn name);
ALTER EXTENSION postgis ADD FUNCTION _raster_constraint_info_alignment (rastschema name, rasttable name, rastcolumn name);
ALTER EXTENSION postgis ADD FUNCTION _add_raster_constraint_alignment (rastschema name, rasttable name, rastcolumn name);
ALTER EXTENSION postgis ADD FUNCTION _drop_raster_constraint_alignment (rastschema name, rasttable name, rastcolumn name);
ALTER EXTENSION postgis ADD FUNCTION _raster_constraint_info_spatially_unique (rastschema name, rasttable name, rastcolumn name);
ALTER EXTENSION postgis ADD FUNCTION _add_raster_constraint_spatially_unique (rastschema name, rasttable name, rastcolumn name);
ALTER EXTENSION postgis ADD FUNCTION _drop_raster_constraint_spatially_unique (rastschema name, rasttable name, rastcolumn name);
ALTER EXTENSION postgis ADD FUNCTION _raster_constraint_info_coverage_tile (rastschema name, rasttable name, rastcolumn name);
ALTER EXTENSION postgis ADD FUNCTION _add_raster_constraint_coverage_tile (rastschema name, rasttable name, rastcolumn name);
ALTER EXTENSION postgis ADD FUNCTION _drop_raster_constraint_coverage_tile (rastschema name, rasttable name, rastcolumn name);
ALTER EXTENSION postgis ADD FUNCTION _raster_constraint_info_regular_blocking (rastschema name, rasttable name, rastcolumn name);
ALTER EXTENSION postgis ADD FUNCTION _drop_raster_constraint_regular_blocking (rastschema name, rasttable name, rastcolumn name);
ALTER EXTENSION postgis ADD FUNCTION _raster_constraint_info_num_bands (rastschema name, rasttable name, rastcolumn name);
ALTER EXTENSION postgis ADD FUNCTION _add_raster_constraint_num_bands (rastschema name, rasttable name, rastcolumn name);
ALTER EXTENSION postgis ADD FUNCTION _drop_raster_constraint_num_bands (rastschema name, rasttable name, rastcolumn name);
ALTER EXTENSION postgis ADD FUNCTION _raster_constraint_info_pixel_types (rastschema name, rasttable name, rastcolumn name);
ALTER EXTENSION postgis ADD FUNCTION _raster_constraint_pixel_types (rast raster);
ALTER EXTENSION postgis ADD FUNCTION _add_raster_constraint_pixel_types (rastschema name, rasttable name, rastcolumn name);
ALTER EXTENSION postgis ADD FUNCTION _drop_raster_constraint_pixel_types (rastschema name, rasttable name, rastcolumn name);
ALTER EXTENSION postgis ADD FUNCTION _raster_constraint_info_nodata_values (rastschema name, rasttable name, rastcolumn name);
ALTER EXTENSION postgis ADD FUNCTION _raster_constraint_nodata_values (rast raster);
ALTER EXTENSION postgis ADD FUNCTION _add_raster_constraint_nodata_values (rastschema name, rasttable name, rastcolumn name);
ALTER EXTENSION postgis ADD FUNCTION _drop_raster_constraint_nodata_values (rastschema name, rasttable name, rastcolumn name);
ALTER EXTENSION postgis ADD FUNCTION _raster_constraint_info_out_db (rastschema name, rasttable name, rastcolumn name);
ALTER EXTENSION postgis ADD FUNCTION _raster_constraint_out_db (rast raster);
ALTER EXTENSION postgis ADD FUNCTION _add_raster_constraint_out_db (rastschema name, rasttable name, rastcolumn name);
ALTER EXTENSION postgis ADD FUNCTION _drop_raster_constraint_out_db (rastschema name, rasttable name, rastcolumn name);
ALTER EXTENSION postgis ADD FUNCTION _raster_constraint_info_index (rastschema name, rasttable name, rastcolumn name);
ALTER EXTENSION postgis ADD FUNCTION AddRasterConstraints  (
	rastschema name,
	rasttable name,
	rastcolumn name,
	VARIADIC constraints text[]
);
ALTER EXTENSION postgis ADD FUNCTION AddRasterConstraints  (
	rasttable name,
	rastcolumn name,
	VARIADIC constraints text[]
);
ALTER EXTENSION postgis ADD FUNCTION AddRasterConstraints  (
	rastschema name,
	rasttable name,
	rastcolumn name,
	srid boolean ,
	scale_x boolean ,
	scale_y boolean ,
	blocksize_x boolean ,
	blocksize_y boolean ,
	same_alignment boolean ,
	regular_blocking boolean , -- false as regular_blocking is an enhancement
	num_bands boolean ,
	pixel_types boolean ,
	nodata_values boolean ,
	out_db boolean ,
	extent boolean );
ALTER EXTENSION postgis ADD FUNCTION AddRasterConstraints  (
	rasttable name,
	rastcolumn name,
	srid boolean ,
	scale_x boolean ,
	scale_y boolean ,
	blocksize_x boolean ,
	blocksize_y boolean ,
	same_alignment boolean ,
	regular_blocking boolean , -- false as regular_blocking is an enhancement
	num_bands boolean ,
	pixel_types boolean ,
	nodata_values boolean ,
	out_db boolean ,
	extent boolean );
ALTER EXTENSION postgis ADD FUNCTION DropRasterConstraints  (
	rastschema name,
	rasttable name,
	rastcolumn name,
	VARIADIC constraints text[]
);
ALTER EXTENSION postgis ADD FUNCTION DropRasterConstraints  (
	rasttable name,
	rastcolumn name,
	VARIADIC constraints text[]
);
ALTER EXTENSION postgis ADD FUNCTION DropRasterConstraints  (
	rastschema name,
	rasttable name,
	rastcolumn name,
	srid boolean ,
	scale_x boolean ,
	scale_y boolean ,
	blocksize_x boolean ,
	blocksize_y boolean ,
	same_alignment boolean ,
	regular_blocking boolean ,
	num_bands boolean ,
	pixel_types boolean ,
	nodata_values boolean ,
	out_db boolean ,
	extent boolean );
ALTER EXTENSION postgis ADD FUNCTION DropRasterConstraints  (
	rasttable name,
	rastcolumn name,
	srid boolean ,
	scale_x boolean ,
	scale_y boolean ,
	blocksize_x boolean ,
	blocksize_y boolean ,
	same_alignment boolean ,
	regular_blocking boolean ,
	num_bands boolean ,
	pixel_types boolean ,
	nodata_values boolean ,
	out_db boolean ,
	extent boolean );
ALTER EXTENSION postgis ADD FUNCTION _overview_constraint (ov raster, factor integer, refschema name, reftable name, refcolumn name);
ALTER EXTENSION postgis ADD FUNCTION _overview_constraint_info (
	ovschema name, ovtable name, ovcolumn name,
	OUT refschema name, OUT reftable name, OUT refcolumn name, OUT factor integer
);
ALTER EXTENSION postgis ADD FUNCTION _add_overview_constraint (
	ovschema name, ovtable name, ovcolumn name,
	refschema name, reftable name, refcolumn name,
	factor integer
);
ALTER EXTENSION postgis ADD FUNCTION _drop_overview_constraint (ovschema name, ovtable name, ovcolumn name);
ALTER EXTENSION postgis ADD FUNCTION AddOverviewConstraints  (
	ovschema name, ovtable name, ovcolumn name,
	refschema name, reftable name, refcolumn name,
	ovfactor int
);
ALTER EXTENSION postgis ADD FUNCTION AddOverviewConstraints  (
	ovtable name, ovcolumn name,
	reftable name, refcolumn name,
	ovfactor int
);
ALTER EXTENSION postgis ADD FUNCTION DropOverviewConstraints  (
	ovschema name,
	ovtable name,
	ovcolumn name
);
ALTER EXTENSION postgis ADD FUNCTION DropOverviewConstraints  (
	ovtable name,
	ovcolumn name
);
ALTER EXTENSION postgis ADD FUNCTION _UpdateRasterSRID (
	schema_name name, table_name name, column_name name,
	new_srid integer
);
ALTER EXTENSION postgis ADD FUNCTION UpdateRasterSRID (
	schema_name name, table_name name, column_name name,
	new_srid integer
);
ALTER EXTENSION postgis ADD FUNCTION UpdateRasterSRID (
	table_name name, column_name name,
	new_srid integer
);
ALTER EXTENSION postgis ADD FUNCTION ST_Retile (tab regclass, col name, ext geometry, sfx float8, sfy float8, tw int, th int, algo text );
ALTER EXTENSION postgis ADD FUNCTION ST_CreateOverview (tab regclass, col name, factor int, algo text );
ALTER EXTENSION postgis ADD FUNCTION postgis_noop (raster);
-- Add all functions needed for types definition (needed?).
ALTER EXTENSION postgis ADD FUNCTION spheroid_in (cstring);
ALTER EXTENSION postgis ADD FUNCTION spheroid_out (spheroid);
ALTER EXTENSION postgis ADD FUNCTION geometry_in (cstring);
ALTER EXTENSION postgis ADD FUNCTION geometry_out (geometry);
ALTER EXTENSION postgis ADD FUNCTION geometry_typmod_in (cstring[]);
ALTER EXTENSION postgis ADD FUNCTION geometry_typmod_out (integer);
ALTER EXTENSION postgis ADD FUNCTION geometry_analyze (internal);
ALTER EXTENSION postgis ADD FUNCTION geometry_recv (internal);
ALTER EXTENSION postgis ADD FUNCTION geometry_send (geometry);
ALTER EXTENSION postgis ADD FUNCTION box3d_in (cstring);
ALTER EXTENSION postgis ADD FUNCTION box3d_out (box3d);
ALTER EXTENSION postgis ADD FUNCTION box2d_in (cstring);
ALTER EXTENSION postgis ADD FUNCTION box2d_out (box2d);
ALTER EXTENSION postgis ADD FUNCTION box2df_in (cstring);
ALTER EXTENSION postgis ADD FUNCTION box2df_out (box2df);
ALTER EXTENSION postgis ADD FUNCTION gidx_in (cstring);
ALTER EXTENSION postgis ADD FUNCTION gidx_out (gidx);
ALTER EXTENSION postgis ADD FUNCTION pgis_abs_in (cstring);
ALTER EXTENSION postgis ADD FUNCTION pgis_abs_out (pgis_abs);
ALTER EXTENSION postgis ADD FUNCTION geography_typmod_in (cstring[]);
ALTER EXTENSION postgis ADD FUNCTION geography_typmod_out (integer);
ALTER EXTENSION postgis ADD FUNCTION geography_in (cstring, oid, integer);
ALTER EXTENSION postgis ADD FUNCTION geography_out (geography);
ALTER EXTENSION postgis ADD FUNCTION geography_recv (internal, oid, integer);
ALTER EXTENSION postgis ADD FUNCTION geography_send (geography);
ALTER EXTENSION postgis ADD FUNCTION geography_analyze (internal);
ALTER EXTENSION postgis ADD FUNCTION raster_in (cstring);
ALTER EXTENSION postgis ADD FUNCTION raster_out (raster);
-- Register all types.
ALTER EXTENSION postgis ADD TYPE spheroid;
ALTER EXTENSION postgis ADD TYPE geometry;
ALTER EXTENSION postgis ADD TYPE box3d;
ALTER EXTENSION postgis ADD TYPE box2d;
ALTER EXTENSION postgis ADD TYPE box2df;
ALTER EXTENSION postgis ADD TYPE gidx;
ALTER EXTENSION postgis ADD TYPE geometry_dump;
ALTER EXTENSION postgis ADD TYPE valid_detail;
ALTER EXTENSION postgis ADD TYPE pgis_abs;
ALTER EXTENSION postgis ADD TYPE geography;
ALTER EXTENSION postgis ADD TYPE raster;
ALTER EXTENSION postgis ADD TYPE rastbandarg;
ALTER EXTENSION postgis ADD TYPE geomval;
ALTER EXTENSION postgis ADD TYPE addbandarg;
ALTER EXTENSION postgis ADD TYPE summarystats;
ALTER EXTENSION postgis ADD TYPE agg_count;
ALTER EXTENSION postgis ADD TYPE reclassarg;
ALTER EXTENSION postgis ADD TYPE agg_samealignment;
ALTER EXTENSION postgis ADD TYPE unionarg;

