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
-- Generated on: Sat Oct 15 16:17:40 2016
--           by: ../../utils/create_unpackaged.pl
--          for: postgis_sfcgal
--         from: -
-- 
-- Do not edit manually, your changes will be lost.
-- 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- complain if script is sourced in psql
\echo Use "CREATE EXTENSION postgis_sfcgal" to load this file. \quit

-- Register all views.
-- Register all tables.
-- Register all aggregates.
-- Register all operators classes and families.
-- Register all operators.
-- Register all casts.
-- Register all functions except 0 needed for type definition.
ALTER EXTENSION postgis_sfcgal ADD FUNCTION postgis_sfcgal_scripts_installed ();
ALTER EXTENSION postgis_sfcgal ADD FUNCTION postgis_sfcgal_version ();
ALTER EXTENSION postgis_sfcgal ADD FUNCTION ST_3DIntersection (geom1 geometry, geom2 geometry);
ALTER EXTENSION postgis_sfcgal ADD FUNCTION ST_3DDifference (geom1 geometry, geom2 geometry);
ALTER EXTENSION postgis_sfcgal ADD FUNCTION ST_3DUnion (geom1 geometry, geom2 geometry);
ALTER EXTENSION postgis_sfcgal ADD FUNCTION ST_Tesselate (geometry);
ALTER EXTENSION postgis_sfcgal ADD FUNCTION ST_3DArea (geometry);
ALTER EXTENSION postgis_sfcgal ADD FUNCTION ST_Extrude (geometry, float8, float8, float8);
ALTER EXTENSION postgis_sfcgal ADD FUNCTION ST_ForceLHR (geometry);
ALTER EXTENSION postgis_sfcgal ADD FUNCTION ST_Orientation (geometry);
ALTER EXTENSION postgis_sfcgal ADD FUNCTION ST_MinkowskiSum (geometry, geometry);
ALTER EXTENSION postgis_sfcgal ADD FUNCTION ST_StraightSkeleton (geometry);
ALTER EXTENSION postgis_sfcgal ADD FUNCTION ST_ApproximateMedialAxis (geometry);
ALTER EXTENSION postgis_sfcgal ADD FUNCTION ST_IsPlanar (geometry);
ALTER EXTENSION postgis_sfcgal ADD FUNCTION ST_Volume (geometry);
ALTER EXTENSION postgis_sfcgal ADD FUNCTION ST_MakeSolid (geometry);
ALTER EXTENSION postgis_sfcgal ADD FUNCTION ST_IsSolid (geometry);
-- Add all functions needed for types definition (needed?).
-- Register all types.

