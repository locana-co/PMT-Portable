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
--          for: postgis_topology
--         from: -
-- 
-- Do not edit manually, your changes will be lost.
-- 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- complain if script is sourced in psql
\echo Use "CREATE EXTENSION postgis_topology" to load this file. \quit

-- Register all views.
-- Register all tables.
ALTER EXTENSION postgis_topology ADD TABLE topology.layer;
ALTER EXTENSION postgis_topology ADD TABLE topology.topology;
-- Register all aggregates.
ALTER EXTENSION postgis_topology ADD AGGREGATE topology.TopoElementArray_agg (topology.TopoElement);
-- Register all operators classes and families.
-- Register all operators.
-- Register all casts.
ALTER EXTENSION postgis_topology ADD CAST (topology.TopoGeometry AS Geometry);
-- Register all functions except 0 needed for type definition.
ALTER EXTENSION postgis_topology ADD FUNCTION topology.LayerTrigger ();
ALTER EXTENSION postgis_topology ADD FUNCTION topology.RelationTrigger ();
ALTER EXTENSION postgis_topology ADD FUNCTION topology.AddTopoGeometryColumn (toponame varchar, schema varchar, tbl varchar, col varchar, ltype varchar, child integer);
ALTER EXTENSION postgis_topology ADD FUNCTION topology.AddTopoGeometryColumn (varchar, varchar, varchar, varchar, varchar);
ALTER EXTENSION postgis_topology ADD FUNCTION topology.DropTopoGeometryColumn (schema varchar, tbl varchar, col varchar);
ALTER EXTENSION postgis_topology ADD FUNCTION topology.CreateTopoGeom (toponame varchar, tg_type integer, layer_id integer, tg_objs topology.TopoElementArray);
ALTER EXTENSION postgis_topology ADD FUNCTION topology.CreateTopoGeom (toponame varchar, tg_type integer, layer_id integer);
ALTER EXTENSION postgis_topology ADD FUNCTION topology.GetTopologyName (topoid integer);
ALTER EXTENSION postgis_topology ADD FUNCTION topology.GetTopologyId (toponame varchar);
ALTER EXTENSION postgis_topology ADD FUNCTION topology.GetTopologySRID (toponame varchar);
ALTER EXTENSION postgis_topology ADD FUNCTION topology.GetTopoGeomElementArray (toponame varchar, layer_id integer, tgid integer);
ALTER EXTENSION postgis_topology ADD FUNCTION topology.GetTopoGeomElementArray (tg topology.TopoGeometry);
ALTER EXTENSION postgis_topology ADD FUNCTION topology.GetTopoGeomElements (toponame varchar, layerid integer, tgid integer);
ALTER EXTENSION postgis_topology ADD FUNCTION topology.GetTopoGeomElements (tg topology.TopoGeometry);
ALTER EXTENSION postgis_topology ADD FUNCTION topology.Geometry (topogeom topology.TopoGeometry);
ALTER EXTENSION postgis_topology ADD FUNCTION topology.ValidateTopology (toponame varchar);
ALTER EXTENSION postgis_topology ADD FUNCTION topology.CreateTopology (atopology varchar, srid integer, prec float8, hasZ boolean);
ALTER EXTENSION postgis_topology ADD FUNCTION topology.CreateTopology (toponame varchar, srid integer, prec float8);
ALTER EXTENSION postgis_topology ADD FUNCTION topology.CreateTopology (varchar, integer);
ALTER EXTENSION postgis_topology ADD FUNCTION topology.CreateTopology (varchar);
ALTER EXTENSION postgis_topology ADD FUNCTION topology.DropTopology (atopology varchar);
ALTER EXTENSION postgis_topology ADD FUNCTION topology.TopologySummary (atopology varchar);
ALTER EXTENSION postgis_topology ADD FUNCTION topology.CopyTopology (atopology varchar, newtopo varchar);
ALTER EXTENSION postgis_topology ADD FUNCTION topology.intersects (tg1 topology.TopoGeometry, tg2 topology.TopoGeometry);
ALTER EXTENSION postgis_topology ADD FUNCTION topology.equals (tg1 topology.TopoGeometry, tg2 topology.TopoGeometry);
ALTER EXTENSION postgis_topology ADD FUNCTION topology.GetNodeByPoint (atopology varchar, apoint geometry, tol1 float8);
ALTER EXTENSION postgis_topology ADD FUNCTION topology.GetEdgeByPoint (atopology varchar, apoint geometry, tol1 float8);
ALTER EXTENSION postgis_topology ADD FUNCTION topology.GetFaceByPoint (atopology varchar, apoint geometry, tol1 float8);
ALTER EXTENSION postgis_topology ADD FUNCTION topology._st_mintolerance (ageom Geometry);
ALTER EXTENSION postgis_topology ADD FUNCTION topology._st_mintolerance (atopology varchar, ageom Geometry);
ALTER EXTENSION postgis_topology ADD FUNCTION topology.AddNode (atopology varchar, apoint geometry, allowEdgeSplitting boolean, setContainingFace boolean );
ALTER EXTENSION postgis_topology ADD FUNCTION topology.AddNode (atopology varchar, apoint geometry);
ALTER EXTENSION postgis_topology ADD FUNCTION topology.AddEdge (atopology varchar, aline geometry);
ALTER EXTENSION postgis_topology ADD FUNCTION topology.AddFace (atopology varchar, apoly geometry, force_new boolean );
ALTER EXTENSION postgis_topology ADD FUNCTION topology.TopoGeo_AddPoint (atopology varchar, apoint geometry, tolerance float8 );
ALTER EXTENSION postgis_topology ADD FUNCTION topology.TopoGeo_addLinestring (atopology varchar, aline geometry, tolerance float8 );
ALTER EXTENSION postgis_topology ADD FUNCTION topology.TopoGeo_AddPolygon (atopology varchar, apoly geometry, tolerance float8 );
ALTER EXTENSION postgis_topology ADD FUNCTION topology.TopoGeo_AddGeometry (atopology varchar, ageom geometry, tolerance float8 );
ALTER EXTENSION postgis_topology ADD FUNCTION topology.polygonize (toponame varchar);
ALTER EXTENSION postgis_topology ADD FUNCTION topology.TopoElementArray_append (topology.TopoElementArray, topology.TopoElement);
ALTER EXTENSION postgis_topology ADD FUNCTION topology.GeometryType (tg topology.TopoGeometry);
ALTER EXTENSION postgis_topology ADD FUNCTION topology.ST_GeometryType (tg topology.TopoGeometry);
ALTER EXTENSION postgis_topology ADD FUNCTION topology.clearTopoGeom (tg topology.TopoGeometry);
ALTER EXTENSION postgis_topology ADD FUNCTION topology.ST_Simplify (tg topology.TopoGeometry, tolerance float8);
ALTER EXTENSION postgis_topology ADD FUNCTION topology.toTopoGeom (ageom Geometry, atopology varchar, alayer int, atolerance float8 );
ALTER EXTENSION postgis_topology ADD FUNCTION topology.toTopoGeom (ageom Geometry, tg topology.TopoGeometry, atolerance float8 );
ALTER EXTENSION postgis_topology ADD FUNCTION topology._AsGMLNode (id int, point geometry, nsprefix_in text, prec int, options int, idprefix text, gmlver int);
ALTER EXTENSION postgis_topology ADD FUNCTION topology._AsGMLEdge (edge_id int, start_node int,end_node int, line geometry, visitedTable regclass, nsprefix_in text, prec int, options int, idprefix text, gmlver int);
ALTER EXTENSION postgis_topology ADD FUNCTION topology._AsGMLFace (toponame text, face_id int, visitedTable regclass, nsprefix_in text, prec int, options int, idprefix text, gmlver int);
ALTER EXTENSION postgis_topology ADD FUNCTION topology.AsGML (tg topology.TopoGeometry, nsprefix_in text, precision_in int, options_in int, visitedTable regclass, idprefix text, gmlver int);
ALTER EXTENSION postgis_topology ADD FUNCTION topology.AsGML (tg topology.TopoGeometry,nsprefix text, prec int, options int, visitedTable regclass, idprefix text);
ALTER EXTENSION postgis_topology ADD FUNCTION topology.AsGML (tg topology.TopoGeometry, nsprefix text, prec int, options int, vis regclass);
ALTER EXTENSION postgis_topology ADD FUNCTION topology.AsGML (tg topology.TopoGeometry, nsprefix text, prec int, opts int);
ALTER EXTENSION postgis_topology ADD FUNCTION topology.AsGML (tg topology.TopoGeometry, nsprefix text);
ALTER EXTENSION postgis_topology ADD FUNCTION topology.AsGML (tg topology.TopoGeometry, visitedTable regclass);
ALTER EXTENSION postgis_topology ADD FUNCTION topology.AsGML (tg topology.TopoGeometry, visitedTable regclass, nsprefix text);
ALTER EXTENSION postgis_topology ADD FUNCTION topology.AsGML (tg topology.TopoGeometry);
ALTER EXTENSION postgis_topology ADD FUNCTION topology.AsTopoJSON (tg topology.TopoGeometry, edgeMapTable regclass);
ALTER EXTENSION postgis_topology ADD FUNCTION topology.ST_GetFaceEdges (toponame varchar, face_id integer);
ALTER EXTENSION postgis_topology ADD FUNCTION topology.ST_NewEdgeHeal (toponame varchar, e1id integer, e2id integer);
ALTER EXTENSION postgis_topology ADD FUNCTION topology.ST_ModEdgeHeal (toponame varchar, e1id integer, e2id integer);
ALTER EXTENSION postgis_topology ADD FUNCTION topology.ST_RemEdgeNewFace (toponame varchar, e1id integer);
ALTER EXTENSION postgis_topology ADD FUNCTION topology.ST_RemEdgeModFace (toponame varchar, e1id integer);
ALTER EXTENSION postgis_topology ADD FUNCTION topology.ST_GetFaceGeometry (toponame varchar, aface integer);
ALTER EXTENSION postgis_topology ADD FUNCTION topology.ST_AddIsoNode (atopology varchar, aface integer, apoint geometry);
ALTER EXTENSION postgis_topology ADD FUNCTION topology.ST_MoveIsoNode (atopology character varying, anode integer, apoint geometry);
ALTER EXTENSION postgis_topology ADD FUNCTION topology.ST_RemoveIsoNode (atopology varchar, anode integer);
ALTER EXTENSION postgis_topology ADD FUNCTION topology.ST_RemIsoNode (varchar, integer);
ALTER EXTENSION postgis_topology ADD FUNCTION topology.ST_RemoveIsoEdge (atopology varchar, anedge integer);
ALTER EXTENSION postgis_topology ADD FUNCTION topology.ST_NewEdgesSplit (atopology varchar, anedge integer, apoint geometry);
ALTER EXTENSION postgis_topology ADD FUNCTION topology.ST_ModEdgeSplit (atopology varchar, anedge integer, apoint geometry);
ALTER EXTENSION postgis_topology ADD FUNCTION topology.ST_AddIsoEdge (atopology varchar, anode integer, anothernode integer, acurve geometry);
ALTER EXTENSION postgis_topology ADD FUNCTION topology._ST_AdjacentEdges (atopology varchar, anode integer, anedge integer);
ALTER EXTENSION postgis_topology ADD FUNCTION topology.ST_ChangeEdgeGeom (atopology varchar, anedge integer, acurve geometry);
ALTER EXTENSION postgis_topology ADD FUNCTION topology._ST_AddFaceSplit (atopology varchar, anedge integer, oface integer, mbr_only bool);
ALTER EXTENSION postgis_topology ADD FUNCTION topology.ST_AddEdgeNewFaces (atopology varchar, anode integer, anothernode integer, acurve geometry);
ALTER EXTENSION postgis_topology ADD FUNCTION topology.ST_AddEdgeModFace (atopology varchar, anode integer, anothernode integer, acurve geometry);
ALTER EXTENSION postgis_topology ADD FUNCTION topology.ST_InitTopoGeo (atopology varchar);
ALTER EXTENSION postgis_topology ADD FUNCTION topology.ST_CreateTopoGeo (atopology varchar, acollection geometry);
ALTER EXTENSION postgis_topology ADD FUNCTION topology.GetRingEdges (atopology varchar, anedge int, maxedges int );
ALTER EXTENSION postgis_topology ADD FUNCTION topology.GetNodeEdges (atopology varchar, anode int);
ALTER EXTENSION postgis_topology ADD FUNCTION topology.AddToSearchPath (a_schema_name varchar);
ALTER EXTENSION postgis_topology ADD FUNCTION topology.postgis_topology_scripts_installed ();
-- Add all functions needed for types definition (needed?).
-- Register all types.
ALTER EXTENSION postgis_topology ADD TYPE topology.ValidateTopology_ReturnType;
ALTER EXTENSION postgis_topology ADD TYPE topology.TopoGeometry;
ALTER EXTENSION postgis_topology ADD TYPE topology.TopoElement;
ALTER EXTENSION postgis_topology ADD TYPE topology.TopoElementArray;
ALTER EXTENSION postgis_topology ADD TYPE topology.GetFaceEdges_ReturnType;

