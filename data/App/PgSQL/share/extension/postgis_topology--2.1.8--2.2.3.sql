-- complain if script is sourced in psql, rather than via CREATE EXTENSION
\echo Use "CREATE EXTENSION postgis_topology" to load this file. \quit
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
-- removes all postgis_topology functions from postgis_topology extension since they will be readded 
-- during upgrade
SELECT postgis_extension_remove_objects('postgis_topology', 'FUNCTION');
SELECT postgis_extension_remove_objects('postgis_topology', 'AGGREGATE');
-- PostGIS - Spatial Types for PostgreSQL
-- http://postgis.net
--
-- Copyright (C) 2012 Regina Obe <lr@pcorp.us>
-- This is free software; you can redistribute and/or modify it under
-- the terms of the GNU General Public Licence. See the COPYING file.
--
--  
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- These are functions where the argument names may have changed  --
-- so have to be dropped before upgrade can happen for 9.0+ --
-- argument names changed --
-- we might want to take toTopoGeom one out before release since
-- I don't think too many people installed the bad name
DROP FUNCTION IF EXISTS topology.toTopoGeom(Geometry, varchar, int, float8);

-- used to be in public, will now be moved to topology
DROP FUNCTION IF EXISTS postgis_topology_scripts_installed();

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- 
--
-- PostGIS - Spatial Types for PostgreSQL
-- http://postgis.net
--
-- Copyright (C) 2010, 2011 Sandro Santilli <strk@keybit.net>
-- Copyright (C) 2005 Refractions Research Inc.
--
-- This is free software; you can redistribute and/or modify it under
-- the terms of the GNU General Public Licence. See the COPYING file.
--
-- Author: Sandro Santilli <strk@keybit.net>
--  
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--
-- STATUS:
--
--  All objects are created in the 'topology' schema.
--
--  We have PostGIS-specific objects and SQL/MM objects.
--  PostGIS-specific objects have no prefix, SQL/MM ones
--  have the ``ST_' prefix.
--  
-- [PostGIS-specific]
--
-- TABLE topology
--  Table storing topology info (name, srid, precision)
--
-- TYPE TopoGeometry
--  Complex type storing topology_id, layer_id, geometry type
--  and topogeometry id.
--
-- DOMAIN TopoElement
--  An array of two elements: element_id and element_type.
--  In fact, an array of integers.
--
-- DOMAIN TopoElementArray
--  An array of element_id,element_type values.
--  In fact, a bidimensional array of integers:
--  '{{id,type}, {id,type}, ...}'
--
-- FUNCTION CreateTopology(name, [srid], [precision])
--  Initialize a new topology (creating schema with
--  edge,face,node,relation) and add a record into
--  the topology.topology table.
--  TODO: add triggers (or rules, or whatever) enforcing
--        precision to the edge and node tables.
--  
-- FUNCTION DropTopology(name)
--    Delete a topology removing reference from the
--    topology.topology table
--
-- FUNCTION GetTopologyId(name)
-- FUNCTION GetTopologySRID(name)
-- FUNCTION GetTopologyName(id)
--    Return info about a Topology
--
-- FUNCTION AddTopoGeometryColumn(toponame, schema, table, column, geomtype)
--    Add a TopoGeometry column to a table, making it a topology layer.
--    Returns created layer id.
--
-- FUNCTION DropTopoGeometryColumn(schema, table, column)
--    Drop a TopoGeometry column, unregister the associated layer,
--    cleanup the relation table.
--
-- FUNCTION CreateTopoGeom(toponame, geomtype, layer_id, topo_objects)
--    Create a TopoGeometry object from existing Topology elements.
--    The "topo_objects" parameter is of TopoElementArray type.
--
-- FUNCTION GetTopoGeomElementArray(toponame, layer_id, topogeom_id)
-- FUNCTION GetTopoGeomElementArray(TopoGeometry)
--    Returns a TopoElementArray object containing the topological
--    elements of the given TopoGeometry.
--
-- FUNCTION GetTopoGeomElements(toponame, layer_id, topogeom_id)
-- FUNCTION GetTopoGeomElements(TopoGeometry)
--    Returns a set of TopoElement objects containing the
--    topological elements of the given TopoGeometry (primitive
--    elements)
--
-- FUNCTION ValidateTopology(toponame)
--    Run validity checks on the topology, returning, for each
--    detected error, a 3-columns row containing error string
--    and references to involved topo elements: error, id1, id2
--
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--
-- Overloaded functions for TopoGeometry inputs
--
-- FUNCTION intersects(TopoGeometry, TopoGeometry)
-- FUNCTION equals(TopoGeometry, TopoGeometry)
--
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--
-- FUNCTION TopoGeo_AddPoint(toponame, point)
--    Add a Point geometry to the topology
--    TODO: accept a topology/layer id
--          rework to use existing node if existent
--
-- FUNCTION TopoGeo_AddLinestring(toponame, line)
--    Add a LineString geometry to the topology
--    TODO: accept a topology/layer id
--          rework to use existing nodes/edges
--          splitting them if required
--
-- FUNCTION TopoGeo_AddPolygon(toponame, polygon)
--    Add a Polygon geometry to the topology
--    TODO: implement
--
-- TYPE GetFaceEdges_ReturnType
--    Complex type used to return tuples from ST_GetFaceEdges
--
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--
-- [SQL/MM]
--
--   ST_InitTopoGeo
--    Done, can be modified to include explicit sequences or
--    more constraints. Very noisy due to implicit index creations
--    for primary keys and sequences for serial fields...
--  
--   ST_CreateTopoGeo
--    Complete
--  
--   ST_AddIsoNode
--    Complete
--  
--   ST_RemoveIsoNode
--    Complete
--  
--   ST_MoveIsoNode
--    Complete
--  
--   ST_AddIsoEdge
--    Complete
--
--   ST_RemoveIsoEdge
--    Complete, exceptions untested
--  
--   ST_ChangeEdgeGeom
--    Complete
--
--   ST_NewEdgesSplit
--    Complete
--    Also updates the Relation table
--
--   ST_ModEdgeSplit
--    Complete
--    Also updates the Relation table
--
--   ST_AddEdgeNewFaces
--    Complete
--    Also updates the Relation table
--
--   ST_AddEdgeModFace
--    Complete
--    Also updates the Relation table
--  
--   ST_GetFaceEdges
--    Complete
--
--   ST_ModEdgeHeal
--    Complete
--    Also updates the Relation table
--
--   ST_NewEdgeHeal
--    Complete
--    Also updates the Relation table
--  
--   ST_GetFaceGeometry
--    Implemented using ST_BuildArea()
--  
--   ST_RemEdgeNewFace
--    Complete
--    Also updates the Relation table
--  
--   ST_RemEdgeModFace
--    Complete
--    Also updates the Relation table
--  
--   ST_ValidateTopoGeo
--    Unimplemented (probably a wrapper around ValidateTopology)
--  
--  

-- Uninstalling previous installation isn't really a good habit ...
-- Let people decide about that
-- DROP SCHEMA topology CASCADE;















-- Doing everything outside of a transaction helps
-- upgrading in the best case.


--={ ----------------------------------------------------------------
--  POSTGIS-SPECIFIC block
--
--  This part contains function NOT in the SQL/MM specification
--
---------------------------------------------------------------------

--
-- Topology table.
-- Stores id,name,precision and SRID of topologies.
--


--{ LayerTrigger()
--
-- Layer integrity trigger
--
CREATE OR REPLACE FUNCTION topology.LayerTrigger()
  RETURNS trigger
AS
$$
DECLARE
  rec RECORD;
  ok BOOL;
  toponame varchar;
  query TEXT;
BEGIN

  --RAISE NOTICE 'LayerTrigger called % % at % level', TG_WHEN, TG_OP, TG_LEVEL;


  IF TG_OP = 'INSERT' THEN
    RAISE EXCEPTION 'LayerTrigger not meant to be called on INSERT';
  ELSIF TG_OP = 'UPDATE' THEN
    RAISE EXCEPTION 'The topology.layer table cannot be updated';
  END IF;


  -- Check for existance of any feature column referencing
  -- this layer
  FOR rec IN SELECT * FROM pg_namespace n, pg_class c, pg_attribute a
    WHERE text(n.nspname) = OLD.schema_name
    AND c.relnamespace = n.oid
    AND text(c.relname) = OLD.table_name
    AND a.attrelid = c.oid
    AND text(a.attname) = OLD.feature_column
  LOOP
    query = 'SELECT * '
         ' FROM ' || quote_ident(OLD.schema_name)
      || '.' || quote_ident(OLD.table_name)
      || ' WHERE layer_id('
      || quote_ident(OLD.feature_column)||') '
         '=' || OLD.layer_id
      || ' LIMIT 1';
    --RAISE NOTICE '%', query;
    FOR rec IN EXECUTE query
    LOOP
      RAISE NOTICE 'A feature referencing layer % of topology % still exists in %.%.%', OLD.layer_id, OLD.topology_id, OLD.schema_name, OLD.table_name, OLD.feature_column;
      RETURN NULL;
    END LOOP;
  END LOOP;


  -- Get topology name
  SELECT name FROM topology.topology INTO toponame
    WHERE id = OLD.topology_id;

  IF toponame IS NULL THEN
    RAISE NOTICE 'Could not find name of topology with id %',
      OLD.layer_id;
  END IF;

  -- Check if any record in the relation table references this layer
  FOR rec IN SELECT c.oid FROM pg_namespace n, pg_class c
    WHERE text(n.nspname) = toponame AND c.relnamespace = n.oid
          AND c.relname = 'relation'
  LOOP
    query = 'SELECT * '
         ' FROM ' || quote_ident(toponame)
      || '.relation '
         ' WHERE layer_id = '|| OLD.layer_id
      || ' LIMIT 1';
    --RAISE NOTICE '%', query;
    FOR rec IN EXECUTE query
    LOOP
      RAISE NOTICE 'A record in %.relation still references layer %', toponame, OLD.layer_id;
      RETURN NULL;
    END LOOP;
  END LOOP;

  RETURN OLD;
END;
$$
LANGUAGE 'plpgsql' VOLATILE STRICT;
--} LayerTrigger()


--{
-- Layer table.
-- Stores topology layer informations
--




--} Layer table.

--
-- Type returned by ValidateTopology 
--


--
-- TopoGeometry type
--


--
-- TopoElement domain
-- 
-- This is an array of two elements: element_id and element_type.
--
-- When used to define _simple_ TopoGeometries,
-- element_type can be:
--  0: a node
--  1: an edge
--  2: a face
-- and element_id will be the node, edge or face identifier
--
-- When used to define _hierarchical_ TopoGeometries,
-- element_type will be the child layer identifier and
-- element_id will be composing TopoGoemetry identifier
--





--
-- TopoElementArray domain
--


--{ RelationTrigger()
--
-- Relation integrity trigger
--
CREATE OR REPLACE FUNCTION topology.RelationTrigger()
  RETURNS trigger
AS
$$
DECLARE
  toponame varchar;
  topoid integer;
  plyr RECORD; -- parent layer
  rec RECORD;
  ok BOOL;

BEGIN
  IF TG_NARGS != 2 THEN
    RAISE EXCEPTION 'RelationTrigger called with wrong number of arguments';
  END IF;

  topoid = TG_ARGV[0];
  toponame = TG_ARGV[1];

  --RAISE NOTICE 'RelationTrigger called % % on %.relation for a %', TG_WHEN, TG_OP, toponame, TG_LEVEL;


  IF TG_OP = 'DELETE' THEN
    RAISE EXCEPTION 'RelationTrigger not meant to be called on DELETE';
  END IF;

  -- Get layer info (and verify it exists)
  ok = false;
  FOR plyr IN EXECUTE 'SELECT * FROM topology.layer '
       'WHERE '
       ' topology_id = ' || topoid
    || ' AND'
       ' layer_id = ' || NEW.layer_id
  LOOP
    ok = true;
    EXIT;
  END LOOP;
  IF NOT ok THEN
    RAISE EXCEPTION 'Layer % does not exist in topology %',
      NEW.layer_id, topoid;
    RETURN NULL;
  END IF;

  IF plyr.level > 0 THEN -- this is hierarchical layer

    -- ElementType must be the layer child id
    IF NEW.element_type != plyr.child_id THEN
      RAISE EXCEPTION 'Type of elements in layer % must be set to its child layer id %', plyr.layer_id, plyr.child_id;
      RETURN NULL;
    END IF;

    -- ElementId must be an existent TopoGeometry in child layer
    ok = false;
    FOR rec IN EXECUTE 'SELECT topogeo_id FROM '
      || quote_ident(toponame) || '.relation '
         ' WHERE layer_id = ' || plyr.child_id
      || ' AND topogeo_id = ' || NEW.element_id
    LOOP
      ok = true;
      EXIT;
    END LOOP;
    IF NOT ok THEN
      RAISE EXCEPTION 'TopoGeometry % does not exist in the child layer %', NEW.element_id, plyr.child_id;
      RETURN NULL;
    END IF;

  ELSE -- this is a basic layer

    -- ElementType must be compatible with layer type
    IF plyr.feature_type != 4
      AND plyr.feature_type != NEW.element_type
    THEN
      RAISE EXCEPTION 'Element of type % is not compatible with layer of type %', NEW.element_type, plyr.feature_type;
      RETURN NULL;
    END IF;

    --
    -- Now lets see if the element is consistent, which
    -- is it exists in the topology tables.
    --

    --
    -- Element is a Node
    --
    IF NEW.element_type = 1 
    THEN
      ok = false;
      FOR rec IN EXECUTE 'SELECT node_id FROM '
        || quote_ident(toponame) || '.node '
           ' WHERE node_id = ' || NEW.element_id
      LOOP
        ok = true;
        EXIT;
      END LOOP;
      IF NOT ok THEN
        RAISE EXCEPTION 'Node % does not exist in topology %', NEW.element_id, toponame;
        RETURN NULL;
      END IF;

    --
    -- Element is an Edge
    --
    ELSIF NEW.element_type = 2 
    THEN
      ok = false;
      FOR rec IN EXECUTE 'SELECT edge_id FROM '
        || quote_ident(toponame) || '.edge_data '
           ' WHERE edge_id = ' || abs(NEW.element_id)
      LOOP
        ok = true;
        EXIT;
      END LOOP;
      IF NOT ok THEN
        RAISE EXCEPTION 'Edge % does not exist in topology %', NEW.element_id, toponame;
        RETURN NULL;
      END IF;

    --
    -- Element is a Face
    --
    ELSIF NEW.element_type = 3 
    THEN
      IF NEW.element_id = 0 THEN
        RAISE EXCEPTION 'Face % cannot be associated with any feature', NEW.element_id;
        RETURN NULL;
      END IF;
      ok = false;
      FOR rec IN EXECUTE 'SELECT face_id FROM '
        || quote_ident(toponame) || '.face '
           ' WHERE face_id = ' || NEW.element_id
      LOOP
        ok = true;
        EXIT;
      END LOOP;
      IF NOT ok THEN
        RAISE EXCEPTION 'Face % does not exist in topology %', NEW.element_id, toponame;
        RETURN NULL;
      END IF;
    END IF;

  END IF;
  
  RETURN NEW;
END;
$$
LANGUAGE 'plpgsql' VOLATILE STRICT;
--} RelationTrigger()

--{
--  AddTopoGeometryColumn(toponame, schema, table, colum, type, [child])
--
--  Add a TopoGeometry column to a table, making it a topology layer.
--  Returns created layer id.
--
--
CREATE OR REPLACE FUNCTION topology.AddTopoGeometryColumn(toponame varchar, schema varchar, tbl varchar, col varchar, ltype varchar, child integer)
  RETURNS integer
AS
$$
DECLARE
  intltype integer;
  newlevel integer;
  topoid integer;
  rec RECORD;
  newlayer_id integer;
  query text;
BEGIN

  -- Get topology id
  SELECT id INTO topoid
    FROM topology.topology WHERE name = toponame;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Topology % does not exist', quote_literal(toponame);
  END IF;

  IF ltype ILIKE '%POINT%' OR ltype ILIKE 'PUNTAL' THEN
    intltype = 1;
  ELSIF ltype ILIKE '%LINE%' OR ltype ILIKE 'LINEAL' THEN
    intltype = 2;
  ELSIF ltype ILIKE '%POLYGON%' OR ltype ILIKE 'AREAL' THEN
    intltype = 3;
  ELSIF ltype ILIKE '%COLLECTION%' OR ltype ILIKE 'GEOMETRY' THEN
    intltype = 4;
  ELSE
    RAISE EXCEPTION 'Layer type must be one of POINT,LINE,POLYGON,COLLECTION';
  END IF;

  --
  -- Add new TopoGeometry column in schema.table
  --
  EXECUTE 'ALTER TABLE ' || quote_ident(schema)
    || '.' || quote_ident(tbl) 
    || ' ADD COLUMN ' || quote_ident(col)
    || ' topology.TopoGeometry;';


  --
  -- See if child id exists and extract its level
  --
  IF child IS NOT NULL THEN
    SELECT level + 1 FROM topology.layer
      WHERE layer_id = child
        AND topology_id = topoid
      INTO newlevel;
    IF newlevel IS NULL THEN
      RAISE EXCEPTION 'Child layer % does not exist in topology "%"', child, toponame;
    END IF;
  END IF;

  --
  -- Get new layer id from sequence
  --
  EXECUTE 'SELECT nextval(' ||
    quote_literal(
      quote_ident(toponame) || '.layer_id_seq'
    ) || ')' INTO STRICT newlayer_id;

  EXECUTE 'INSERT INTO ' 
       'topology.layer(topology_id, '
       'layer_id, level, child_id, schema_name, '
       'table_name, feature_column, feature_type) '
       'VALUES ('
    || topoid || ','
    || newlayer_id || ',' || COALESCE(newlevel, 0) || ','
    || COALESCE(child::text, 'NULL') || ','
    || quote_literal(schema) || ','
    || quote_literal(tbl) || ','
    || quote_literal(col) || ','
    || intltype || ');';


  --
  -- Create a sequence for TopoGeometries in this new layer
  --
  EXECUTE 'CREATE SEQUENCE ' || quote_ident(toponame)
    || '.topogeo_s_' || newlayer_id;

  --
  -- Add constraints on TopoGeom column
  --
  EXECUTE 'ALTER TABLE ' || quote_ident(schema)
    || '.' || quote_ident(tbl) 
    || ' ADD CONSTRAINT "check_topogeom_' || col || '" CHECK ('
       'topology_id(' || quote_ident(col) || ') = ' || topoid
    || ' AND '
       'layer_id(' || quote_ident(col) || ') = ' || newlayer_id
    || ' AND '
       'type(' || quote_ident(col) || ') = ' || intltype
    || ');';

  --
  -- Add dependency of the feature column on the topology schema
  --
  query = 'INSERT INTO pg_catalog.pg_depend SELECT '
       'fcat.oid, fobj.oid, fsub.attnum, tcat.oid, '
       'tobj.oid, 0, ''n'' '
       'FROM pg_class fcat, pg_namespace fnsp, '
       ' pg_class fobj, pg_attribute fsub, '
       ' pg_class tcat, pg_namespace tobj '
       ' WHERE fcat.relname = ''pg_class'' '
       ' AND fnsp.nspname = ' || quote_literal(schema)
    || ' AND fobj.relnamespace = fnsp.oid '
       ' AND fobj.relname = ' || quote_literal(tbl)
    || ' AND fsub.attrelid = fobj.oid '
       ' AND fsub.attname = ' || quote_literal(col)
    || ' AND tcat.relname = ''pg_namespace'' '
       ' AND tobj.nspname = ' || quote_literal(toponame);

--
-- The only reason to add this dependency is to avoid
-- simple drop of a feature column. Still, drop cascade
-- will remove both the feature column and the sequence
-- corrupting the topology anyway ...
--

  RETURN newlayer_id;
END;
$$
LANGUAGE 'plpgsql' VOLATILE;
--}{ AddTopoGeometryColumn

CREATE OR REPLACE FUNCTION topology.AddTopoGeometryColumn(varchar, varchar, varchar, varchar, varchar)
  RETURNS integer
AS
$$
  SELECT topology.AddTopoGeometryColumn($1, $2, $3, $4, $5, NULL);
$$
LANGUAGE 'sql' VOLATILE;

--
--} AddTopoGeometryColumn

--{
--  DropTopoGeometryColumn(schema, table, colum)
--
--  Drop a TopoGeometry column, unregister the associated layer,
--  cleanup the relation table.
--
--
CREATE OR REPLACE FUNCTION topology.DropTopoGeometryColumn(schema varchar, tbl varchar, col varchar)
  RETURNS text
AS
$$
DECLARE
  rec RECORD;
  lyrinfo RECORD;
  ok BOOL;
  result text;
BEGIN

        -- Get layer and topology info
  ok = false;
  FOR rec IN EXECUTE 'SELECT t.name as toponame, l.* FROM '
       'topology.topology t, topology.layer l '
       ' WHERE l.topology_id = t.id'
       ' AND l.schema_name = ' || quote_literal(schema)
    || ' AND l.table_name = ' || quote_literal(tbl)
    || ' AND l.feature_column = ' || quote_literal(col)
  LOOP
    ok = true;
    lyrinfo = rec;
  END LOOP;

  -- Layer not found
  IF NOT ok THEN
    RAISE EXCEPTION 'No layer registered on %.%.%',
      schema,tbl,col;
  END IF;
    
  -- Clean up the topology schema
  BEGIN
    -- Cleanup the relation table
    EXECUTE 'DELETE FROM ' || quote_ident(lyrinfo.toponame)
      || '.relation '
         ' WHERE '
         'layer_id = ' || lyrinfo.layer_id;

    -- Drop the sequence for topogeoms in this layer
    EXECUTE 'DROP SEQUENCE ' || quote_ident(lyrinfo.toponame)
      || '.topogeo_s_' || lyrinfo.layer_id;
  EXCEPTION
    WHEN UNDEFINED_TABLE THEN
      RAISE NOTICE '%', SQLERRM;
    WHEN OTHERS THEN
      RAISE EXCEPTION 'Got % (%)', SQLERRM, SQLSTATE;
  END;

  ok = false;
  FOR rec IN SELECT * FROM pg_namespace n, pg_class c, pg_attribute a
    WHERE text(n.nspname) = schema
    AND c.relnamespace = n.oid
    AND text(c.relname) = tbl
    AND a.attrelid = c.oid
    AND text(a.attname) = col
  LOOP
    ok = true;
    EXIT;
  END LOOP;


  IF ok THEN
    -- Set feature column to NULL to bypass referential integrity
    -- checks
    EXECUTE 'UPDATE ' || quote_ident(schema) || '.'
      || quote_ident(tbl)
      || ' SET ' || quote_ident(col)
      || ' = NULL';
  END IF;

  -- Delete the layer record
  EXECUTE 'DELETE FROM topology.layer '
       ' WHERE topology_id = ' || lyrinfo.topology_id
    || ' AND layer_id = ' || lyrinfo.layer_id;

  IF ok THEN
    -- Drop the layer column
    EXECUTE 'ALTER TABLE ' || quote_ident(schema) || '.'
      || quote_ident(tbl)
      || ' DROP ' || quote_ident(col)
      || ' cascade';
  END IF;

  result = 'Layer ' || lyrinfo.layer_id || ' ('
    || schema || '.' || tbl || '.' || col
    || ') dropped';

  RETURN result;
END;
$$
LANGUAGE 'plpgsql' VOLATILE;
--
--} DropTopoGeometryColumn


--{
-- CreateTopoGeom(topology_name, topogeom_type, layer_id, elements)
--
-- Create a TopoGeometry object from Topology elements.
-- The elements parameter is a two-dimensional array. 
-- Every element of the array is either a Topology element represented by
-- (id, type) or a TopoGeometry element represented by (id, layer).
-- The actual semantic depends on the TopoGeometry layer, either at
-- level 0 (elements are topological primitives) or higer (elements
-- are TopoGeoms from child layer).
-- 
-- @param toponame Topology name
--
-- @param tg_type Spatial type of geometry
--          1:[multi]point (puntal)
--          2:[multi]line  (lineal)
--          3:[multi]poly  (areal)
--          4:collection   (mixed)
--
-- @param layer_id Layer identifier
--
-- @param tg_objs Array of components
-- 
-- Return a topology.TopoGeometry object.
--
CREATE OR REPLACE FUNCTION topology.CreateTopoGeom(toponame varchar, tg_type integer, layer_id integer, tg_objs topology.TopoElementArray)
  RETURNS topology.TopoGeometry
AS
$$
DECLARE
  i integer;
  dims varchar;
  outerdims varchar;
  innerdims varchar;
  obj_type integer;
  obj_id integer;
  ret topology.TopoGeometry;
  rec RECORD;
  layertype integer;
  layerlevel integer;
  layerchild integer;
BEGIN

  IF tg_type < 1 OR tg_type > 4 THEN
    RAISE EXCEPTION 'Invalid TopoGeometry type % (must be in the range 1..4)', tg_type;
  END IF;

  -- Get topology id into return TopoGeometry
  SELECT id INTO ret.topology_id
    FROM topology.topology WHERE name = toponame;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Topology % does not exist', quote_literal(toponame);
  END IF;

  --
  -- Get layer info
  --
  layertype := NULL;
  FOR rec IN EXECUTE 'SELECT * FROM topology.layer'
       ' WHERE topology_id = ' || ret.topology_id
    || ' AND layer_id = ' || layer_id
  LOOP
    layertype = rec.feature_type;
    layerlevel = rec.level;
    layerchild = rec.child_id;
  END LOOP;

  -- Check for existence of given layer id
  IF layertype IS NULL THEN
    RAISE EXCEPTION 'No layer with id % is registered with topology %', layer_id, toponame;
  END IF;

  -- Verify compatibility between layer geometry type and
  -- TopoGeom requested geometry type
  IF layertype != 4 and layertype != tg_type THEN
    RAISE EXCEPTION 'A Layer of type % cannot contain a TopoGeometry of type %', layertype, tg_type;
  END IF;

  -- Set layer id and type in return object
  ret.layer_id = layer_id;
  ret.type = tg_type;

  --
  -- Get new TopoGeo id from sequence
  --
  FOR rec IN EXECUTE 'SELECT nextval(' ||
    quote_literal(
      quote_ident(toponame) || '.topogeo_s_' || layer_id
    ) || ')'
  LOOP
    ret.id = rec.nextval;
  END LOOP;

  -- Loop over outer dimension
  i = array_lower(tg_objs, 1);
  LOOP
    obj_id = tg_objs[i][1];
    obj_type = tg_objs[i][2];

    -- Elements of type 0 represent emptiness, just skip them
    IF obj_type = 0 THEN
      IF obj_id != 0 THEN
        RAISE EXCEPTION 'Malformed empty topo element {0,%} -- id must be 0 as well', obj_id;
      END IF;
    ELSE
      IF layerlevel = 0 THEN -- array specifies lower-level objects
        IF tg_type != 4 and tg_type != obj_type THEN
          RAISE EXCEPTION 'A TopoGeometry of type % cannot contain topology elements of type %', tg_type, obj_type;
        END IF;
      ELSE -- array specifies lower-level topogeometries
        IF obj_type != layerchild THEN
          RAISE EXCEPTION 'TopoGeom element layer do not match TopoGeom child layer';
        END IF;
        -- TODO: verify that the referred TopoGeometry really
        -- exists in the relation table ?
      END IF;

      --RAISE NOTICE 'obj:% type:% id:%', i, obj_type, obj_id;

      --
      -- Insert record into the Relation table
      --
      EXECUTE 'INSERT INTO '||quote_ident(toponame)
        || '.relation(topogeo_id, layer_id, '
           'element_id,element_type) '
           ' VALUES ('||ret.id
        ||','||ret.layer_id
        || ',' || obj_id || ',' || obj_type || ');';
    END IF;

    i = i+1;
    IF i > array_upper(tg_objs, 1) THEN
      EXIT;
    END IF;
  END LOOP;

  RETURN ret;

END
$$
LANGUAGE 'plpgsql' VOLATILE STRICT;
--} CreateTopoGeom(toponame,topogeom_type, layer_id, TopoElementArray)

--{
-- CreateTopoGeom(topology_name, topogeom_type, layer_id) - creates the empty topogeom
CREATE OR REPLACE FUNCTION topology.CreateTopoGeom(toponame varchar, tg_type integer, layer_id integer)
  RETURNS topology.TopoGeometry
AS
$$
  SELECT topology.CreateTopoGeom($1,$2,$3,'{{0,0}}');
$$ LANGUAGE 'sql' VOLATILE STRICT;
--} CreateTopoGeom(toponame, topogeom_type, layer_id)

--{
-- GetTopologyName(topology_id)
--
-- TODO: rewrite in SQL ?
--
CREATE OR REPLACE FUNCTION topology.GetTopologyName(topoid integer)
  RETURNS varchar
AS
$$
DECLARE
  ret varchar;
BEGIN
        SELECT name FROM topology.topology into ret
                WHERE id = topoid;
  RETURN ret;
END
$$
LANGUAGE 'plpgsql' STABLE STRICT;
--} GetTopologyName(topoid)

--{
-- GetTopologyId(toponame)
--
-- TODO: rewrite in SQL ?
--
CREATE OR REPLACE FUNCTION topology.GetTopologyId(toponame varchar)
  RETURNS integer
AS
$$
DECLARE
  ret integer;
BEGIN
  SELECT id INTO ret
    FROM topology.topology WHERE name = toponame;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Topology % does not exist', quote_literal(toponame);
  END IF;

  RETURN ret;
END
$$
LANGUAGE 'plpgsql' STABLE STRICT;
--} GetTopologyId(toponame)

--{
-- GetTopologySRID(toponame)
--
CREATE OR REPLACE FUNCTION topology.GetTopologySRID(toponame varchar)
  RETURNS integer
AS $$
  SELECT SRID FROM topology.topology WHERE name = $1;
$$ LANGUAGE 'sql' STABLE STRICT;
--} GetTopologySRID(toponame)
  


--{
-- GetTopoGeomElementArray(toponame, layer_id, topogeom_id)
-- GetTopoGeomElementArray(TopoGeometry)
--
-- Returns a set of element_id,element_type
--
CREATE OR REPLACE FUNCTION topology.GetTopoGeomElementArray(toponame varchar, layer_id integer, tgid integer)
  RETURNS topology.TopoElementArray
AS
$$
DECLARE
  rec RECORD;
  tg_objs varchar := '{';
  i integer;
  query text;
BEGIN

  query = 'SELECT * FROM topology.GetTopoGeomElements('
    || quote_literal(toponame) || ','
    || quote_literal(layer_id) || ','
    || quote_literal(tgid)
    || ') as obj ORDER BY obj';


  -- TODO: why not using array_agg here ?

  i = 1;
  FOR rec IN EXECUTE query
  LOOP
    IF i > 1 THEN
      tg_objs = tg_objs || ',';
    END IF;
    tg_objs = tg_objs || '{'
      || rec.obj[1] || ',' || rec.obj[2]
      || '}';
    i = i+1;
  END LOOP;

  tg_objs = tg_objs || '}';

  RETURN tg_objs;
END;
$$
LANGUAGE 'plpgsql' STABLE STRICT;

CREATE OR REPLACE FUNCTION topology.GetTopoGeomElementArray(tg topology.TopoGeometry)
  RETURNS topology.TopoElementArray
AS
$$
DECLARE
  toponame varchar;
BEGIN
  toponame = topology.GetTopologyName(tg.topology_id);
  RETURN topology.GetTopoGeomElementArray(toponame, tg.layer_id, tg.id);
END;
$$
LANGUAGE 'plpgsql' STABLE STRICT;

--} GetTopoGeomElementArray()

--{
-- GetTopoGeomElements(toponame, layer_id, topogeom_id)
-- GetTopoGeomElements(TopoGeometry)
--
-- Returns a set of element_id,element_type
--
CREATE OR REPLACE FUNCTION topology.GetTopoGeomElements(toponame varchar, layerid integer, tgid integer)
  RETURNS SETOF topology.TopoElement
AS
$$
DECLARE
  ret topology.TopoElement;
  rec RECORD;
  rec2 RECORD;
  query text;
  query2 text;
  lyr RECORD;
  ok bool;
  topoid INTEGER;
BEGIN

  -- Get topology id
  SELECT id INTO topoid
    FROM topology.topology WHERE name = toponame;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Topology % does not exist', quote_literal(toponame);
  END IF;

  -- Get layer info
  ok = false;
  FOR rec IN EXECUTE 'SELECT * FROM topology.layer '
       ' WHERE layer_id = $1 AND topology_id = $2'
       USING layerid, topoid
  LOOP
    lyr = rec;
    ok = true;
  END LOOP;

  IF NOT ok THEN
    RAISE EXCEPTION 'Layer % does not exist', layerid;
  END IF;


  query = 'SELECT abs(element_id) as element_id, element_type FROM '
    || quote_ident(toponame) || '.relation WHERE '
       ' layer_id = ' || layerid
    || ' AND topogeo_id = ' || quote_literal(tgid)
    || ' ORDER BY element_type, element_id';

  --RAISE NOTICE 'Query: %', query;

  FOR rec IN EXECUTE query
  LOOP
    IF lyr.level > 0 THEN
      query2 = 'SELECT * from topology.GetTopoGeomElements('
        || quote_literal(toponame) || ','
        || rec.element_type
        || ','
        || rec.element_id
        || ') as ret;';
      --RAISE NOTICE 'Query2: %', query2;
      FOR rec2 IN EXECUTE query2
      LOOP
        RETURN NEXT rec2.ret;
      END LOOP;
    ELSE
      ret = '{' || rec.element_id || ',' || rec.element_type || '}';
      RETURN NEXT ret;
    END IF;
  
  END LOOP;

  RETURN;
END;
$$
LANGUAGE 'plpgsql' STABLE STRICT;

CREATE OR REPLACE FUNCTION topology.GetTopoGeomElements(tg topology.TopoGeometry)
  RETURNS SETOF topology.TopoElement
AS
$$
DECLARE
  toponame varchar;
  rec RECORD;
BEGIN
  toponame = topology.GetTopologyName(tg.topology_id);
  FOR rec IN SELECT * FROM topology.GetTopoGeomElements(toponame,
    tg.layer_id,tg.id) as ret
  LOOP
    RETURN NEXT rec.ret;
  END LOOP;
  RETURN;
END;
$$
LANGUAGE 'plpgsql' STABLE STRICT;

--} GetTopoGeomElements()

--{
-- Geometry(TopoGeometry)
--
-- Construct a Geometry from a TopoGeometry.
-- 
-- }{
CREATE OR REPLACE FUNCTION topology.Geometry(topogeom topology.TopoGeometry)
  RETURNS Geometry
AS $$
DECLARE
  toponame varchar;
  geom geometry;
  rec RECORD;
  plyr RECORD;
  clyr RECORD;
  sql TEXT;
BEGIN

  -- Get topology name
  SELECT name FROM topology.topology
  WHERE id = topogeom.topology_id
  INTO toponame;
  IF toponame IS NULL THEN
    RAISE EXCEPTION 'Invalid TopoGeometry (unexistent topology id %)', topogeom.topology_id;
  END IF;

  -- Get layer info
  SELECT * FROM topology.layer
    WHERE topology_id = topogeom.topology_id
    AND layer_id = topogeom.layer_id
    INTO plyr;
  IF plyr IS NULL THEN
    RAISE EXCEPTION 'Could not find TopoGeometry layer % in topology %', topogeom.layer_id, topogeom.topology_id;
  END IF;

  --
  -- If this feature layer is on any level > 0 we will
  -- compute the topological union of all child features
  -- in fact recursing.
  --
  IF plyr.level > 0 THEN -- {

    -- Get child layer info
    SELECT * FROM topology.layer WHERE layer_id = plyr.child_id
      AND topology_id = topogeom.topology_id
      INTO clyr;
    IF clyr IS NULL THEN
      RAISE EXCEPTION 'Invalid layer % in topology % (unexistent child layer %)', topogeom.layer_id, topogeom.topology_id, plyr.child_id;
    END IF;

    sql := 'SELECT st_multi(st_union(topology.Geometry('
      || quote_ident(clyr.feature_column)
      || '))) as geom FROM '
      || quote_ident(clyr.schema_name) || '.'
      || quote_ident(clyr.table_name)
      || ', ' || quote_ident(toponame) || '.relation pr'
         ' WHERE '
         ' pr.topogeo_id = ' || topogeom.id
      || ' AND '
         ' pr.layer_id = ' || topogeom.layer_id
      || ' AND '
         ' id('||quote_ident(clyr.feature_column)
      || ') = pr.element_id '
         ' AND '
         'layer_id('||quote_ident(clyr.feature_column)
      || ') = pr.element_type ';
    --RAISE DEBUG '%', query;
    EXECUTE sql INTO geom;
      
  ELSIF topogeom.type = 3 THEN -- [multi]polygon -- }{

    sql := 'SELECT st_multi(st_union('
         'topology.ST_GetFaceGeometry('
      || quote_literal(toponame) || ','
      || 'element_id))) as g FROM ' 
      || quote_ident(toponame)
      || '.relation WHERE topogeo_id = '
      || topogeom.id || ' AND layer_id = '
      || topogeom.layer_id || ' AND element_type = 3 ';
    EXECUTE sql INTO geom;

  ELSIF topogeom.type = 2 THEN -- [multi]line -- }{

    sql := 
      'SELECT st_multi(ST_LineMerge(ST_Collect(e.geom))) as g FROM '
      || quote_ident(toponame) || '.edge e, '
      || quote_ident(toponame) || '.relation r '
         ' WHERE r.topogeo_id = ' || topogeom.id
      || ' AND r.layer_id = ' || topogeom.layer_id
      || ' AND r.element_type = 2 '
         ' AND abs(r.element_id) = e.edge_id';
    EXECUTE sql INTO geom;
  
  ELSIF topogeom.type = 1 THEN -- [multi]point -- }{

    sql :=
      'SELECT st_multi(st_union(n.geom)) as g FROM '
      || quote_ident(toponame) || '.node n, '
      || quote_ident(toponame) || '.relation r '
         ' WHERE r.topogeo_id = ' || topogeom.id
      || ' AND r.layer_id = ' || topogeom.layer_id
      || ' AND r.element_type = 1 '
         ' AND r.element_id = n.node_id';
    EXECUTE sql INTO geom;

  ELSIF topogeom.type = 4 THEN -- mixed collection -- }{

    sql := 'WITH areas AS ( SELECT ST_Union('
         'topology.ST_GetFaceGeometry('
      || quote_literal(toponame) || ','
      || 'element_id)) as g FROM ' 
      || quote_ident(toponame)
      || '.relation WHERE topogeo_id = '
      || topogeom.id || ' AND layer_id = '
      || topogeom.layer_id || ' AND element_type = 3), '
         'lines AS ( SELECT ST_LineMerge(ST_Collect(e.geom)) as g FROM '
      || quote_ident(toponame) || '.edge e, '
      || quote_ident(toponame) || '.relation r '
         ' WHERE r.topogeo_id = ' || topogeom.id
      || ' AND r.layer_id = ' || topogeom.layer_id
      || ' AND r.element_type = 2 '
         ' AND abs(r.element_id) = e.edge_id ), '
         ' points as ( SELECT st_union(n.geom) as g FROM '
      || quote_ident(toponame) || '.node n, '
      || quote_ident(toponame) || '.relation r '
         ' WHERE r.topogeo_id = ' || topogeom.id
      || ' AND r.layer_id = ' || topogeom.layer_id
      || ' AND r.element_type = 1 '
         ' AND r.element_id = n.node_id ), '
         ' un as ( SELECT g FROM areas UNION ALL SELECT g FROM lines '
         '          UNION ALL SELECT g FROM points ) '
         'SELECT ST_Multi(ST_Collect(g)) FROM un';
    EXECUTE sql INTO geom;

  ELSE -- }{

    RAISE EXCEPTION 'Invalid TopoGeometries (unknown type %)', topogeom.type;

  END IF; -- }

  IF geom IS NULL THEN
    IF topogeom.type = 3 THEN -- [multi]polygon
      geom := 'MULTIPOLYGON EMPTY';
    ELSIF topogeom.type = 2 THEN -- [multi]line
      geom := 'MULTILINESTRING EMPTY';
    ELSIF topogeom.type = 1 THEN -- [multi]point
      geom := 'MULTIPOINT EMPTY';
    ELSE
      geom := 'GEOMETRYCOLLECTION EMPTY';
    END IF;
  END IF;

  RETURN geom;
END
$$
LANGUAGE 'plpgsql' VOLATILE STRICT;
--} Geometry(TopoGeometry)

-- 7.3+ explicit cast 


--{
--  ValidateTopology(toponame)
--
--  Return a Set of ValidateTopology_ReturnType containing
--  informations on all topology inconsistencies
--
CREATE OR REPLACE FUNCTION topology.ValidateTopology(toponame varchar)
  RETURNS setof topology.ValidateTopology_ReturnType
AS
$$
DECLARE
  retrec topology.ValidateTopology_ReturnType;
  rec RECORD;
  rec2 RECORD;
  i integer;
  invalid_edges integer[];
  invalid_faces integer[];
  sql text;
BEGIN

  -- Check for coincident nodes
  FOR rec IN EXECUTE 'SELECT a.node_id as id1, b.node_id as id2 FROM '
    || quote_ident(toponame) || '.node a, '
    || quote_ident(toponame) || '.node b '
       'WHERE a.node_id < b.node_id '
       ' AND ST_DWithin(a.geom, b.geom, 0)' -- NOTE: see #1625 and #1789
  LOOP
    retrec.error = 'coincident nodes';
    retrec.id1 = rec.id1;
    retrec.id2 = rec.id2;
    RETURN NEXT retrec;
  END LOOP;

  -- Check for edge crossed nodes
  -- TODO: do this in the single edge loop
  FOR rec IN EXECUTE 'SELECT n.node_id as nid, e.edge_id as eid FROM '
    || quote_ident(toponame) || '.node n, '
    || quote_ident(toponame) || '.edge e '
       'WHERE e.start_node != n.node_id '
       'AND e.end_node != n.node_id '
       'AND ST_Within(n.geom, e.geom)'
  LOOP
    retrec.error = 'edge crosses node';
    retrec.id1 = rec.eid; -- edge_id
    retrec.id2 = rec.nid; -- node_id
    RETURN NEXT retrec;
  END LOOP;

  -- Scan all edges 
  FOR rec IN EXECUTE 'SELECT e.geom, e.edge_id as id1, e.left_face, e.right_face FROM '
    || quote_ident(toponame) || '.edge e ORDER BY edge_id'
  LOOP

    -- Any invalid edge becomes a cancer for higher level complexes
    IF NOT ST_IsValid(rec.geom) THEN

      retrec.error = 'invalid edge';
      retrec.id1 = rec.id1;
      retrec.id2 = NULL;
      RETURN NEXT retrec;
      invalid_edges := array_append(invalid_edges, rec.id1);

      IF invalid_faces IS NULL OR NOT rec.left_face = ANY ( invalid_faces )
      THEN
        invalid_faces := array_append(invalid_faces, rec.left_face);
      END IF;

      IF rec.right_face != rec.left_face AND ( invalid_faces IS NULL OR
            NOT rec.right_face = ANY ( invalid_faces ) )
      THEN
        invalid_faces := array_append(invalid_faces, rec.right_face);
      END IF;

      CONTINUE;

    END IF;

    IF NOT ST_IsSimple(rec.geom) THEN
      retrec.error = 'edge not simple';
      retrec.id1 = rec.id1;
      retrec.id2 = NULL;
      RETURN NEXT retrec;
    END IF;

  END LOOP;

  -- Check for edge crossing
  sql := 'SELECT e1.edge_id as id1, e2.edge_id as id2, '
       ' e1.geom as g1, e2.geom as g2, '
       'ST_Relate(e1.geom, e2.geom) as im FROM '
    || quote_ident(toponame) || '.edge e1, '
    || quote_ident(toponame) || '.edge e2 '
       'WHERE e1.edge_id < e2.edge_id '
       ' AND e1.geom && e2.geom ';
  IF invalid_edges IS NOT NULL THEN
    sql := sql || ' AND NOT e1.edge_id = ANY ('
               || quote_literal(invalid_edges) || ')'
               || ' AND NOT e2.edge_id = ANY ('
               || quote_literal(invalid_edges) || ')';
  END IF;

  FOR rec IN EXECUTE sql
  LOOP

    IF ST_RelateMatch(rec.im, 'FF1F**1*2') THEN
      CONTINUE; -- no interior intersection

    --
    -- Closed lines have no boundary, so endpoint
    -- intersection would be considered interior
    -- See http://trac.osgeo.org/postgis/ticket/770
    -- See also full explanation in topology.AddEdge
    --

    ELSIF ST_RelateMatch(rec.im, 'FF10F01F2') THEN
      -- first line (g1) is open, second (g2) is closed
      -- first boundary has puntual intersection with second interior
      --
      -- compute intersection, check it equals second endpoint
      IF ST_Equals(ST_Intersection(rec.g2, rec.g1),
                   ST_StartPoint(rec.g2))
      THEN
        CONTINUE;
      END IF;

    ELSIF ST_RelateMatch(rec.im, 'F01FFF102') THEN
      -- second line (g2) is open, first (g1) is closed
      -- second boundary has puntual intersection with first interior
      -- 
      -- compute intersection, check it equals first endpoint
      IF ST_Equals(ST_Intersection(rec.g2, rec.g1),
                   ST_StartPoint(rec.g1))
      THEN
        CONTINUE;
      END IF;

    ELSIF ST_RelateMatch(rec.im, '0F1FFF1F2') THEN
      -- both lines are closed (boundary intersects nothing)
      -- they have puntual intersection between interiors
      -- 
      -- compute intersection, check it's a single point
      -- and equals first StartPoint _and_ second StartPoint
      IF ST_Equals(ST_Intersection(rec.g1, rec.g2),
                   ST_StartPoint(rec.g1)) AND
         ST_Equals(ST_StartPoint(rec.g1), ST_StartPoint(rec.g2))
      THEN
        CONTINUE;
      END IF;

    END IF;

    retrec.error = 'edge crosses edge';
    retrec.id1 = rec.id1;
    retrec.id2 = rec.id2;
    RETURN NEXT retrec;
  END LOOP;

  -- Check for edge start_node geometry mis-match
  -- TODO: move this in the first edge table scan 
  FOR rec IN EXECUTE 'SELECT e.edge_id as id1, n.node_id as id2 FROM '
    || quote_ident(toponame) || '.edge e, '
    || quote_ident(toponame) || '.node n '
       'WHERE e.start_node = n.node_id '
       'AND NOT ST_Equals(ST_StartPoint(e.geom), n.geom)'
  LOOP
    retrec.error = 'edge start node geometry mis-match';
    retrec.id1 = rec.id1;
    retrec.id2 = rec.id2;
    RETURN NEXT retrec;
  END LOOP;

  -- Check for edge end_node geometry mis-match
  -- TODO: move this in the first edge table scan 
  FOR rec IN EXECUTE 'SELECT e.edge_id as id1, n.node_id as id2 FROM '
    || quote_ident(toponame) || '.edge e, '
    || quote_ident(toponame) || '.node n '
       'WHERE e.end_node = n.node_id '
       'AND NOT ST_Equals(ST_EndPoint(e.geom), n.geom)'
  LOOP
    retrec.error = 'edge end node geometry mis-match';
    retrec.id1 = rec.id1;
    retrec.id2 = rec.id2;
    RETURN NEXT retrec;
  END LOOP;

  -- Check for faces w/out edges
  FOR rec IN EXECUTE 'SELECT face_id as id1 FROM '
    || quote_ident(toponame) || '.face '
    || 'WHERE face_id > 0 EXCEPT ( SELECT left_face FROM '
    || quote_ident(toponame) || '.edge '
    || ' UNION SELECT right_face FROM '
    || quote_ident(toponame) || '.edge '
    || ')'
  LOOP
    retrec.error = 'face without edges';
    retrec.id1 = rec.id1;
    retrec.id2 = NULL;
    RETURN NEXT retrec;
  END LOOP;

  -- Now create a temporary table to construct all face geometries
  -- for checking their consistency

  sql := 'CREATE TEMP TABLE face_check ON COMMIT DROP AS '
       'SELECT face_id, topology.ST_GetFaceGeometry('
    || quote_literal(toponame) || ', face_id) as geom, mbr FROM '
    || quote_ident(toponame) || '.face WHERE face_id > 0';
  IF invalid_faces IS NOT NULL THEN
    sql := sql || ' AND NOT face_id = ANY ('
               || quote_literal(invalid_faces) || ')';
  END IF;
  EXECUTE sql;

  -- Build a gist index on geom
  EXECUTE 'CREATE INDEX "face_check_gist" ON '
       'face_check USING gist (geom);';

  -- Build a btree index on id
  EXECUTE 'CREATE INDEX "face_check_bt" ON ' 
       'face_check (face_id);';

  -- Scan the table looking for NULL geometries
  FOR rec IN EXECUTE
    'SELECT f1.face_id FROM '
       'face_check f1 WHERE f1.geom IS NULL OR ST_IsEmpty(f1.geom)'
  LOOP
    -- Face missing !
    retrec.error := 'face has no rings';
    retrec.id1 := rec.face_id;
    retrec.id2 := NULL;
    RETURN NEXT retrec;
  END LOOP;


  -- Scan the table looking for overlap or containment
  -- TODO: also check for MBR consistency
  FOR rec IN EXECUTE
    'SELECT f1.geom, f1.face_id as id1, f2.face_id as id2, '
       ' ST_Relate(f1.geom, f2.geom) as im'
       ' FROM '
       'face_check f1, '
       'face_check f2 '
       'WHERE f1.face_id < f2.face_id'
       ' AND f1.geom && f2.geom'
  LOOP

    -- Face overlap
    IF ST_RelateMatch(rec.im, 'T*T***T**') THEN
    retrec.error = 'face overlaps face';
    retrec.id1 = rec.id1;
    retrec.id2 = rec.id2;
    RETURN NEXT retrec;
    END IF;

    -- Face 1 is within face 2 
    IF ST_RelateMatch(rec.im, 'T*F**F***') THEN
    retrec.error = 'face within face';
    retrec.id1 = rec.id1;
    retrec.id2 = rec.id2;
    RETURN NEXT retrec;
    END IF;

    -- Face 1 contains face 2
    IF ST_RelateMatch(rec.im, 'T*****FF*') THEN
    retrec.error = 'face within face';
    retrec.id1 = rec.id2;
    retrec.id2 = rec.id1;
    RETURN NEXT retrec;
    END IF;

  END LOOP;


  DROP TABLE face_check;

  RETURN;
END
$$
LANGUAGE 'plpgsql' VOLATILE STRICT;
-- } ValidateTopology(toponame)

--{
--  CreateTopology(name, SRID, precision, hasZ)
--
-- Create a topology schema, add a topology info record
-- in the topology.topology relation, return it's numeric
-- id. 
--
CREATE OR REPLACE FUNCTION topology.CreateTopology(atopology varchar, srid integer, prec float8, hasZ boolean)
RETURNS integer
AS
$$
DECLARE
  rec RECORD;
  topology_id integer;
  ndims integer;
BEGIN

--  FOR rec IN SELECT * FROM pg_namespace WHERE text(nspname) = atopology
--  LOOP
--    RAISE EXCEPTION 'SQL/MM Spatial exception - schema already exists';
--  END LOOP;

  ndims = 2;
  IF hasZ THEN ndims = 3; END IF;

  ------ Fetch next id for the new topology
  FOR rec IN SELECT nextval('topology.topology_id_seq')
  LOOP
    topology_id = rec.nextval;
  END LOOP;


  EXECUTE 'CREATE SCHEMA ' || quote_ident(atopology);

  -------------{ face CREATION
  EXECUTE 
  'CREATE TABLE ' || quote_ident(atopology) || '.face ('
     'face_id SERIAL,'
     ' CONSTRAINT face_primary_key PRIMARY KEY(face_id)'
     ');';

  -- Add mbr column to the face table 
  EXECUTE
  'SELECT AddGeometryColumn('||quote_literal(atopology)
  ||',''face'',''mbr'','||quote_literal(srid)
  ||',''POLYGON'',2)'; -- 2d only mbr is good enough

  -------------} END OF face CREATION


  --------------{ node CREATION

  EXECUTE 
  'CREATE TABLE ' || quote_ident(atopology) || '.node ('
     'node_id SERIAL,'
  --|| 'geom GEOMETRY,'
     'containing_face INTEGER,'

     'CONSTRAINT node_primary_key PRIMARY KEY(node_id),'

  --|| 'CONSTRAINT node_geometry_type CHECK '
  --|| '( GeometryType(geom) = ''POINT'' ),'

     'CONSTRAINT face_exists FOREIGN KEY(containing_face) '
     'REFERENCES ' || quote_ident(atopology) || '.face(face_id)'

     ');';

  -- Add geometry column to the node table 
  EXECUTE
  'SELECT AddGeometryColumn('||quote_literal(atopology)
  ||',''node'',''geom'','||quote_literal(srid)
  ||',''POINT'',' || ndims || ')';

  --------------} END OF node CREATION

  --------------{ edge CREATION

  -- edge_data table
  EXECUTE 
  'CREATE TABLE ' || quote_ident(atopology) || '.edge_data ('
     'edge_id SERIAL NOT NULL PRIMARY KEY,'
     'start_node INTEGER NOT NULL,'
     'end_node INTEGER NOT NULL,'
     'next_left_edge INTEGER NOT NULL,'
     'abs_next_left_edge INTEGER NOT NULL,'
     'next_right_edge INTEGER NOT NULL,'
     'abs_next_right_edge INTEGER NOT NULL,'
     'left_face INTEGER NOT NULL,'
     'right_face INTEGER NOT NULL,'
  --   'geom GEOMETRY NOT NULL,'

  --   'CONSTRAINT edge_geometry_type CHECK '
  --   '( GeometryType(geom) = ''LINESTRING'' ),'

     'CONSTRAINT start_node_exists FOREIGN KEY(start_node)'
     ' REFERENCES ' || quote_ident(atopology) || '.node(node_id),'

     'CONSTRAINT end_node_exists FOREIGN KEY(end_node) '
     ' REFERENCES ' || quote_ident(atopology) || '.node(node_id),'

     'CONSTRAINT left_face_exists FOREIGN KEY(left_face) '
     'REFERENCES ' || quote_ident(atopology) || '.face(face_id),'

     'CONSTRAINT right_face_exists FOREIGN KEY(right_face) '
     'REFERENCES ' || quote_ident(atopology) || '.face(face_id),'

     'CONSTRAINT next_left_edge_exists FOREIGN KEY(abs_next_left_edge)'
     ' REFERENCES ' || quote_ident(atopology)
  || '.edge_data(edge_id)'
     ' DEFERRABLE INITIALLY DEFERRED,'

     'CONSTRAINT next_right_edge_exists '
     'FOREIGN KEY(abs_next_right_edge)'
     ' REFERENCES ' || quote_ident(atopology)
  || '.edge_data(edge_id) '
     ' DEFERRABLE INITIALLY DEFERRED'
     ');';

  -- Add geometry column to the edge_data table 
  EXECUTE
  'SELECT AddGeometryColumn('||quote_literal(atopology)
  ||',''edge_data'',''geom'','||quote_literal(srid)
  ||',''LINESTRING'',' || ndims || ')';


  -- edge standard view (select rule)
  EXECUTE 'CREATE VIEW ' || quote_ident(atopology)
    || '.edge AS SELECT '
       ' edge_id, start_node, end_node, next_left_edge, '
       ' next_right_edge, '
       ' left_face, right_face, geom FROM '
    || quote_ident(atopology) || '.edge_data';

  -- edge standard view description
  EXECUTE 'COMMENT ON VIEW ' || quote_ident(atopology)
    || '.edge IS '
       '''Contains edge topology primitives''';
  EXECUTE 'COMMENT ON COLUMN ' || quote_ident(atopology)
    || '.edge.edge_id IS '
       '''Unique identifier of the edge''';
  EXECUTE 'COMMENT ON COLUMN ' || quote_ident(atopology)
    || '.edge.start_node IS '
       '''Unique identifier of the node at the start of the edge''';
  EXECUTE 'COMMENT ON COLUMN ' || quote_ident(atopology)
    || '.edge.end_node IS '
       '''Unique identifier of the node at the end of the edge''';
  EXECUTE 'COMMENT ON COLUMN ' || quote_ident(atopology)
    || '.edge.next_left_edge IS '
       '''Unique identifier of the next edge of the face on the left (when looking in the direction from START_NODE to END_NODE), moving counterclockwise around the face boundary''';
  EXECUTE 'COMMENT ON COLUMN ' || quote_ident(atopology)
    || '.edge.next_right_edge IS '
       '''Unique identifier of the next edge of the face on the right (when looking in the direction from START_NODE to END_NODE), moving counterclockwise around the face boundary''';
  EXECUTE 'COMMENT ON COLUMN ' || quote_ident(atopology)
    || '.edge.left_face IS '
       '''Unique identifier of the face on the left side of the edge when looking in the direction from START_NODE to END_NODE''';
  EXECUTE 'COMMENT ON COLUMN ' || quote_ident(atopology)
    || '.edge.right_face IS '
       '''Unique identifier of the face on the right side of the edge when looking in the direction from START_NODE to END_NODE''';
  EXECUTE 'COMMENT ON COLUMN ' || quote_ident(atopology)
    || '.edge.geom IS '
       '''The geometry of the edge''';

  -- edge standard view (insert rule)
  EXECUTE 'CREATE RULE edge_insert_rule AS ON INSERT '
             'TO ' || quote_ident(atopology)
    || '.edge DO INSTEAD '
                   ' INSERT into ' || quote_ident(atopology)
    || '.edge_data '
                   ' VALUES (NEW.edge_id, NEW.start_node, NEW.end_node, '
       ' NEW.next_left_edge, abs(NEW.next_left_edge), '
       ' NEW.next_right_edge, abs(NEW.next_right_edge), '
       ' NEW.left_face, NEW.right_face, NEW.geom);';

  --------------} END OF edge CREATION

  --------------{ layer sequence 
  EXECUTE 'CREATE SEQUENCE '
    || quote_ident(atopology) || '.layer_id_seq;';
  --------------} layer sequence

  --------------{ relation CREATION
  --
  EXECUTE 
  'CREATE TABLE ' || quote_ident(atopology) || '.relation ('
     ' topogeo_id integer NOT NULL, '
     ' layer_id integer NOT NULL, '
     ' element_id integer NOT NULL, '
     ' element_type integer NOT NULL, '
     ' UNIQUE(layer_id,topogeo_id,element_id,element_type));';

  EXECUTE 
  'CREATE TRIGGER relation_integrity_checks '
     'BEFORE UPDATE OR INSERT ON '
  || quote_ident(atopology) || '.relation FOR EACH ROW '
     ' EXECUTE PROCEDURE topology.RelationTrigger('
  ||topology_id||','||quote_literal(atopology)||')';
  --------------} END OF relation CREATION

  
  ------- Default (world) face
  EXECUTE 'INSERT INTO ' || quote_ident(atopology) || '.face(face_id) VALUES(0);';

  ------- GiST index on face
  EXECUTE 'CREATE INDEX face_gist ON '
    || quote_ident(atopology)
    || '.face using gist (mbr);';

  ------- GiST index on node
  EXECUTE 'CREATE INDEX node_gist ON '
    || quote_ident(atopology)
    || '.node using gist (geom);';

  ------- GiST index on edge
  EXECUTE 'CREATE INDEX edge_gist ON '
    || quote_ident(atopology)
    || '.edge_data using gist (geom);';

  ------- Indexes on left_face and right_face of edge_data
  ------- NOTE: these indexes speed up GetFaceGeometry (and thus
  -------       TopoGeometry::Geometry) by a factor of 10 !
  -------       See http://trac.osgeo.org/postgis/ticket/806
  EXECUTE 'CREATE INDEX edge_left_face_idx ON '
    || quote_ident(atopology)
    || '.edge_data (left_face);';
  EXECUTE 'CREATE INDEX edge_right_face_idx ON '
    || quote_ident(atopology)
    || '.edge_data (right_face);';

  ------- Indexes on start_node and end_node of edge_data
  ------- NOTE: this indexes speed up node deletion
  -------       by a factor of 1000 !
  -------       See http://trac.osgeo.org/postgis/ticket/2082
  EXECUTE 'CREATE INDEX edge_start_node_idx ON '
    || quote_ident(atopology)
    || '.edge_data (start_node);';
  EXECUTE 'CREATE INDEX edge_end_node_idx ON '
    || quote_ident(atopology)
    || '.edge_data (end_node);';

  -- TODO: consider also adding an index on node.containing_face 

  ------- Add record to the "topology" metadata table
  EXECUTE 'INSERT INTO topology.topology '
    || '(id, name, srid, precision, hasZ) VALUES ('
    || quote_literal(topology_id) || ','
    || quote_literal(atopology) || ','
    || quote_literal(srid) || ',' || quote_literal(prec)
    || ',' || hasZ
    || ')';

  RETURN topology_id;
END
$$
LANGUAGE 'plpgsql' VOLATILE STRICT;

--} CreateTopology

--{ CreateTopology wrappers for unspecified srid or precision or hasZ

--  CreateTopology(name, SRID, precision) -- hasZ = false
CREATE OR REPLACE FUNCTION topology.CreateTopology(toponame varchar, srid integer, prec float8)
RETURNS integer AS
' SELECT topology.CreateTopology($1, $2, $3, false);'
LANGUAGE 'sql' VOLATILE STRICT;

--  CreateTopology(name, SRID) -- precision = 0
CREATE OR REPLACE FUNCTION topology.CreateTopology(varchar, integer)
RETURNS integer AS
' SELECT topology.CreateTopology($1, $2, 0); '
LANGUAGE 'sql' VOLATILE STRICT;

--  CreateTopology(name) -- srid = unknown, precision = 0
CREATE OR REPLACE FUNCTION topology.CreateTopology(varchar)
RETURNS integer AS
$$ SELECT topology.CreateTopology($1, ST_SRID('POINT EMPTY'::geometry), 0); $$
LANGUAGE 'sql' VOLATILE STRICT;

--} CreateTopology

--{
--  DropTopology(name)
--
-- Drops a topology schema getting rid of every dependent object.
--
CREATE OR REPLACE FUNCTION topology.DropTopology(atopology varchar)
RETURNS text
AS
$$
DECLARE
  topoid integer;
  rec RECORD;
BEGIN
  -- Get topology id
  SELECT id INTO topoid
    FROM topology.topology WHERE name = atopology;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Topology % does not exist', quote_literal(atopology);
  END IF;

  RAISE NOTICE 'Dropping all layers from topology % (%)',
    quote_literal(atopology), topoid;

  -- Drop all layers in the topology
  FOR rec IN EXECUTE 'SELECT * FROM topology.layer WHERE '
    || ' topology_id = ' || topoid
  LOOP

    EXECUTE 'SELECT topology.DropTopoGeometryColumn('
      || quote_literal(rec.schema_name)
      || ','
      || quote_literal(rec.table_name)
      || ','
      || quote_literal(rec.feature_column)
      || ')';
  END LOOP;

  -- Delete record from topology.topology
  EXECUTE 'DELETE FROM topology.topology WHERE id = '
    || topoid;

  -- Drop the schema (if it exists)
  FOR rec IN SELECT * FROM pg_namespace WHERE text(nspname) = atopology
  LOOP
    EXECUTE 'DROP SCHEMA '||quote_ident(atopology)||' CASCADE';
  END LOOP;

  RETURN 'Topology ' || quote_literal(atopology) || ' dropped';
END
$$
LANGUAGE 'plpgsql' VOLATILE STRICT;
--} DropTopology

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- 
-- PostGIS - Spatial Types for PostgreSQL
-- http://postgis.net
--
-- Copyright (C) 2011 Sandro Santilli <strk@keybit.net>
--
-- This is free software; you can redistribute and/or modify it under
-- the terms of the GNU General Public Licence. See the COPYING file.
--
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

--{
--  TopologySummary(name)
--
-- Print an overview about a topology
--
CREATE OR REPLACE FUNCTION topology.TopologySummary(atopology varchar)
RETURNS text
AS
$$
DECLARE
  rec RECORD;
  rec2 RECORD;
  var_topology_id integer;
  n int4;
  missing int4;
  sql text;
  ret text;
  tgcount int4;
BEGIN

  ret := 'Topology ' || quote_ident(atopology) ;

  BEGIN
    SELECT * FROM topology.topology WHERE name = atopology INTO STRICT rec;
    -- TODO: catch <no_rows> to give a nice error message
    var_topology_id := rec.id;

    ret := ret || ' (id ' || rec.id || ', '
               || 'SRID ' || rec.srid || ', '
               || 'precision ' || rec.precision;
    IF rec.hasz THEN ret := ret || ', has Z'; END IF;
    ret := ret || E')\n';
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      ret := ret || E' (unregistered)\n';
  END;

  BEGIN
    EXECUTE 'SELECT count(*) FROM ' || quote_ident(atopology)
      || '.node ' INTO STRICT n;
    ret = ret || n || ' nodes, ';
  EXCEPTION
    WHEN UNDEFINED_TABLE OR INVALID_SCHEMA_NAME THEN
      IF NOT EXISTS (
          SELECT * FROM pg_catalog.pg_namespace WHERE nspname = atopology
         )
      THEN
        ret = ret || 'missing schema';
        RETURN ret; 
      ELSE
        ret = ret || 'missing nodes, ';
      END IF;
  END;

  BEGIN
    EXECUTE 'SELECT count(*) FROM ' || quote_ident(atopology)
      || '.edge' INTO STRICT n;
    ret = ret || n || ' edges, ';
  EXCEPTION
    WHEN UNDEFINED_TABLE OR INVALID_SCHEMA_NAME THEN
      ret = ret || 'missing edges, ';
  END;

  BEGIN
    EXECUTE 'SELECT count(*) FROM ' || quote_ident(atopology)
      || '.face' INTO STRICT n;
    ret = ret || greatest(n-1,0) || ' faces, '; -- -1 is face=0
  EXCEPTION
    WHEN UNDEFINED_TABLE OR INVALID_SCHEMA_NAME THEN
      ret = ret || 'missing faces, ';
  END;

  BEGIN
    EXECUTE 'SELECT count(distinct layer_id) AS ln, '
      || 'count(distinct (layer_id,topogeo_id)) AS tn FROM '
      || quote_ident(atopology) || '.relation' INTO STRICT rec;
    tgcount := rec.tn;
    ret = ret || rec.tn || ' topogeoms in ' || rec.ln || E' layers\n';
  EXCEPTION
    WHEN UNDEFINED_TABLE THEN
      ret = ret || E'missing relations\n';
    WHEN UNDEFINED_COLUMN THEN
      ret = ret || E'corrupted relations\n';
  END;

  -- print information about registered layers
  FOR rec IN SELECT * FROM topology.layer l
    WHERE l.topology_id = var_topology_id
    ORDER by layer_id
  LOOP -- {
    ret = ret || 'Layer ' || rec.layer_id || ', type ';
    CASE
      WHEN rec.feature_type = 1 THEN
        ret = ret || 'Puntal';
      WHEN rec.feature_type = 2 THEN
        ret = ret || 'Lineal';
      WHEN rec.feature_type = 3 THEN
        ret = ret || 'Polygonal';
      WHEN rec.feature_type = 4 THEN
        ret = ret || 'Mixed';
      ELSE 
        ret = ret || '???';
    END CASE;

    ret = ret || ' (' || rec.feature_type || '), ';

    BEGIN

      EXECUTE 'SELECT count(*) FROM ( SELECT DISTINCT topogeo_id FROM '
        || quote_ident(atopology)
        || '.relation r WHERE r.layer_id = ' || rec.layer_id
        || ' ) foo ' INTO STRICT n;

      ret = ret || n || ' topogeoms' || E'\n';

    EXCEPTION WHEN UNDEFINED_TABLE OR UNDEFINED_COLUMN THEN
      n := NULL;
      ret = ret || 'X topogeoms' || E'\n';
    END;

      IF rec.level > 0 THEN
        ret = ret || ' Hierarchy level ' || rec.level 
                  || ', child layer ' || rec.child_id || E'\n';
      END IF;

      ret = ret || ' Deploy: ';
      IF rec.feature_column != '' THEN
        ret = ret || quote_ident(rec.schema_name) || '.'
                  || quote_ident(rec.table_name) || '.'
                  || quote_ident(rec.feature_column);

        IF n > 0 THEN
          sql := 'SELECT count(*) FROM ( SELECT topogeo_id FROM '
            || quote_ident(atopology)
            || '.relation r WHERE r.layer_id = ' || rec.layer_id
            || ' EXCEPT SELECT DISTINCT id('
            || quote_ident(rec.feature_column) || ') FROM '
            || quote_ident(rec.schema_name) || '.'
            || quote_ident(rec.table_name) || ') as foo';
          BEGIN
            EXECUTE sql INTO STRICT missing;
            IF missing > 0 THEN
              ret = ret || ' (' || missing || ' missing topogeoms)';
            END IF;
          EXCEPTION
            WHEN UNDEFINED_TABLE THEN
              ret = ret || ' ( unexistent table )';
            WHEN UNDEFINED_COLUMN THEN
              ret = ret || ' ( unexistent column )';
          END;
        END IF;
        ret = ret || E'\n';

      ELSE
        ret = ret || E'NONE (detached)\n';
      END IF;

  END LOOP; -- }

  -- print information about unregistered layers containing topogeoms
  IF tgcount > 0 THEN -- {

    sql := 'SELECT layer_id FROM '
        || quote_ident(atopology) || '.relation EXCEPT SELECT layer_id'
        || ' FROM topology.layer WHERE topology_id = $1 ORDER BY layer_id';
    --RAISE DEBUG '%', sql;
    FOR rec IN  EXECUTE sql USING var_topology_id
    LOOP -- {
      ret = ret || 'Layer ' || rec.layer_id::text || ', UNREGISTERED, ';

      EXECUTE 'SELECT count(*) FROM ( SELECT DISTINCT topogeo_id FROM '
        || quote_ident(atopology)
        || '.relation r WHERE r.layer_id = ' || rec.layer_id
        || ' ) foo ' INTO STRICT n;

      ret = ret || n || ' topogeoms' || E'\n';

    END LOOP; -- }

  END IF; -- }

  RETURN ret;
END
$$
LANGUAGE 'plpgsql' STABLE STRICT;

--} TopologySummary
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- 
-- PostGIS - Spatial Types for PostgreSQL
-- http://postgis.net
--
-- Copyright (C) 2011 Sandro Santilli <strk@keybit.net>
--
-- This is free software; you can redistribute and/or modify it under
-- the terms of the GNU General Public Licence. See the COPYING file.
--
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

--{
-- CopyTopology(name_source, name_target)
--
-- Makes a copy of a topology (primitives + topogeometry collections) .
-- Returns the new topology id.
--
CREATE OR REPLACE FUNCTION topology.CopyTopology(atopology varchar, newtopo varchar)
RETURNS int
AS
$$
DECLARE
  rec RECORD;
  rec2 RECORD;
  oldtopo_id integer;
  newtopo_id integer;
  n int4;
  ret text;
BEGIN

  SELECT * FROM topology.topology where name = atopology
  INTO strict rec;
  oldtopo_id = rec.id;
  -- TODO: more gracefully handle unexistent topology

  SELECT topology.CreateTopology(newtopo, rec.SRID, rec.precision, rec.hasZ)
  INTO strict newtopo_id;

  -- Copy faces
  EXECUTE 'INSERT INTO ' || quote_ident(newtopo)
    || '.face SELECT * FROM ' || quote_ident(atopology)
    || '.face WHERE face_id != 0';
  -- Update faces sequence
  EXECUTE 'SELECT setval(' || quote_literal(
      quote_ident(newtopo) || '.face_face_id_seq'
    ) || ', (SELECT last_value FROM ' 
    || quote_ident(atopology) || '.face_face_id_seq))';

  -- Copy nodes
  EXECUTE 'INSERT INTO ' || quote_ident(newtopo)
    || '.node SELECT * FROM ' || quote_ident(atopology)
    || '.node';
  -- Update node sequence
  EXECUTE 'SELECT setval(' || quote_literal(
      quote_ident(newtopo) || '.node_node_id_seq'
    ) || ', (SELECT last_value FROM ' 
    || quote_ident(atopology) || '.node_node_id_seq))';

  -- Copy edges
  EXECUTE 'INSERT INTO ' || quote_ident(newtopo)
    || '.edge_data SELECT * FROM ' || quote_ident(atopology)
    || '.edge_data';
  -- Update edge sequence
  EXECUTE 'SELECT setval(' || quote_literal(
      quote_ident(newtopo) || '.edge_data_edge_id_seq'
    ) || ', (SELECT last_value FROM ' 
    || quote_ident(atopology) || '.edge_data_edge_id_seq))';

  -- Copy layers and their TopoGeometry sequences 
  FOR rec IN SELECT * FROM topology.layer WHERE topology_id = oldtopo_id
  LOOP
    INSERT INTO topology.layer (topology_id, layer_id, feature_type,
      level, child_id, schema_name, table_name, feature_column) 
      VALUES (newtopo_id, rec.layer_id, rec.feature_type,
              rec.level, rec.child_id, newtopo,
              'LAYER' ||  rec.layer_id, '');
    -- Create layer's TopoGeometry sequences
    EXECUTE 'SELECT last_value FROM ' 
      || quote_ident(atopology) || '.topogeo_s_' || rec.layer_id 
      INTO STRICT n;
    EXECUTE 'CREATE SEQUENCE ' || quote_ident(newtopo)
      || '.topogeo_s_' || rec.layer_id;
    EXECUTE 'SELECT setval(' || quote_literal(
      quote_ident(newtopo) || '.topogeo_s_' || rec.layer_id
      ) || ', ' || n || ')';
  END LOOP;

  -- Copy TopoGeometry definitions
  EXECUTE 'INSERT INTO ' || quote_ident(newtopo)
    || '.relation SELECT * FROM ' || quote_ident(atopology)
    || '.relation';

  RETURN newtopo_id;
END
$$
LANGUAGE 'plpgsql' VOLATILE STRICT;

--} TopologySummary

-- Spatial predicates
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--
-- PostGIS - Spatial Types for PostgreSQL
-- http://postgis.net
--
-- Copyright (C) 2011-2012 Sandro Santilli <strk@keybit.net>
-- Copyright (C) 2005 Refractions Research Inc.
--
-- This is free software; you can redistribute and/or modify it under
-- the terms of the GNU General Public Licence. See the COPYING file.
--
-- Author: Sandro Santilli <strk@keybit.net>
--  
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--
--  Overloaded spatial predicates for TopoGeometry inputs
--
--   FUNCTION intersects(TopoGeometry, TopoGeometry)
--   FUNCTION equals(TopoGeometry, TopoGeometry)
--
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

--{
-- intersects(TopoGeometry, TopoGeometry)
--
CREATE OR REPLACE FUNCTION topology.intersects(tg1 topology.TopoGeometry, tg2 topology.TopoGeometry)
  RETURNS bool
AS
$$
DECLARE
  tgbuf topology.TopoGeometry;
  rec RECORD;
  toponame varchar;
  query text;
BEGIN
  IF tg1.topology_id != tg2.topology_id THEN
    -- TODO: revert to ::geometry instead ?
    RAISE EXCEPTION 'Cannot compute intersection between TopoGeometries from different topologies';
  END IF;

  -- Order TopoGeometries so that tg1 has less-or-same
  -- dimensionality of tg1 (point,line,polygon,collection)
  IF tg1.type > tg2.type THEN
    tgbuf := tg2;
    tg2 := tg1;
    tg1 := tgbuf;
  END IF;

  --RAISE NOTICE 'tg1.id:% tg2.id:%', tg1.id, tg2.id;
  -- Geometry collection are not currently supported
  IF tg2.type = 4 THEN
    RAISE EXCEPTION 'GeometryCollection are not supported by intersects()';
  END IF;

        -- Get topology name
        SELECT name FROM topology.topology into toponame
                WHERE id = tg1.topology_id;

  -- Hierarchical TopoGeometries are not currently supported
  query = 'SELECT level FROM topology.layer'
    || ' WHERE '
    || ' topology_id = ' || tg1.topology_id
    || ' AND '
    || '( layer_id = ' || tg1.layer_id
    || ' OR layer_id = ' || tg2.layer_id
    || ' ) '
    || ' AND level > 0 ';

  --RAISE NOTICE '%', query;

  FOR rec IN EXECUTE query
  LOOP
    -- TODO: revert to ::geometry instead ?
    RAISE EXCEPTION 'Hierarchical TopoGeometries are not currently supported by intersects()';
  END LOOP;

  IF tg1.type = 1 THEN -- [multi]point


    IF tg2.type = 1 THEN -- point/point
  ---------------------------------------------------------
  -- 
  --  Two [multi]point features intersect if they share
  --  any Node 
  --
  --
  --
      query =
        'SELECT a.topogeo_id FROM '
        || quote_ident(toponame) ||
        '.relation a, '
        || quote_ident(toponame) ||
        '.relation b '
        || 'WHERE a.layer_id = ' || tg1.layer_id
        || ' AND b.layer_id = ' || tg2.layer_id
        || ' AND a.topogeo_id = ' || tg1.id
        || ' AND b.topogeo_id = ' || tg2.id
        || ' AND a.element_id = b.element_id '
        || ' LIMIT 1';
      --RAISE NOTICE '%', query;
      FOR rec IN EXECUTE query
      LOOP
        RETURN TRUE; -- they share an element
      END LOOP;
      RETURN FALSE; -- no elements shared
  --
  ---------------------------------------------------------
      

    ELSIF tg2.type = 2 THEN -- point/line
  ---------------------------------------------------------
  -- 
  --  A [multi]point intersects a [multi]line if they share
  --  any Node. 
  --
  --
  --
      query =
        'SELECT a.topogeo_id FROM '
        || quote_ident(toponame) ||
        '.relation a, '
        || quote_ident(toponame) ||
        '.relation b, '
        || quote_ident(toponame) ||
        '.edge_data e '
        || 'WHERE a.layer_id = ' || tg1.layer_id
        || ' AND b.layer_id = ' || tg2.layer_id
        || ' AND a.topogeo_id = ' || tg1.id
        || ' AND b.topogeo_id = ' || tg2.id
        || ' AND abs(b.element_id) = e.edge_id '
        || ' AND ( '
          || ' e.start_node = a.element_id '
          || ' OR '
          || ' e.end_node = a.element_id '
        || ' )'
        || ' LIMIT 1';
      --RAISE NOTICE '%', query;
      FOR rec IN EXECUTE query
      LOOP
        RETURN TRUE; -- they share an element
      END LOOP;
      RETURN FALSE; -- no elements shared
  --
  ---------------------------------------------------------

    ELSIF tg2.type = 3 THEN -- point/polygon
  ---------------------------------------------------------
  -- 
  --  A [multi]point intersects a [multi]polygon if any
  --  Node of the point is contained in any face of the
  --  polygon OR ( is end_node or start_node of any edge
  --  of any polygon face ).
  --
  --  We assume the Node-in-Face check is faster becasue
  --  there will be less Faces then Edges in any polygon.
  --
  --
  --
  --
      -- Check if any node is contained in a face
      query =
        'SELECT n.node_id as id FROM '
        || quote_ident(toponame) ||
        '.relation r1, '
        || quote_ident(toponame) ||
        '.relation r2, '
        || quote_ident(toponame) ||
        '.node n '
        || 'WHERE r1.layer_id = ' || tg1.layer_id
        || ' AND r2.layer_id = ' || tg2.layer_id
        || ' AND r1.topogeo_id = ' || tg1.id
        || ' AND r2.topogeo_id = ' || tg2.id
        || ' AND n.node_id = r1.element_id '
        || ' AND r2.element_id = n.containing_face '
        || ' LIMIT 1';
      --RAISE NOTICE '%', query;
      FOR rec IN EXECUTE query
      LOOP
        --RAISE NOTICE 'Node % in polygon face', rec.id;
        RETURN TRUE; -- one (or more) nodes are
                     -- contained in a polygon face
      END LOOP;

      -- Check if any node is start or end of any polygon
      -- face edge
      query =
        'SELECT n.node_id as nid, e.edge_id as eid '
        || ' FROM '
        || quote_ident(toponame) ||
        '.relation r1, '
        || quote_ident(toponame) ||
        '.relation r2, '
        || quote_ident(toponame) ||
        '.edge_data e, '
        || quote_ident(toponame) ||
        '.node n '
        || 'WHERE r1.layer_id = ' || tg1.layer_id
        || ' AND r2.layer_id = ' || tg2.layer_id
        || ' AND r1.topogeo_id = ' || tg1.id
        || ' AND r2.topogeo_id = ' || tg2.id
        || ' AND n.node_id = r1.element_id '
        || ' AND ( '
        || ' e.left_face = r2.element_id '
        || ' OR '
        || ' e.right_face = r2.element_id '
        || ' ) '
        || ' AND ( '
        || ' e.start_node = r1.element_id '
        || ' OR '
        || ' e.end_node = r1.element_id '
        || ' ) '
        || ' LIMIT 1';
      --RAISE NOTICE '%', query;
      FOR rec IN EXECUTE query
      LOOP
        --RAISE NOTICE 'Node % on edge % bound', rec.nid, rec.eid;
        RETURN TRUE; -- one node is start or end
                     -- of a face edge
      END LOOP;

      RETURN FALSE; -- no intersection
  --
  ---------------------------------------------------------

    ELSIF tg2.type = 4 THEN -- point/collection
      RAISE EXCEPTION 'Intersection point/collection not implemented yet';

    ELSE
      RAISE EXCEPTION 'Invalid TopoGeometry type %', tg2.type;
    END IF;

  ELSIF tg1.type = 2 THEN -- [multi]line
    IF tg2.type = 2 THEN -- line/line
  ---------------------------------------------------------
  -- 
  --  A [multi]line intersects a [multi]line if they share
  --  any Node. 
  --
  --
  --
      query =
        'SELECT e1.start_node FROM '
        || quote_ident(toponame) ||
        '.relation r1, '
        || quote_ident(toponame) ||
        '.relation r2, '
        || quote_ident(toponame) ||
        '.edge_data e1, '
        || quote_ident(toponame) ||
        '.edge_data e2 '
        || 'WHERE r1.layer_id = ' || tg1.layer_id
        || ' AND r2.layer_id = ' || tg2.layer_id
        || ' AND r1.topogeo_id = ' || tg1.id
        || ' AND r2.topogeo_id = ' || tg2.id
        || ' AND abs(r1.element_id) = e1.edge_id '
        || ' AND abs(r2.element_id) = e2.edge_id '
        || ' AND ( '
        || ' e1.start_node = e2.start_node '
        || ' OR '
        || ' e1.start_node = e2.end_node '
        || ' OR '
        || ' e1.end_node = e2.start_node '
        || ' OR '
        || ' e1.end_node = e2.end_node '
        || ' )'
        || ' LIMIT 1';
      --RAISE NOTICE '%', query;
      FOR rec IN EXECUTE query
      LOOP
        RETURN TRUE; -- they share an element
      END LOOP;
      RETURN FALSE; -- no elements shared
  --
  ---------------------------------------------------------

    ELSIF tg2.type = 3 THEN -- line/polygon
  ---------------------------------------------------------
  -- 
  -- A [multi]line intersects a [multi]polygon if they share
  -- any Node (touch-only case), or if any line edge has any
  -- polygon face on the left or right (full-containment case
  -- + edge crossing case).
  --
  --
      -- E1 are line edges, E2 are polygon edges
      -- R1 are line relations.
      -- R2 are polygon relations.
      -- R2.element_id are FACE ids
      query =
        'SELECT e1.edge_id'
        || ' FROM '
        || quote_ident(toponame) ||
        '.relation r1, '
        || quote_ident(toponame) ||
        '.relation r2, '
        || quote_ident(toponame) ||
        '.edge_data e1, '
        || quote_ident(toponame) ||
        '.edge_data e2 '
        || 'WHERE r1.layer_id = ' || tg1.layer_id
        || ' AND r2.layer_id = ' || tg2.layer_id
        || ' AND r1.topogeo_id = ' || tg1.id
        || ' AND r2.topogeo_id = ' || tg2.id

        -- E1 are line edges
        || ' AND e1.edge_id = abs(r1.element_id) '

        -- E2 are face edges
        || ' AND ( e2.left_face = r2.element_id '
        || '   OR e2.right_face = r2.element_id ) '

        || ' AND ( '

        -- Check if E1 have left-or-right face 
        -- being part of R2.element_id
        || ' e1.left_face = r2.element_id '
        || ' OR '
        || ' e1.right_face = r2.element_id '

        -- Check if E1 share start-or-end node
        -- with any E2.
        || ' OR '
        || ' e1.start_node = e2.start_node '
        || ' OR '
        || ' e1.start_node = e2.end_node '
        || ' OR '
        || ' e1.end_node = e2.start_node '
        || ' OR '
        || ' e1.end_node = e2.end_node '

        || ' ) '

        || ' LIMIT 1';
      --RAISE NOTICE '%', query;
      FOR rec IN EXECUTE query
      LOOP
        RETURN TRUE; -- either common node
                     -- or edge-in-face
      END LOOP;

      RETURN FALSE; -- no intersection
  --
  ---------------------------------------------------------

    ELSIF tg2.type = 4 THEN -- line/collection
      RAISE EXCEPTION 'Intersection line/collection not implemented yet';

    ELSE
      RAISE EXCEPTION 'Invalid TopoGeometry type %', tg2.type;
    END IF;


  ELSIF tg1.type = 3 THEN -- [multi]polygon

    IF tg2.type = 3 THEN -- polygon/polygon
  ---------------------------------------------------------
  -- 
  -- A [multi]polygon intersects a [multi]polygon if they share
  -- any Node (touch-only case), or if any face edge has any of the
  -- other polygon face on the left or right (full-containment case
  -- + edge crossing case).
  --
  --
      -- E1 are poly1 edges.
      -- E2 are poly2 edges
      -- R1 are poly1 relations.
      -- R2 are poly2 relations.
      -- R1.element_id are poly1 FACE ids
      -- R2.element_id are poly2 FACE ids
      query =
        'SELECT e1.edge_id'
        || ' FROM '
        || quote_ident(toponame) ||
        '.relation r1, '
        || quote_ident(toponame) ||
        '.relation r2, '
        || quote_ident(toponame) ||
        '.edge_data e1, '
        || quote_ident(toponame) ||
        '.edge_data e2 '
        || 'WHERE r1.layer_id = ' || tg1.layer_id
        || ' AND r2.layer_id = ' || tg2.layer_id
        || ' AND r1.topogeo_id = ' || tg1.id
        || ' AND r2.topogeo_id = ' || tg2.id

        -- E1 are poly1 edges
        || ' AND ( e1.left_face = r1.element_id '
        || '   OR e1.right_face = r1.element_id ) '

        -- E2 are poly2 edges
        || ' AND ( e2.left_face = r2.element_id '
        || '   OR e2.right_face = r2.element_id ) '

        || ' AND ( '

        -- Check if any edge from a polygon face
        -- has any of the other polygon face
        -- on the left or right 
        || ' e1.left_face = r2.element_id '
        || ' OR '
        || ' e1.right_face = r2.element_id '
        || ' OR '
        || ' e2.left_face = r1.element_id '
        || ' OR '
        || ' e2.right_face = r1.element_id '

        -- Check if E1 share start-or-end node
        -- with any E2.
        || ' OR '
        || ' e1.start_node = e2.start_node '
        || ' OR '
        || ' e1.start_node = e2.end_node '
        || ' OR '
        || ' e1.end_node = e2.start_node '
        || ' OR '
        || ' e1.end_node = e2.end_node '

        || ' ) '

        || ' LIMIT 1';
      --RAISE NOTICE '%', query;
      FOR rec IN EXECUTE query
      LOOP
        RETURN TRUE; -- either common node
                     -- or edge-in-face
      END LOOP;

      RETURN FALSE; -- no intersection
  --
  ---------------------------------------------------------

    ELSIF tg2.type = 4 THEN -- polygon/collection
      RAISE EXCEPTION 'Intersection poly/collection not implemented yet';

    ELSE
      RAISE EXCEPTION 'Invalid TopoGeometry type %', tg2.type;
    END IF;

  ELSIF tg1.type = 4 THEN -- collection
    IF tg2.type = 4 THEN -- collection/collection
      RAISE EXCEPTION 'Intersection collection/collection not implemented yet';
    ELSE
      RAISE EXCEPTION 'Invalid TopoGeometry type %', tg2.type;
    END IF;

  ELSE
    RAISE EXCEPTION 'Invalid TopoGeometry type %', tg1.type;
  END IF;
END
$$
LANGUAGE 'plpgsql' STABLE STRICT;
--} intersects(TopoGeometry, TopoGeometry)

--{
--  equals(TopoGeometry, TopoGeometry)
--
CREATE OR REPLACE FUNCTION topology.equals(tg1 topology.TopoGeometry, tg2 topology.TopoGeometry)
  RETURNS bool
AS
$$
DECLARE
  rec RECORD;
  toponame varchar;
  query text;
BEGIN

  IF tg1.topology_id != tg2.topology_id THEN
    -- TODO: revert to ::geometry instead ?
    RAISE EXCEPTION 'Cannot compare TopoGeometries from different topologies';
  END IF;

  -- Not the same type, not equal
  IF tg1.type != tg2.type THEN
    RETURN FALSE;
  END IF;

  -- Geometry collection are not currently supported
  IF tg2.type = 4 THEN
    RAISE EXCEPTION 'GeometryCollection are not supported by equals()';
  END IF;

        -- Get topology name
        SELECT name FROM topology.topology into toponame
                WHERE id = tg1.topology_id;

  -- Two geometries are equal if they are composed by 
  -- the same TopoElements
  FOR rec IN EXECUTE 'SELECT * FROM '
    || ' topology.GetTopoGeomElements('
    || quote_literal(toponame) || ', '
    || tg1.layer_id || ',' || tg1.id || ') '
    || ' EXCEPT SELECT * FROM '
    || ' topology.GetTopogeomElements('
    || quote_literal(toponame) || ', '
    || tg2.layer_id || ',' || tg2.id || ');'
  LOOP
    RETURN FALSE;
  END LOOP;

  FOR rec IN EXECUTE 'SELECT * FROM '
    || ' topology.GetTopoGeomElements('
    || quote_literal(toponame) || ', '
    || tg2.layer_id || ',' || tg2.id || ')'
    || ' EXCEPT SELECT * FROM '
    || ' topology.GetTopogeomElements('
    || quote_literal(toponame) || ', '
    || tg1.layer_id || ',' || tg1.id || '); '
  LOOP
    RETURN FALSE;
  END LOOP;
  RETURN TRUE;
END
$$
LANGUAGE 'plpgsql' STABLE STRICT;
--} equals(TopoGeometry, TopoGeometry)


--  Querying
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- 
-- PostGIS - Spatial Types for PostgreSQL
-- http://postgis.net
--
-- Copyright (C) 2011 Andrea Peri <aperi2007@gmail.com>
--
-- This is free software; you can redistribute and/or modify it under
-- the terms of the GNU General Public Licence. See the COPYING file.
--
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

-- {
--
-- Andrea Peri (19 Jan 2011) creation
-- Andrea Peri (14 Feb 2011) minor issues
--
-- getnodebypoint(atopology, point, tolerance)
--
-- Retrieve a Node ID given a POINT and a tolerance
-- tolerance = 0 mean exactly intersection
--
-- Returns the integer ID if there is a Node on the Point.
--
-- If there isn't any node in the Point, GetNodeByPoint return 0.
--
-- if near the point there are two or more nodes it throw an exception.
--
CREATE OR REPLACE FUNCTION topology.GetNodeByPoint(atopology varchar, apoint geometry, tol1 float8)
	RETURNS int AS
	'$libdir/postgis_topology-2.2', 'GetNodeByPoint'
	LANGUAGE 'c' STABLE STRICT;
--} GetNodeByPoint

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- 
-- PostGIS - Spatial Types for PostgreSQL
-- http://postgis.net
--
-- Copyright (C) 2011 Andrea Peri <aperi2007@gmail.com>
--
-- This is free software; you can redistribute and/or modify it under
-- the terms of the GNU General Public Licence. See the COPYING file.
--
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

--{
--
-- Andrea Peri (19 Jan 2011) creation
-- Andrea Peri (14 Feb 2011) minor issues
--
-- GetEdgeByPoint(atopology, point, tol)
--
-- Retrieve an Edge ID given a POINT and a tolerance
-- tolerance = 0 mean exactly intersection
--
-- Returns return the integer ID if there is an edge on the Point.
--
-- When the Point is even a Node it raise an exception. 
-- This case is testable with the GetNodeByPoint(atopology, apoint, tol)
--
-- If there isn't any edge in the Point, GetEdgeByPoint return 0.
--
-- if near the point there are two or more edges it throw an exception.
--
CREATE OR REPLACE FUNCTION topology.GetEdgeByPoint(atopology varchar, apoint geometry, tol1 float8)
	RETURNS int AS
	'$libdir/postgis_topology-2.2', 'GetEdgeByPoint'
	LANGUAGE 'c' STABLE STRICT;
--} GetEdgeByPoint
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- 
-- PostGIS - Spatial Types for PostgreSQL
-- http://postgis.net
--
-- Copyright (C) 2011 Andrea Peri <aperi2007@gmail.com>
--
-- This is free software; you can redistribute and/or modify it under
-- the terms of the GNU General Public Licence. See the COPYING file.
--
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

--{
--
-- Andrea Peri (27 Feb 2011) creation
--
-- GetFaceByPoint(atopology, point, tol)
--
-- Retrieve a Face ID given a POINT and a tolerance
-- tolerance = 0 mean exactly intersection
--
-- Returns return the integer ID if there is a face on the Point.
--
-- When the Point is even a Node it raise an exception. 
-- This case is testable with the GetNodeByPoint(atopology, apoint, tol)
--
-- If there isn't any face in the Point, GetFaceByPoint return 0.
--
-- if near the point there are two or more faces it throw an exception.
--
CREATE OR REPLACE FUNCTION topology.GetFaceByPoint(atopology varchar, apoint geometry, tol1 float8)
	RETURNS int AS
	'$libdir/postgis_topology-2.2', 'GetFaceByPoint'
	LANGUAGE 'c' STABLE STRICT;
--} GetFaceByPoint


--  Populating
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- 
-- PostGIS - Spatial Types for PostgreSQL
-- http://postgis.net
--
-- Copyright (C) 2010-2012 Sandro Santilli <strk@keybit.net>
--
-- This is free software; you can redistribute and/or modify it under
-- the terms of the GNU General Public Licence. See the COPYING file.
--
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--
-- Functions used to populate a topology
--
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -



-- {
--  Compute the max size of the double-precision floating point grid
--  cell required to cover the given geometry
--
--
-- A pragmatic test conducted using algoritm shown here:
-- http://stackoverflow.com/questions/7408407/generate-next-largest-or-smallest-representable-floating-point-number-without-bi
-- showed the "tolerance" growing by an order of magnitude proportionally
-- with the order of magnitude of the input, starting with something like
-- 3.5527136788005009294e-15 for the starting value of 9.0
--
-- }{
CREATE OR REPLACE FUNCTION topology._st_mintolerance(ageom Geometry)
  RETURNS float8
AS $$
    SELECT 3.6 * power(10,  - ( 15 - log(coalesce(
      nullif(
        greatest(abs(ST_xmin($1)), abs(ST_ymin($1)),
                 abs(ST_xmax($1)), abs(ST_ymax($1))),
        0),
      1)) ));
$$ LANGUAGE 'sql' IMMUTABLE STRICT;
-- }

-- {
-- Get tolerance for a given topology
-- and if zero the minimum for the given geometry
--
-- }{
CREATE OR REPLACE FUNCTION topology._st_mintolerance(atopology varchar, ageom Geometry)
  RETURNS float8
AS $$
DECLARE
  ret FLOAT8;
BEGIN
  SELECT COALESCE(
    NULLIF(precision, 0),
    topology._st_mintolerance($2))
  FROM topology.topology
  WHERE name = $1 INTO ret;
  IF NOT FOUND THEN
    RAISE EXCEPTION
      'No topology with name "%" in topology.topology', atopology;
  END IF;
  return ret;
END;
$$ LANGUAGE 'plpgsql' STABLE STRICT;
-- }

--{
--
-- AddNode(atopology, point, allowEdgeSplitting, setContainingFace)
--
-- Add a node primitive to a topology and get its identifier.
-- Returns an existing node at the same location, if any.
--
-- When adding a _new_ node it checks for the existance of any
-- edge crossing the given point, raising an exception if found.
--
-- The newly added nodes have no containing face.
--
-- Developed by Sandro Santilli <strk@keybit.net>
-- for Faunalia (http://www.faunalia.it) with funding from
-- Regione Toscana - Sistema Informativo per la Gestione del Territorio
-- e dell' Ambiente [RT-SIGTA].
-- For the project: "Sviluppo strumenti software per il trattamento di dati
-- geografici basati su QuantumGIS e Postgis (CIG 0494241492)"
--
-- }{
CREATE OR REPLACE FUNCTION topology.AddNode(atopology varchar, apoint geometry, allowEdgeSplitting boolean, setContainingFace boolean DEFAULT false)
	RETURNS int
AS
$$
DECLARE
	nodeid int;
	rec RECORD;
  containing_face int;
BEGIN
	--
	-- Atopology and apoint are required
	-- 
	IF atopology IS NULL OR apoint IS NULL THEN
		RAISE EXCEPTION 'Invalid null argument';
	END IF;

	--
	-- Apoint must be a point
	--
	IF substring(geometrytype(apoint), 1, 5) != 'POINT'
	THEN
		RAISE EXCEPTION 'Node geometry must be a point';
	END IF;

	--
	-- Check if a coincident node already exists
	-- 
	-- We use index AND x/y equality
	--
	FOR rec IN EXECUTE 'SELECT node_id FROM '
		|| quote_ident(atopology) || '.node ' ||
		'WHERE geom && $1 AND ST_X(geom) = ST_X($1) AND ST_Y(geom) = ST_Y($1)'
    USING apoint
	LOOP
		RETURN  rec.node_id;
	END LOOP;

	--
	-- Check if any edge crosses this node
	-- (endpoints are fine)
	--
	FOR rec IN EXECUTE 'SELECT edge_id FROM '
		|| quote_ident(atopology) || '.edge ' 
		|| 'WHERE ST_DWithin($1, geom, 0) AND '
    || 'NOT ST_Equals($1, ST_StartPoint(geom)) AND '
    || 'NOT ST_Equals($1, ST_EndPoint(geom))'
    USING apoint
	LOOP
    IF allowEdgeSplitting THEN
      RETURN topology.ST_ModEdgeSplit(atopology, rec.edge_id, apoint);
    ELSE
		  RAISE EXCEPTION 'An edge crosses the given node.';
    END IF;
	END LOOP;

  IF setContainingFace THEN
    containing_face := topology.GetFaceByPoint(atopology, apoint, 0);
  ELSE
    containing_face := NULL;
  END IF;

	--
	-- Get new node id from sequence
	--
	FOR rec IN EXECUTE 'SELECT nextval(' ||
		quote_literal(
			quote_ident(atopology) || '.node_node_id_seq'
		) || ')'
	LOOP
		nodeid = rec.nextval;
	END LOOP;

	--
	-- Insert the new row
	--
	EXECUTE 'INSERT INTO ' || quote_ident(atopology)
		|| '.node(node_id, containing_face, geom) 
		VALUES(' || nodeid || ',' || coalesce(containing_face::text, 'NULL')
    || ',$1)' USING apoint;

	RETURN nodeid;
	
END
$$
LANGUAGE 'plpgsql' VOLATILE;
--} AddNode

--{
--
-- AddNode(atopology, point)
--
CREATE OR REPLACE FUNCTION topology.AddNode(atopology varchar, apoint geometry)
	RETURNS int
AS
$$
  SELECT topology.AddNode($1, $2, false, false);
$$
LANGUAGE 'sql' VOLATILE;
--} AddNode

--{
--
-- AddEdge(atopology, line)
--
-- Add an edge primitive to a topology and get its identifier.
-- Edge endpoints will be added as nodes if missing.
-- Returns an existing edge at the same location, if any.
--
-- An exception is raised if the given line crosses an existing
-- node or interects with an existing edge on anything but endnodes.
--
-- The newly added edge has "universe" face on both sides
-- and links to itself as per next left/right edge.
-- Calling code is expected to do further linking.
--
-- Developed by Sandro Santilli <strk@keybit.net>
-- for Faunalia (http://www.faunalia.it) with funding from
-- Regione Toscana - Sistema Informativo per la Gestione del Territorio
-- e dell' Ambiente [RT-SIGTA].
-- For the project: "Sviluppo strumenti software per il trattamento di dati
-- geografici basati su QuantumGIS e Postgis (CIG 0494241492)"
-- 
CREATE OR REPLACE FUNCTION topology.AddEdge(atopology varchar, aline geometry)
	RETURNS int
AS
$$
DECLARE
	edgeid int;
	rec RECORD;
  ix geometry; 
BEGIN
	--
	-- Atopology and apoint are required
	-- 
	IF atopology IS NULL OR aline IS NULL THEN
		RAISE EXCEPTION 'Invalid null argument';
	END IF;

	--
	-- Aline must be a linestring
	--
	IF substring(geometrytype(aline), 1, 4) != 'LINE'
	THEN
		RAISE EXCEPTION 'Edge geometry must be a linestring';
	END IF;

	--
	-- Check there's no face registered in the topology
	--
	FOR rec IN EXECUTE 'SELECT count(face_id) FROM '
		|| quote_ident(atopology) || '.face '
		|| ' WHERE face_id != 0 LIMIT 1'
	LOOP
		IF rec.count > 0 THEN
			RAISE EXCEPTION 'AddEdge can only be used against topologies with no faces defined';
		END IF;
	END LOOP;

	--
	-- Check if the edge crosses an existing node
	--
	FOR rec IN EXECUTE 'SELECT node_id FROM '
		|| quote_ident(atopology) || '.node '
		|| 'WHERE ST_Crosses($1, geom)'
    USING aline
	LOOP
		RAISE EXCEPTION 'Edge crosses node %', rec.node_id;
	END LOOP;

	--
	-- Check if the edge intersects an existing edge
	-- on anything but endpoints
	--
	-- Following DE-9 Intersection Matrix represent
	-- the only relation we accept. 
	--
	--    F F 1
	--    F * *
	--    1 * 2
	--
	-- Example1: linestrings touching at one endpoint
	--    FF1 F00 102
	--    FF1 F** 1*2 <-- our match
	--
	-- Example2: linestrings touching at both endpoints
	--    FF1 F0F 1F2
	--    FF1 F** 1*2 <-- our match
	--
	FOR rec IN EXECUTE 'SELECT edge_id, geom, ST_Relate($1, geom, 2) as im FROM '
		|| quote_ident(atopology) || '.edge WHERE $1 && geom'
    USING aline
	LOOP

	  IF ST_RelateMatch(rec.im, 'FF1F**1*2') THEN
	    CONTINUE; -- no interior intersection
	  END IF;

	  -- Reuse an EQUAL edge (be it closed or not)
	  IF ST_RelateMatch(rec.im, '1FFF*FFF2') THEN
	      RETURN rec.edge_id;
	  END IF;

	  -- WARNING: the constructive operation might throw an exception
	  BEGIN
	    ix = ST_Intersection(rec.geom, aline);
	  EXCEPTION
	  WHEN OTHERS THEN
	    RAISE NOTICE 'Could not compute intersection between input edge (%) and edge % (%)', aline::text, rec.edge_id, rec.geom::text;
	  END;

	  RAISE EXCEPTION 'Edge intersects (not on endpoints) with existing edge % at or near point %', rec.edge_id, ST_AsText(ST_PointOnSurface(ix));

	END LOOP;

	--
	-- Get new edge id from sequence
	--
	FOR rec IN EXECUTE 'SELECT nextval(' ||
		quote_literal(
			quote_ident(atopology) || '.edge_data_edge_id_seq'
		) || ')'
	LOOP
		edgeid = rec.nextval;
	END LOOP;

	--
	-- Insert the new row
	--
	EXECUTE 'INSERT INTO '
		|| quote_ident(atopology)
		|| '.edge(edge_id, start_node, end_node, '
		|| 'next_left_edge, next_right_edge, '
		|| 'left_face, right_face, '
		|| 'geom) '
		|| ' VALUES('

		-- edge_id
		|| edgeid ||','

		-- start_node
		|| 'topology.addNode('
		|| quote_literal(atopology)
		|| ', ST_StartPoint($1)), '

		-- end_node
		|| 'topology.addNode('
		|| quote_literal(atopology)
		|| ', ST_EndPoint($1)), '

		-- next_left_edge
		|| -edgeid ||','

		-- next_right_edge
		|| edgeid ||','

		-- left_face
		|| '0,'

		-- right_face
		|| '0,'

		-- geom
		|| '$1)'
    USING aline;

	RETURN edgeid;
	
END
$$
LANGUAGE 'plpgsql' VOLATILE;
--} AddEdge

--{
--
-- AddFace(atopology, poly, [<force_new>=true])
--
-- Add a face primitive to a topology and get its identifier.
-- Returns an existing face at the same location, if any, unless
-- true is passed as the force_new argument
--
-- For a newly added face, its edges will be appropriately
-- linked (marked as left-face or right-face), and any contained
-- edges and nodes would also be marked as such.
--
-- When forcing re-registration of an existing face, no action will be
-- taken to deal with the face being substituted. Which means
-- a record about the old face and any record in the relation table
-- referencing the existing face will remain untouched, effectively
-- leaving the topology in a possibly invalid state.
-- It is up to the caller to deal with that.
--
-- The target topology is assumed to be valid (containing no
-- self-intersecting edges).
--
-- An exception is raised if:
--  o The polygon boundary is not fully defined by existing edges.
--  o The polygon overlaps an existing face.
--
-- Developed by Sandro Santilli <strk@keybit.net>
-- for Faunalia (http://www.faunalia.it) with funding from
-- Regione Toscana - Sistema Informativo per la Gestione del Territorio
-- e dell' Ambiente [RT-SIGTA].
-- For the project: "Sviluppo strumenti software per il trattamento di dati
-- geografici basati su QuantumGIS e Postgis (CIG 0494241492)"
-- 
CREATE OR REPLACE FUNCTION topology.AddFace(atopology varchar, apoly geometry, force_new boolean DEFAULT FALSE)
	RETURNS int
AS
$$
DECLARE
  bounds geometry;
  symdif geometry;
  faceid int;
  rec RECORD;
  rrec RECORD;
  relate text;
  right_edges int[];
  left_edges int[];
  all_edges geometry;
  old_faceid int;
  old_edgeid int;
  sql text;
  right_side bool;
  edgeseg geometry;
  p1 geometry;
  p2 geometry;
  p3 geometry;
  loc float8;
  segnum int;
  numsegs int;
BEGIN
  --
  -- Atopology and apoly are required
  -- 
  IF atopology IS NULL OR apoly IS NULL THEN
    RAISE EXCEPTION 'Invalid null argument';
  END IF;

  --
  -- Aline must be a polygon
  --
  IF substring(geometrytype(apoly), 1, 4) != 'POLY'
  THEN
    RAISE EXCEPTION 'Face geometry must be a polygon';
  END IF;

  for rrec IN SELECT (d).* FROM (
    SELECT ST_DumpRings(ST_ForceRHR(apoly)) d
  ) foo
  LOOP -- {
    --
    -- Find all bounds edges, forcing right-hand-rule
    -- to know what's left and what's right...
    --
    bounds = ST_Boundary(rrec.geom);

    sql := 'SELECT e.geom, e.edge_id, e.left_face, e.right_face FROM '
      || quote_ident(atopology)
      || '.edge e, (SELECT $1 as geom) r WHERE r.geom && e.geom'
    ;
    -- RAISE DEBUG 'SQL: %', sql;
    FOR rec IN EXECUTE sql USING bounds
    LOOP -- {
      --RAISE DEBUG 'Edge % has bounding box intersection', rec.edge_id;

      -- Find first non-empty segment of the edge
      numsegs = ST_NumPoints(rec.geom);
      segnum = 1;
      WHILE segnum < numsegs LOOP
        p1 = ST_PointN(rec.geom, segnum);
        p2 = ST_PointN(rec.geom, segnum+1);
        IF ST_Distance(p1, p2) > 0 THEN
          EXIT;
        END IF;
        segnum = segnum + 1;
      END LOOP;

      IF segnum = numsegs THEN
        RAISE WARNING 'Edge % is collapsed', rec.edge_id;
        CONTINUE; -- we don't want to spend time on it
      END IF;

      edgeseg = ST_MakeLine(p1, p2);

      -- Skip non-covered edges
      IF NOT ST_Equals(p2, ST_EndPoint(rec.geom)) THEN
        IF NOT ( _ST_Intersects(bounds, p1) AND _ST_Intersects(bounds, p2) )
        THEN
          --RAISE DEBUG 'Edge % has points % and % not intersecting with ring bounds', rec.edge_id, st_astext(p1), st_astext(p2);
          CONTINUE;
        END IF;
      ELSE
        -- must be a 2-points only edge, let's use Covers (more expensive)
        IF NOT _ST_Covers(bounds, edgeseg) THEN
          --RAISE DEBUG 'Edge % is not covered by ring', rec.edge_id;
          CONTINUE;
        END IF;
      END IF;

      p3 = ST_StartPoint(bounds);
      IF ST_DWithin(edgeseg, p3, 0) THEN
        -- Edge segment covers ring endpoint, See bug #874
        loc = ST_LineLocatePoint(edgeseg, p3);
        -- WARNING: this is as robust as length of edgeseg allows...
        IF loc > 0.9 THEN
          -- shift last point down 
          p2 = ST_LineInterpolatePoint(edgeseg, loc - 0.1);
        ELSIF loc < 0.1 THEN
          -- shift first point up
          p1 = ST_LineInterpolatePoint(edgeseg, loc + 0.1); 
        ELSE
          -- when ring start point is in between, we swap the points
          p3 = p1; p1 = p2; p2 = p3;
        END IF;
      END IF;

      right_side = ST_LineLocatePoint(bounds, p1) < 
                   ST_LineLocatePoint(bounds, p2);
  

      IF right_side THEN
        right_edges := array_append(right_edges, rec.edge_id);
        old_faceid = rec.right_face;
      ELSE
        left_edges := array_append(left_edges, rec.edge_id);
        old_faceid = rec.left_face;
      END IF;

      IF faceid IS NULL OR faceid = 0 THEN
        faceid = old_faceid;
        old_edgeid = rec.edge_id;
      ELSIF faceid != old_faceid THEN
        RAISE EXCEPTION 'Edge % has face % registered on the side of this face, while edge % has face % on the same side', rec.edge_id, old_faceid, old_edgeid, faceid;
      END IF;

      -- Collect all edges for final full coverage check
      all_edges = ST_Collect(all_edges, rec.geom);

    END LOOP; -- }
  END LOOP; -- }

  IF all_edges IS NULL THEN
    RAISE EXCEPTION 'Found no edges on the polygon boundary';
  END IF;


  --
  -- Check that all edges found, taken togheter,
  -- fully match the ring boundary and nothing more
  --
  -- If the test fail either we need to add more edges
  -- from the polygon ring or we need to split
  -- some of the existing ones.
  -- 
  bounds = ST_Boundary(apoly);
  IF NOT ST_isEmpty(ST_SymDifference(bounds, all_edges)) THEN
    IF NOT ST_isEmpty(ST_Difference(bounds, all_edges)) THEN
      RAISE EXCEPTION 'Polygon boundary is not fully defined by existing edges at or near point %', ST_AsText(ST_PointOnSurface(ST_Difference(bounds, all_edges)));
    ELSE
      RAISE EXCEPTION 'Existing edges cover polygon boundary and more at or near point % (invalid topology?)', ST_AsText(ST_PointOnSurface(ST_Difference(all_edges, bounds)));
    END IF;
  END IF;

  IF faceid IS NOT NULL AND faceid != 0 THEN
    IF NOT force_new THEN
      RETURN faceid;
    ELSE
    END IF;
  END IF;

  --
  -- Get new face id from sequence
  --
  FOR rec IN EXECUTE 'SELECT nextval(' ||
    quote_literal(
      quote_ident(atopology) || '.face_face_id_seq'
    ) || ')'
  LOOP
    faceid = rec.nextval;
  END LOOP;

  --
  -- Insert new face 
  --
  EXECUTE 'INSERT INTO '
    || quote_ident(atopology)
    || '.face(face_id, mbr) VALUES('
    -- face_id
    || faceid || ','
    -- minimum bounding rectangle
    || '$1)'
    USING ST_Envelope(apoly);

  --
  -- Update all edges having this face on the left
  --
  IF left_edges IS NOT NULL THEN
    EXECUTE 'UPDATE '
    || quote_ident(atopology)
    || '.edge_data SET left_face = '
    || quote_literal(faceid)
    || ' WHERE edge_id = ANY('
    || quote_literal(left_edges)
    || ') ';
  END IF;

  --
  -- Update all edges having this face on the right
  --
  IF right_edges IS NOT NULL THEN
    EXECUTE 'UPDATE '
    || quote_ident(atopology)
    || '.edge_data SET right_face = '
    || quote_literal(faceid)
    || ' WHERE edge_id = ANY('
    || quote_literal(right_edges)
    || ') ';
  END IF;


  --
  -- Set left_face/right_face of any contained edge 
  --
  EXECUTE 'UPDATE '
    || quote_ident(atopology)
    || '.edge_data SET right_face = '
    || quote_literal(faceid)
    || ', left_face = '
    || quote_literal(faceid)
    || ' WHERE ST_Contains($1, geom)'
    USING apoly;

  -- 
  -- Set containing_face of any contained node 
  -- 
  EXECUTE 'UPDATE '
    || quote_ident(atopology)
    || '.node SET containing_face = '
    || quote_literal(faceid)
    || ' WHERE containing_face IS NOT NULL AND ST_Contains($1, geom)'
    USING apoly;

  RETURN faceid;
	
END
$$
LANGUAGE 'plpgsql' VOLATILE;
--} AddFace

-- ----------------------------------------------------------------------------
-- 
-- Functions to incrementally populate a topology
-- 
-- ----------------------------------------------------------------------------

--{
--  TopoGeo_AddPoint(toponame, pointgeom, tolerance)
--
--  Add a Point into a topology, with an optional tolerance 
--
CREATE OR REPLACE FUNCTION topology.TopoGeo_AddPoint(atopology varchar, apoint geometry, tolerance float8 DEFAULT 0)
	RETURNS int AS
	'$libdir/postgis_topology-2.2', 'TopoGeo_AddPoint'
  LANGUAGE 'c' VOLATILE;
--} TopoGeo_AddPoint

--{
--  TopoGeo_addLinestring(toponame, linegeom, tolerance)
--
--  Add a LineString into a topology 
--
-- }{
CREATE OR REPLACE FUNCTION topology.TopoGeo_addLinestring(atopology varchar, aline geometry, tolerance float8 DEFAULT 0)
	RETURNS SETOF int AS
	'$libdir/postgis_topology-2.2', 'TopoGeo_AddLinestring'
  LANGUAGE 'c' VOLATILE;
--} TopoGeo_addLinestring

--{
--  TopoGeo_AddPolygon(toponame, polygeom, tolerance)
--
--  Add a Polygon into a topology 
--
-- }{
CREATE OR REPLACE FUNCTION topology.TopoGeo_AddPolygon(atopology varchar, apoly geometry, tolerance float8 DEFAULT 0)
	RETURNS SETOF int AS
	'$libdir/postgis_topology-2.2', 'TopoGeo_AddPolygon'
  LANGUAGE 'c' VOLATILE;
--} TopoGeo_AddPolygon

--{
--  TopoGeo_AddGeometry(toponame, geom, tolerance)
--
--  Add a Geometry into a topology 
--
CREATE OR REPLACE FUNCTION topology.TopoGeo_AddGeometry(atopology varchar, ageom geometry, tolerance float8 DEFAULT 0)
	RETURNS void AS
$$
DECLARE
BEGIN
	RAISE EXCEPTION 'TopoGeo_AddGeometry not implemented yet';
END
$$
LANGUAGE 'plpgsql';
--} TopoGeo_AddGeometry
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- 
-- PostGIS - Spatial Types for PostgreSQL
-- http://postgis.net
--
-- Copyright (C) 2011 Sandro Santilli <strk@keybit.net>
--
-- This is free software; you can redistribute and/or modify it under
-- the terms of the GNU General Public Licence. See the COPYING file.
--
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--
-- Functions used to polygonize topology edges
--
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

--{
--
-- int Polygonize(toponame)
--
-- TODO: allow restricting polygonization to a bounding box
--
-- }{
CREATE OR REPLACE FUNCTION topology.polygonize(toponame varchar)
  RETURNS text
AS
$$
DECLARE
  sql text;
  rec RECORD;
  faces int;
BEGIN

  sql := 'SELECT (st_dump(st_polygonize(geom))).geom from '
         || quote_ident(toponame) || '.edge_data';

  faces = 0;
  FOR rec in EXECUTE sql LOOP
    BEGIN
      PERFORM topology.AddFace(toponame, rec.geom);
      faces = faces + 1;
    EXCEPTION
      WHEN OTHERS THEN
        RAISE WARNING 'Error registering face % (%)', rec.geom, SQLERRM;
    END;
  END LOOP;
  RETURN faces || ' faces registered';
END
$$
LANGUAGE 'plpgsql';
--} Polygonize(toponame)

--  TopoElement
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- 
-- PostGIS - Spatial Types for PostgreSQL
-- http://postgis.net
--
-- Copyright (C) 2010, 2011 Sandro Santilli <strk@keybit.net>
--
-- This is free software; you can redistribute and/or modify it under
-- the terms of the GNU General Public Licence. See the COPYING file.
--
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--
-- TopoElement management functions 
--
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--
-- Developed by Sandro Santilli <strk@keybit.net>
-- for Faunalia (http://www.faunalia.it) with funding from
-- Regione Toscana - Sistema Informativo per la Gestione del Territorio
-- e dell' Ambiente [RT-SIGTA].
-- For the project: "Sviluppo strumenti software per il trattamento di dati
-- geografici basati su QuantumGIS e Postgis (CIG 0494241492)"
--
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

--{
--
-- TopoElementArray TopoElementArray_append(<TopoElement>)
--
-- Append a TopoElement to a TopoElementArray
--
CREATE OR REPLACE FUNCTION topology.TopoElementArray_append(topology.TopoElementArray, topology.TopoElement)
	RETURNS topology.TopoElementArray
AS
$$
	SELECT CASE
		WHEN $1 IS NULL THEN
			topology.TopoElementArray('{' || $2::text || '}')
		ELSE
			topology.TopoElementArray($1::int[][]||$2::int[])
		END;
$$
LANGUAGE 'sql' IMMUTABLE;
--} TopoElementArray_append

--{
--
-- TopoElementArray TopoElementArray_agg(<setof TopoElement>)
--
-- Aggregates a set of TopoElement values into a TopoElementArray
--
-- Availability: 2.0.0
DROP AGGREGATE IF EXISTS topology.TopoElementArray_agg(topology.TopoElement);
CREATE AGGREGATE topology.TopoElementArray_agg(
	sfunc = topology.TopoElementArray_append,
	basetype = topology.TopoElement,
	stype = topology.TopoElementArray
	);
--} TopoElementArray_agg

--  TopoGeometry
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- 
-- PostGIS - Spatial Types for PostgreSQL
-- http://postgis.net
--
-- Copyright (C) 2011 Sandro Santilli <strk@keybit.net>
--
-- This is free software; you can redistribute and/or modify it under
-- the terms of the GNU General Public Licence. See the COPYING file.
--
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

-- {
--  Override geometrytype() for topogeometry objects
--
--  Note: For performance reasons, this function always assumes
--        TopoGeometry are of the MULTI type. This may not always
--        be the case if you convert the TopoGeometry to an actual
--        Geometry.
--
-- }{
CREATE OR REPLACE FUNCTION topology.GeometryType(tg topology.TopoGeometry)
	RETURNS text
AS
$$
	SELECT CASE
		WHEN type($1) = 1 THEN 'MULTIPOINT'
		WHEN type($1) = 2 THEN 'MULTILINESTRING'
		WHEN type($1) = 3 THEN 'MULTIPOLYGON'
		WHEN type($1) = 4 THEN 'GEOMETRYCOLLECTION'
		ELSE 'UNEXPECTED'
		END;
$$
LANGUAGE 'sql' STABLE STRICT;
-- }

-- {
--  Override st_geometrytype() for topogeometry objects
--
--  Note: For performance reasons, this function always assumes
--        TopoGeometry are of the MULTI type. This may not always
--        be the case if you convert the TopoGeometry to an actual
--        Geometry.
--
-- }{
CREATE OR REPLACE FUNCTION topology.ST_GeometryType(tg topology.TopoGeometry)
	RETURNS text
AS
$$
	SELECT CASE
		WHEN type($1) = 1 THEN 'ST_MultiPoint'
		WHEN type($1) = 2 THEN 'ST_MultiLinestring'
		WHEN type($1) = 3 THEN 'ST_MultiPolygon'
		WHEN type($1) = 4 THEN 'ST_GeometryCollection'
		ELSE 'ST_Unexpected'
		END;
$$
LANGUAGE 'sql' STABLE STRICT;
-- }
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- 
-- PostGIS - Spatial Types for PostgreSQL
-- http://postgis.net
--
-- Copyright (C) 2012 Sandro Santilli <strk@keybit.net>
--
-- This is free software; you can redistribute and/or modify it under
-- the terms of the GNU General Public Licence. See the COPYING file.
--
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

-- {
--  Clear the contents of a TopoGeometry 
--
-- }{
CREATE OR REPLACE FUNCTION topology.clearTopoGeom(tg topology.TopoGeometry)
  RETURNS topology.TopoGeometry
AS
$$
DECLARE
  topology_info RECORD;
  sql TEXT;
BEGIN

  -- Get topology information
  SELECT id, name FROM topology.topology
    INTO topology_info
    WHERE id = topology_id(tg);
  IF NOT FOUND THEN
      RAISE EXCEPTION 'No topology with id "%" in topology.topology', topology_id(tg);
  END IF;

  -- Clear the TopoGeometry contents
  sql := 'DELETE FROM ' || quote_ident(topology_info.name)
        || '.relation WHERE layer_id = '
        || layer_id(tg)
        || ' AND topogeo_id = '
        || id(tg);
  EXECUTE sql;


  RETURN tg;

END
$$
LANGUAGE 'plpgsql' VOLATILE STRICT;
-- }

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- 
-- PostGIS - Spatial Types for PostgreSQL
-- http://postgis.net
--
-- Copyright (C) 2012 Sandro Santilli <strk@keybit.net>
--
-- This is free software; you can redistribute and/or modify it under
-- the terms of the GNU General Public Licence. See the COPYING file.
--
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

-- {
--  Get a simplified geometry version from a TopoGeometry
--
--  Performs Douglas Peucker algorithm on each edge composing
--  the given TopoGeometry
--
-- }{
CREATE OR REPLACE FUNCTION topology.ST_Simplify(tg topology.TopoGeometry, tolerance float8)
  RETURNS geometry
AS
$$
DECLARE
  topology_info RECORD;
  layer_info RECORD;
  child_layer_info RECORD;
  geom geometry;
  sql TEXT;
BEGIN

  -- Get topology information
  SELECT id, name FROM topology.topology
    INTO topology_info
    WHERE id = tg.topology_id;
  IF NOT FOUND THEN
      RAISE EXCEPTION 'No topology with id "%" in topology.topology', tg.topology_id;
  END IF;

  -- Get layer info
  SELECT * FROM topology.layer
    WHERE topology_id = tg.topology_id
    AND layer_id = tg.layer_id
    INTO layer_info;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Could not find TopoGeometry layer % in topology %', tg.layer_id, tg.topology_id;
  END IF;

  --
  -- If this feature layer is on any level > 0 we will
  -- compute the topological union of all simplified child
  -- features in fact recursing.
  --
  IF layer_info.level > 0 THEN -- {

    -- Get child layer info
    SELECT * FROM topology.layer WHERE layer_id = layer_info.child_id
      AND topology_id = tg.topology_id
      INTO child_layer_info;
    IF NOT FOUND THEN
      RAISE EXCEPTION 'Invalid layer % in topology % (unexistent child layer %)', tg.layer_id, tg.topology_id, layer_info.child_id;
    END IF;

    sql := 'SELECT st_multi(st_union(topology.ST_Simplify('
      || quote_ident(child_layer_info.feature_column)
      || ',' || tolerance || '))) as geom FROM '
      || quote_ident(child_layer_info.schema_name) || '.'
      || quote_ident(child_layer_info.table_name)
      || ', ' || quote_ident(topology_info.name) || '.relation pr'
      || ' WHERE '
      || ' pr.topogeo_id = ' || tg.id
      || ' AND '
      || ' pr.layer_id = ' || tg.layer_id
      || ' AND '
      || ' id('||quote_ident(child_layer_info.feature_column)
      || ') = pr.element_id '
      || ' AND '
      || 'layer_id('||quote_ident(child_layer_info.feature_column)
      || ') = pr.element_type ';
    RAISE DEBUG '%', sql;
    EXECUTE sql INTO geom;

  ELSIF tg.type = 3 THEN -- [multi]polygon -- }{

    -- TODO: use ST_GetFaceEdges
    -- TODO: is st_unaryunion needed?
    sql := 'SELECT st_multi(st_unaryunion(ST_BuildArea(ST_Node(ST_Collect(ST_Simplify(geom, '
      || tolerance || ')))))) as geom FROM '
      || quote_ident(topology_info.name)
      || '.edge_data e, '
      || quote_ident(topology_info.name)
      || '.relation r WHERE ( e.left_face = r.element_id'
      || ' OR e.right_face = r.element_id )'
      || ' AND r.topogeo_id = ' || tg.id
      || ' AND r.layer_id = ' || tg.layer_id
      || ' AND element_type = 3 ';
    RAISE DEBUG '%', sql;
    EXECUTE sql INTO geom;


  ELSIF tg.type = 2 THEN -- [multi]line -- }{

    sql := 
      'SELECT st_multi(ST_LineMerge(ST_Node(ST_Collect(ST_Simplify(e.geom,'
      || tolerance || '))))) as g FROM '
      || quote_ident(topology_info.name) || '.edge e, '
      || quote_ident(topology_info.name) || '.relation r '
      || ' WHERE r.topogeo_id = ' || tg.id
      || ' AND r.layer_id = ' || tg.layer_id
      || ' AND r.element_type = 2 '
      || ' AND abs(r.element_id) = e.edge_id';
    EXECUTE sql INTO geom;
  
  ELSIF tg.type = 1 THEN -- [multi]point -- }{

    -- Can't simplify points... 
    geom := topology.Geometry(tg);

  ELSIF tg.type = 4 THEN -- mixed collection -- }{

   sql := 'WITH areas AS ( '
      || 'SELECT st_multi(st_union(ST_BuildArea(ST_Node(ST_Collect(ST_Simplify(geom, '
      || tolerance || ')))) as geom FROM '
      || quote_ident(topology_info.name)
      || '.edge_data e, '
      || quote_ident(topology_info.name)
      || '.relation r WHERE ( e.left_face = r.element_id'
      || ' OR e.right_face = r.element_id )'
      || ' AND r.topogeo_id = ' || tg.id
      || ' AND r.layer_id = ' || tg.layer_id
      || ' AND element_type = 3 ), '
      || 'lines AS ( '
      || 'SELECT st_multi(ST_LineMerge(ST_Collect(ST_Simplify(e.geom,'
      || tolerance || ')))) as g FROM '
      || quote_ident(topology_info.name) || '.edge e, '
      || quote_ident(topology_info.name) || '.relation r '
      || ' WHERE r.topogeo_id = ' || tg.id
      || ' AND r.layer_id = ' || tg.layer_id
      || ' AND r.element_type = 2 '
      || ' AND abs(r.element_id) = e.edge_id ), '
      || ' points as ( SELECT st_union(n.geom) as g FROM '
      || quote_ident(topology_info.name) || '.node n, '
      || quote_ident(topology_info.name) || '.relation r '
      || ' WHERE r.topogeo_id = ' || tg.id
      || ' AND r.layer_id = ' || tg.layer_id
      || ' AND r.element_type = 1 '
      || ' AND r.element_id = n.node_id ), '
      || ' un as ( SELECT g FROM areas UNION ALL SELECT g FROM lines '
      || '          UNION ALL SELECT g FROM points ) '
      || 'SELECT ST_Multi(ST_Collect(g)) FROM un';
    EXECUTE sql INTO geom;

  ELSE -- }{

    RAISE EXCEPTION 'Invalid TopoGeometries (unknown type %)', tg.type;

  END IF; -- }

  RETURN geom;

END
$$
LANGUAGE 'plpgsql' VOLATILE STRICT;
-- }

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- 
-- PostGIS - Spatial Types for PostgreSQL
-- http://postgis.net
--
-- Copyright (C) 2011-2012 Sandro Santilli <strk@keybit.net>
--
-- This is free software; you can redistribute and/or modify it under
-- the terms of the GNU General Public Licence. See the COPYING file.
--
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -



-- {
--  Convert a simple geometry to a topologically-defined one
--
--  See http://trac.osgeo.org/postgis/ticket/1017
--
-- }{
CREATE OR REPLACE FUNCTION topology.toTopoGeom(ageom Geometry, atopology varchar, alayer int, atolerance float8 DEFAULT 0)
  RETURNS topology.TopoGeometry
AS
$$
DECLARE
  layer_info RECORD;
  topology_info RECORD;
  tg topology.TopoGeometry;
  typ TEXT;
BEGIN

  -- Get topology information
  BEGIN
    SELECT *
    FROM topology.topology
      INTO STRICT topology_info WHERE name = atopology;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE EXCEPTION 'No topology with name "%" in topology.topology',
        atopology;
  END;

  -- Get layer information
  BEGIN
    SELECT *, CASE
      WHEN feature_type = 1 THEN 'puntal'
      WHEN feature_type = 2 THEN 'lineal'
      WHEN feature_type = 3 THEN 'areal'
      WHEN feature_type = 4 THEN 'mixed'
      ELSE 'unexpected_'||feature_type
      END as typename
    FROM topology.layer l
      INTO STRICT layer_info
      WHERE l.layer_id = alayer
      AND l.topology_id = topology_info.id;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE EXCEPTION 'No layer with id "%" in topology "%"',
        alayer, atopology;
  END;

  -- Can't convert to a hierarchical topogeometry
  IF layer_info.level > 0 THEN
      RAISE EXCEPTION 'Layer "%" of topology "%" is hierarchical, cannot convert to it.',
        alayer, atopology;
  END IF;


  -- 
  -- Check type compatibility and create empty TopoGeometry
  -- 1:puntal, 2:lineal, 3:areal, 4:collection
  --
  typ = geometrytype(ageom);
  IF typ = 'GEOMETRYCOLLECTION' THEN
    --  A collection can only go collection layer
    IF layer_info.feature_type != 4 THEN
      RAISE EXCEPTION
        'Layer "%" of topology "%" is %, cannot hold a collection feature.',
        layer_info.layer_id, topology_info.name, layer_info.typename;
    END IF;
    tg := topology.CreateTopoGeom(atopology, 4, alayer);
  ELSIF typ = 'POINT' OR typ = 'MULTIPOINT' THEN -- puntal
    --  A point can go in puntal or collection layer
    IF layer_info.feature_type != 4 and layer_info.feature_type != 1 THEN
      RAISE EXCEPTION
        'Layer "%" of topology "%" is %, cannot hold a puntal feature.',
        layer_info.layer_id, topology_info.name, layer_info.typename;
    END IF;
    tg := topology.CreateTopoGeom(atopology, 1, alayer);
  ELSIF typ = 'LINESTRING' or typ = 'MULTILINESTRING' THEN -- lineal
    --  A line can go in lineal or collection layer
    IF layer_info.feature_type != 4 and layer_info.feature_type != 2 THEN
      RAISE EXCEPTION
        'Layer "%" of topology "%" is %, cannot hold a lineal feature.',
        layer_info.layer_id, topology_info.name, layer_info.typename;
    END IF;
    tg := topology.CreateTopoGeom(atopology, 2, alayer);
  ELSIF typ = 'POLYGON' OR typ = 'MULTIPOLYGON' THEN -- areal
    --  An area can go in areal or collection layer
    IF layer_info.feature_type != 4 and layer_info.feature_type != 3 THEN
      RAISE EXCEPTION
        'Layer "%" of topology "%" is %, cannot hold an areal feature.',
        layer_info.layer_id, topology_info.name, layer_info.typename;
    END IF;
    tg := topology.CreateTopoGeom(atopology, 3, alayer);
  ELSE
      -- Should never happen
      RAISE EXCEPTION
        'Unsupported feature type %', typ;
  END IF;

  tg := topology.toTopoGeom(ageom, tg, atolerance);

  RETURN tg;

END
$$
LANGUAGE 'plpgsql' VOLATILE STRICT;
-- }

-- {
--  Convert a simple geometry to a topologically-defined one
--  adding its components to a pre-existing TopoGeometry
--
-- }{
CREATE OR REPLACE FUNCTION topology.toTopoGeom(ageom Geometry, tg topology.TopoGeometry, atolerance float8 DEFAULT 0)
  RETURNS topology.TopoGeometry
AS
$$
DECLARE
  layer_info RECORD;
  topology_info RECORD;
  rec RECORD;
  rec2 RECORD;
  elem TEXT;
  elems TEXT[];
  sql TEXT;
  typ TEXT;
  tolerance FLOAT8;
  alayer INT;
  atopology TEXT;
BEGIN


  -- Get topology information
  SELECT id, name FROM topology.topology
    INTO topology_info
    WHERE id = topology_id(tg);
  IF NOT FOUND THEN
    RAISE EXCEPTION 'No topology with id "%" in topology.topology',
                    topology_id(tg);
  END IF;

  alayer := layer_id(tg);
  atopology := topology_info.name;


  -- Get tolerance, if 0 was given
  tolerance := COALESCE( NULLIF(atolerance, 0), topology._st_mintolerance(topology_info.name, ageom) );

  -- Get layer information
  BEGIN
    SELECT *, CASE
      WHEN feature_type = 1 THEN 'puntal'
      WHEN feature_type = 2 THEN 'lineal'
      WHEN feature_type = 3 THEN 'areal'
      WHEN feature_type = 4 THEN 'mixed'
      ELSE 'unexpected_'||feature_type
      END as typename
    FROM topology.layer l
      INTO STRICT layer_info
      WHERE l.layer_id = layer_id(tg)
      AND l.topology_id = topology_info.id;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE EXCEPTION 'No layer with id "%" in topology "%"',
        alayer, atopology;
  END;

  -- Can't convert to a hierarchical topogeometry
  IF layer_info.level > 0 THEN
      RAISE EXCEPTION 'Layer "%" of topology "%" is hierarchical, cannot convert a simple geometry to it.',
        alayer, atopology;
  END IF;


  -- 
  -- Check type compatibility and set TopoGeometry type
  -- 1:puntal, 2:lineal, 3:areal, 4:collection
  --
  typ = geometrytype(ageom);
  IF typ = 'GEOMETRYCOLLECTION' THEN
    --  A collection can only go to collection layer
    IF layer_info.feature_type != 4 THEN
      RAISE EXCEPTION
        'Layer "%" of topology "%" is %, cannot hold a collection feature.',
        layer_info.layer_id, topology_info.name, layer_info.typename;
    END IF;
    tg.type := 4;
  ELSIF typ = 'POINT' OR typ = 'MULTIPOINT' THEN -- puntal
    --  A point can go in puntal or collection layer
    IF layer_info.feature_type != 4 and layer_info.feature_type != 1 THEN
      RAISE EXCEPTION
        'Layer "%" of topology "%" is %, cannot hold a puntal feature.',
        layer_info.layer_id, topology_info.name, layer_info.typename;
    END IF;
    tg.type := 1;
  ELSIF typ = 'LINESTRING' or typ = 'MULTILINESTRING' THEN -- lineal
    --  A line can go in lineal or collection layer
    IF layer_info.feature_type != 4 and layer_info.feature_type != 2 THEN
      RAISE EXCEPTION
        'Layer "%" of topology "%" is %, cannot hold a lineal feature.',
        layer_info.layer_id, topology_info.name, layer_info.typename;
    END IF;
    tg.type := 2;
  ELSIF typ = 'POLYGON' OR typ = 'MULTIPOLYGON' THEN -- areal
    --  An area can go in areal or collection layer
    IF layer_info.feature_type != 4 and layer_info.feature_type != 3 THEN
      RAISE EXCEPTION
        'Layer "%" of topology "%" is %, cannot hold an areal feature.',
        layer_info.layer_id, topology_info.name, layer_info.typename;
    END IF;
    tg.type := 3;
  ELSE
      -- Should never happen
      RAISE EXCEPTION
        'Unexpected feature dimension %', ST_Dimension(ageom);
  END IF;

  -- Now that we have an empty topogeometry, we loop over distinct components 
  -- and add them to the definition of it. We add them as soon
  -- as possible so that each element can further edit the
  -- definition by splitting
  FOR rec IN SELECT id(tg), alayer as lyr,
    geom, ST_Dimension(geom) as dims
    FROM (SELECT (ST_Dump(ageom)).geom) as f
    WHERE NOT ST_IsEmpty(geom)
  LOOP
    FOR rec2 IN SELECT CASE
       WHEN rec.dims = 0 THEN
         topology.topogeo_addPoint(atopology, rec.geom, tolerance)
       WHEN rec.dims = 1 THEN
         topology.topogeo_addLineString(atopology, rec.geom, tolerance)
       WHEN rec.dims = 2 THEN
         topology.topogeo_addPolygon(atopology, rec.geom, tolerance)
       END as primitive
    LOOP
      elem := ARRAY[rec.dims+1, rec2.primitive]::text;
      IF elems @> ARRAY[elem] THEN
      ELSE
        elems := elems || elem;
        -- TODO: consider use a single INSERT statement for the whole thing
        sql := 'INSERT INTO ' || quote_ident(atopology)
            || '.relation(topogeo_id, layer_id, element_type, element_id) VALUES ('
            || rec.id || ',' || rec.lyr || ',' || rec.dims+1
            || ',' || rec2.primitive || ')'
            -- NOTE: we're avoiding duplicated rows here
            || ' EXCEPT SELECT ' || rec.id || ', ' || rec.lyr
            || ', element_type, element_id FROM '
            || quote_ident(topology_info.name)
            || '.relation WHERE layer_id = ' || rec.lyr
            || ' AND topogeo_id = ' || rec.id;
        EXECUTE sql;
      END IF;
    END LOOP;
  END LOOP;

  RETURN tg;

END
$$
LANGUAGE 'plpgsql' VOLATILE STRICT;
-- }

--  Exports
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- 
-- PostGIS - Spatial Types for PostgreSQL
-- http://postgis.net
--
-- Copyright (C) 2010, 2011 Sandro Santilli <strk@keybit.net>
--
-- This is free software; you can redistribute and/or modify it under
-- the terms of the GNU General Public Licence. See the COPYING file.
--
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--
-- Functions used for topology GML output
--
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--
-- Developed by Sandro Santilli <strk@keybit.net>
-- for Faunalia (http://www.faunalia.it) with funding from
-- Regione Toscana - Sistema Informativo per la Gestione del Territorio
-- e dell' Ambiente [RT-SIGTA].
-- For the project: "Sviluppo strumenti software per il trattamento di dati
-- geografici basati su QuantumGIS e Postgis (CIG 0494241492)"
--
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

--{
--
-- INTERNAL FUNCTION
-- text _AsGMLNode(id, point, nsprefix, precision, options, idprefix, gmlver)
--
-- }{
CREATE OR REPLACE FUNCTION topology._AsGMLNode(id int, point geometry, nsprefix_in text, prec int, options int, idprefix text, gmlver int)
  RETURNS text
AS
$$
DECLARE
  nsprefix text;
  gml text;
BEGIN

  nsprefix := 'gml:';
  IF NOT nsprefix_in IS NULL THEN
    IF nsprefix_in = '' THEN
      nsprefix = nsprefix_in;
    ELSE
      nsprefix = nsprefix_in || ':';
    END IF;
  END IF;

  gml := '<' || nsprefix || 'Node ' || nsprefix
    || 'id="' || idprefix || 'N' || id || '"';
  IF point IS NOT NULL THEN
    gml = gml || '>'
              || '<' || nsprefix || 'pointProperty>'
              || ST_AsGML(gmlver, point, prec, options, nsprefix_in)
              || '</' || nsprefix || 'pointProperty>'
              || '</' || nsprefix || 'Node>';
  ELSE
    gml = gml || '/>';
  END IF;
  RETURN gml;
END
$$
LANGUAGE 'plpgsql' IMMUTABLE;
--} _AsGMLNode(id, point, nsprefix, precision, options, idprefix, gmlVersion)

--{
--
-- INTERNAL FUNCTION
-- text _AsGMLEdge(edge_id, start_node, end_node, line, visitedTable,
--                 nsprefix, precision, options, idprefix, gmlVersion)
--
-- }{
CREATE OR REPLACE FUNCTION topology._AsGMLEdge(edge_id int, start_node int,end_node int, line geometry, visitedTable regclass, nsprefix_in text, prec int, options int, idprefix text, gmlver int)
  RETURNS text
AS
$$
DECLARE
  visited bool;
  nsprefix text;
  gml text;
BEGIN

  nsprefix := 'gml:';
  IF nsprefix_in IS NOT NULL THEN
    IF nsprefix_in = '' THEN
      nsprefix = nsprefix_in;
    ELSE
      nsprefix = nsprefix_in || ':';
    END IF;
  END IF;

  gml := '<' || nsprefix || 'Edge ' || nsprefix
    || 'id="' || idprefix || 'E' || edge_id || '">';

  -- Start node
  gml = gml || '<' || nsprefix || 'directedNode orientation="-"';
  -- Do visited bookkeeping if visitedTable was given
  visited = NULL;
  IF visitedTable IS NOT NULL THEN
    EXECUTE 'SELECT true FROM '
            || visitedTable::text
            || ' WHERE element_type = 1 AND element_id = '
            || start_node LIMIT 1 INTO visited;
    IF visited IS NOT NULL THEN
      gml = gml || ' xlink:href="#' || idprefix || 'N' || start_node || '" />';
    ELSE
      -- Mark as visited 
      EXECUTE 'INSERT INTO ' || visitedTable::text
        || '(element_type, element_id) VALUES (1, '
        || start_node || ')';
    END IF;
  END IF;
  IF visited IS NULL THEN
    gml = gml || '>';
    gml = gml || topology._AsGMLNode(start_node, NULL, nsprefix_in,
                                     prec, options, idprefix, gmlver);
    gml = gml || '</' || nsprefix || 'directedNode>';
  END IF;

  -- End node
  gml = gml || '<' || nsprefix || 'directedNode';
  -- Do visited bookkeeping if visitedTable was given
  visited = NULL;
  IF visitedTable IS NOT NULL THEN
    EXECUTE 'SELECT true FROM '
            || visitedTable::text
            || ' WHERE element_type = 1 AND element_id = '
            || end_node LIMIT 1 INTO visited;
    IF visited IS NOT NULL THEN
      gml = gml || ' xlink:href="#' || idprefix || 'N' || end_node || '" />';
    ELSE
      -- Mark as visited 
      EXECUTE 'INSERT INTO ' || visitedTable::text
        || '(element_type, element_id) VALUES (1, '
        || end_node || ')';
    END IF;
  END IF;
  IF visited IS NULL THEN
    gml = gml || '>';
    gml = gml || topology._AsGMLNode(end_node, NULL, nsprefix_in,
                                     prec, options, idprefix, gmlver);
    gml = gml || '</' || nsprefix || 'directedNode>';
  END IF;

  IF line IS NOT NULL THEN
    gml = gml || '<' || nsprefix || 'curveProperty>'
              || ST_AsGML(gmlver, line, prec, options, nsprefix_in)
              || '</' || nsprefix || 'curveProperty>';
  END IF;

  gml = gml || '</' || nsprefix || 'Edge>';

  RETURN gml;
END
$$
LANGUAGE 'plpgsql' VOLATILE; -- writes into visitedTable
--} _AsGMLEdge(id, start_node, end_node, line, visitedTable, nsprefix, precision, options, idprefix, gmlver)

--{
--
-- INTERNAL FUNCTION
-- text _AsGMLFace(toponame, face_id, visitedTable,
--                 nsprefix, precision, options, idprefix, gmlVersion)
--
-- }{
CREATE OR REPLACE FUNCTION topology._AsGMLFace(toponame text, face_id int, visitedTable regclass, nsprefix_in text, prec int, options int, idprefix text, gmlver int)
  RETURNS text
AS
$$
DECLARE
  visited bool;
  nsprefix text;
  gml text;
  rec RECORD;
  rec2 RECORD;
  bounds geometry;
BEGIN

  nsprefix := 'gml:';
  IF nsprefix_in IS NOT NULL THEN
    IF nsprefix_in = '' THEN
      nsprefix = nsprefix_in;
    ELSE
      nsprefix = nsprefix_in || ':';
    END IF;
  END IF;

  gml := '<' || nsprefix || 'Face ' || nsprefix
    || 'id="' || idprefix || 'F' || face_id || '">';

  -- Construct the face geometry, then for each polygon:
  FOR rec IN SELECT (ST_DumpRings((ST_Dump(ST_ForceRHR(
    topology.ST_GetFaceGeometry(toponame, face_id)))).geom)).geom
  LOOP

      -- Contents of a directed face are the list of edges
      -- that cover the specific ring
      bounds = ST_Boundary(rec.geom);

      FOR rec2 IN EXECUTE
        'SELECT e.*, ST_LineLocatePoint($1'
        || ', ST_LineInterpolatePoint(e.geom, 0.2)) as pos'
        || ', ST_LineLocatePoint($1'
        || ', ST_LineInterpolatePoint(e.geom, 0.8)) as pos2 FROM '
        || quote_ident(toponame)
        || '.edge e WHERE ( e.left_face = $2'
        || ' OR e.right_face = $2'
        || ') AND ST_Covers($1'
        || ', e.geom) ORDER BY pos'
        USING bounds, face_id
      LOOP

        gml = gml || '<' || nsprefix || 'directedEdge';

        -- if this edge goes in same direction to the
        --       ring bounds, make it with negative orientation
        IF rec2.pos2 > rec2.pos THEN -- edge goes in same direction
          gml = gml || ' orientation="-"';
        END IF;

        -- Do visited bookkeeping if visitedTable was given
        IF visitedTable IS NOT NULL THEN

          EXECUTE 'SELECT true FROM '
            || visitedTable::text
            || ' WHERE element_type = 2 AND element_id = '
            || rec2.edge_id LIMIT 1 INTO visited;
          IF visited THEN
            -- Use xlink:href if visited
            gml = gml || ' xlink:href="#' || idprefix || 'E'
                      || rec2.edge_id || '" />';
            CONTINUE;
          ELSE
            -- Mark as visited otherwise
            EXECUTE 'INSERT INTO ' || visitedTable::text
              || '(element_type, element_id) VALUES (2, '
              || rec2.edge_id || ')';
          END IF;

        END IF;

        gml = gml || '>';

        gml = gml || topology._AsGMLEdge(rec2.edge_id, rec2.start_node,
                                        rec2.end_node, rec2.geom,
                                        visitedTable, nsprefix_in,
                                        prec, options, idprefix, gmlver);
        gml = gml || '</' || nsprefix || 'directedEdge>';

      END LOOP;
    END LOOP;

  gml = gml || '</' || nsprefix || 'Face>';

  RETURN gml;
END
$$
LANGUAGE 'plpgsql' VOLATILE; -- writes into visited table
--} _AsGMLFace(toponame, id, visitedTable, nsprefix, precision, options, idprefix, gmlver)

--{
--
-- API FUNCTION
--
-- text AsGML(TopoGeometry, nsprefix, precision, options, visitedTable, idprefix, gmlver)
--
-- }{
CREATE OR REPLACE FUNCTION topology.AsGML(tg topology.TopoGeometry, nsprefix_in text, precision_in int, options_in int, visitedTable regclass, idprefix text, gmlver int)
  RETURNS text
AS
$$
DECLARE
  nsprefix text;
  precision int;
  options int;
  visited bool;
  toponame text;
  gml text;
  sql text;
  rec RECORD;
  rec2 RECORD;
BEGIN

  nsprefix := 'gml:';
  IF nsprefix_in IS NOT NULL THEN
    IF nsprefix_in = '' THEN
      nsprefix = nsprefix_in;
    ELSE
      nsprefix = nsprefix_in || ':';
    END IF;
  END IF;

  precision := 15;
  IF precision_in IS NOT NULL THEN
    precision = precision_in;
  END IF;

  options := 1;
  IF options_in IS NOT NULL THEN
    options = options_in;
  END IF;

  -- Get topology name (for subsequent queries)
  SELECT name FROM topology.topology into toponame
              WHERE id = tg.topology_id;

  -- Puntual TopoGeometry
  IF tg.type = 1 THEN
    gml = '<' || nsprefix || 'TopoPoint>';
    -- For each defining node, print a directedNode
    FOR rec IN  EXECUTE 'SELECT r.element_id, n.geom from '
      || quote_ident(toponame) || '.relation r LEFT JOIN '
      || quote_ident(toponame) || '.node n ON (r.element_id = n.node_id)'
      || ' WHERE r.layer_id = ' || tg.layer_id
      || ' AND r.topogeo_id = ' || tg.id
    LOOP
      gml = gml || '<' || nsprefix || 'directedNode';
      -- Do visited bookkeeping if visitedTable was given
      IF visitedTable IS NOT NULL THEN
        EXECUTE 'SELECT true FROM '
                || visitedTable::text
                || ' WHERE element_type = 1 AND element_id = '
                || rec.element_id LIMIT 1 INTO visited;
        IF visited IS NOT NULL THEN
          gml = gml || ' xlink:href="#' || idprefix || 'N' || rec.element_id || '" />';
          CONTINUE;
        ELSE
          -- Mark as visited 
          EXECUTE 'INSERT INTO ' || visitedTable::text
            || '(element_type, element_id) VALUES (1, '
            || rec.element_id || ')';
        END IF;
      END IF;
      gml = gml || '>';
      gml = gml || topology._AsGMLNode(rec.element_id, rec.geom, nsprefix_in, precision, options, idprefix, gmlver);
      gml = gml || '</' || nsprefix || 'directedNode>';
    END LOOP;
    gml = gml || '</' || nsprefix || 'TopoPoint>';
    RETURN gml;

  ELSIF tg.type = 2 THEN -- lineal
    gml = '<' || nsprefix || 'TopoCurve>';

    FOR rec IN SELECT (ST_Dump(topology.Geometry(tg))).geom
    LOOP
      FOR rec2 IN EXECUTE
        'SELECT e.*, ST_LineLocatePoint($1'
        || ', ST_LineInterpolatePoint(e.geom, 0.2)) as pos'
        || ', ST_LineLocatePoint($1'
        || ', ST_LineInterpolatePoint(e.geom, 0.8)) as pos2 FROM '
        || quote_ident(toponame)
        || '.edge e WHERE ST_Covers($1'
        || ', e.geom) ORDER BY pos'
        -- TODO: add relation to the conditional, to reduce load ?
        USING rec.geom
      LOOP

        gml = gml || '<' || nsprefix || 'directedEdge';

        -- if this edge goes in opposite direction to the
        --       line, make it with negative orientation
        IF rec2.pos2 < rec2.pos THEN -- edge goes in opposite direction
          gml = gml || ' orientation="-"';
        END IF;

        -- Do visited bookkeeping if visitedTable was given
        IF visitedTable IS NOT NULL THEN

          EXECUTE 'SELECT true FROM '
            || visitedTable::text
            || ' WHERE element_type = 2 AND element_id = '
            || rec2.edge_id LIMIT 1 INTO visited;
          IF visited THEN
            -- Use xlink:href if visited
            gml = gml || ' xlink:href="#' || idprefix || 'E' || rec2.edge_id || '" />';
            CONTINUE;
          ELSE
            -- Mark as visited otherwise
            EXECUTE 'INSERT INTO ' || visitedTable::text
              || '(element_type, element_id) VALUES (2, '
              || rec2.edge_id || ')';
          END IF;

        END IF;


        gml = gml || '>';

        gml = gml || topology._AsGMLEdge(rec2.edge_id,
                                        rec2.start_node,
                                        rec2.end_node, rec2.geom,
                                        visitedTable,
                                        nsprefix_in, precision,
                                        options, idprefix, gmlver);


        gml = gml || '</' || nsprefix || 'directedEdge>';
      END LOOP;
    END LOOP;

    gml = gml || '</' || nsprefix || 'TopoCurve>';
    return gml;

  ELSIF tg.type = 3 THEN -- areal
    gml = '<' || nsprefix || 'TopoSurface>';

    -- For each defining face, print a directedFace
    FOR rec IN  EXECUTE 'SELECT f.face_id from '
      || quote_ident(toponame) || '.relation r LEFT JOIN '
      || quote_ident(toponame) || '.face f ON (r.element_id = f.face_id)'
      || ' WHERE r.layer_id = ' || tg.layer_id
      || ' AND r.topogeo_id = ' || tg.id
    LOOP
      gml = gml || '<' || nsprefix || 'directedFace';
      -- Do visited bookkeeping if visitedTable was given
      IF visitedTable IS NOT NULL THEN
        EXECUTE 'SELECT true FROM '
                || visitedTable::text
                || ' WHERE element_type = 3 AND element_id = '
                || rec.face_id LIMIT 1 INTO visited;
        IF visited IS NOT NULL THEN
          gml = gml || ' xlink:href="#' || idprefix || 'F' || rec.face_id || '" />';
          CONTINUE;
        ELSE
          -- Mark as visited 
          EXECUTE 'INSERT INTO ' || visitedTable::text
            || '(element_type, element_id) VALUES (3, '
            || rec.face_id || ')';
        END IF;
      END IF;
      gml = gml || '>';
      gml = gml || topology._AsGMLFace(toponame, rec.face_id, visitedTable,
                                       nsprefix_in, precision,
                                       options, idprefix, gmlver);
      gml = gml || '</' || nsprefix || 'directedFace>';
    END LOOP;
    gml = gml || '</' || nsprefix || 'TopoSurface>';
    RETURN gml;

  ELSIF tg.type = 4 THEN -- collection
    RAISE EXCEPTION 'Collection TopoGeometries are not supported by AsGML';

  END IF;
	

  RETURN gml;
	
END
$$
LANGUAGE 'plpgsql' VOLATILE; -- writes into visited table
--} AsGML(TopoGeometry, nsprefix, precision, options, visitedTable, idprefix, gmlver)

--{
--
-- API FUNCTION
--
-- text AsGML(TopoGeometry, nsprefix, precision, options, visitedTable,
--            idprefix)
--
-- }{
CREATE OR REPLACE FUNCTION topology.AsGML(tg topology.TopoGeometry,nsprefix text, prec int, options int, visitedTable regclass, idprefix text)
  RETURNS text
AS
$$
 SELECT topology.AsGML($1, $2, $3, $4, $5, $6, 3);
$$
LANGUAGE 'sql' VOLATILE; -- writes into visited table
--} AsGML(TopoGeometry, nsprefix, precision, options, visitedTable, idprefix)

--{
--
-- API FUNCTION 
--
-- text AsGML(TopoGeometry, nsprefix, precision, options, visitedTable)
--
-- }{
CREATE OR REPLACE FUNCTION topology.AsGML(tg topology.TopoGeometry, nsprefix text, prec int, options int, vis regclass)
  RETURNS text AS
$$
 SELECT topology.AsGML($1, $2, $3, $4, $5, '');
$$ LANGUAGE 'sql' VOLATILE; -- writes into visited table
-- } AsGML(TopoGeometry, nsprefix, precision, options)


--{
--
-- API FUNCTION 
--
-- text AsGML(TopoGeometry, nsprefix, precision, options)
--
-- }{
CREATE OR REPLACE FUNCTION topology.AsGML(tg topology.TopoGeometry, nsprefix text, prec int, opts int)
  RETURNS text AS
$$
 SELECT topology.AsGML($1, $2, $3, $4, NULL);
$$ LANGUAGE 'sql' STABLE; -- does NOT write into visited table 
-- } AsGML(TopoGeometry, nsprefix, precision, options)

--{
--
-- API FUNCTION 
--
-- text AsGML(TopoGeometry, nsprefix)
--
-- }{
CREATE OR REPLACE FUNCTION topology.AsGML(tg topology.TopoGeometry, nsprefix text)
  RETURNS text AS
$$
 SELECT topology.AsGML($1, $2, 15, 1, NULL);
$$ LANGUAGE 'sql' STABLE; -- does NOT write into visited table 
-- } AsGML(TopoGeometry, nsprefix)

--{
--
-- API FUNCTION
--
-- text AsGML(TopoGeometry, visited_table)
--
-- }{
CREATE OR REPLACE FUNCTION topology.AsGML(tg topology.TopoGeometry, visitedTable regclass)
  RETURNS text AS
$$
 SELECT topology.AsGML($1, 'gml', 15, 1, $2);
$$ LANGUAGE 'sql' VOLATILE; -- writes into visited table
-- } AsGML(TopoGeometry, visited_table)

--{
--
-- API FUNCTION
--
-- text AsGML(TopoGeometry, visited_table, nsprefix)
--
-- }{
CREATE OR REPLACE FUNCTION topology.AsGML(tg topology.TopoGeometry, visitedTable regclass, nsprefix text)
  RETURNS text AS
$$
 SELECT topology.AsGML($1, $3, 15, 1, $2);
$$ LANGUAGE 'sql' VOLATILE; -- writes into visited table
-- } AsGML(TopoGeometry, visited_table, nsprefix)


--{
--
-- API FUNCTION
--
-- text AsGML(TopoGeometry)
--
-- }{
CREATE OR REPLACE FUNCTION topology.AsGML(tg topology.TopoGeometry)
  RETURNS text AS
$$
 SELECT topology.AsGML($1, 'gml');
$$ LANGUAGE 'sql' STABLE; -- does NOT write into visited table
-- } AsGML(TopoGeometry)

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- 
-- PostGIS - Spatial Types for PostgreSQL
-- http://postgis.net
--
-- Copyright (C) 2013 Sandro Santilli <strk@keybit.net>
--
-- This is free software; you can redistribute and/or modify it under
-- the terms of the GNU General Public Licence. See the COPYING file.
--
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--
-- Functions used for TopoJSON export
--
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -



--{
--
-- API FUNCTION
--
-- text AsTopoJSON(TopoGeometry, edgeMapTable)
--
-- }{
CREATE OR REPLACE FUNCTION topology.AsTopoJSON(tg topology.TopoGeometry, edgeMapTable regclass)
  RETURNS text AS
$$
DECLARE
  toponame text;
  json text;
  sql text;
  bounds GEOMETRY;
  rec RECORD;
  rec2 RECORD;
  side int;
  arcid int;
  arcs int[];
  ringtxt TEXT[];
  comptxt TEXT[];
  edges_found BOOLEAN;
  old_search_path TEXT;
  all_faces int[];
  faces int[];
  visited_face int;
  shell_faces int[];
  visited_edges int[];
  looking_for_holes BOOLEAN;
BEGIN

  IF tg IS NULL THEN
    RETURN NULL;
  END IF;

  -- Get topology name (for subsequent queries)
  SELECT name FROM topology.topology into toponame
              WHERE id = tg.topology_id;

  -- Puntual TopoGeometry
  IF tg.type = 1 THEN
    -- TODO: implement scale ?
    --json := ST_AsGeoJSON(topology.Geometry(tg));
    --return json;
    RAISE EXCEPTION 'TopoJSON export does not support puntual objects';
  ELSIF tg.type = 2 THEN -- lineal

    FOR rec IN SELECT (ST_Dump(topology.Geometry(tg))).geom
    LOOP -- {

      sql := 'SELECT e.*, ST_LineLocatePoint($1'
            || ', ST_LineInterpolatePoint(e.geom, 0.2)) as pos'
            || ', ST_LineLocatePoint($1'
            || ', ST_LineInterpolatePoint(e.geom, 0.8)) as pos2 FROM '
            || quote_ident(toponame)
            || '.edge e WHERE ST_Covers($1'
            || ', e.geom) ORDER BY pos';
            -- TODO: add relation to the conditional, to reduce load ?
      FOR rec2 IN EXECUTE sql USING rec.geom
      LOOP -- {

        IF edgeMapTable IS NOT NULL THEN
          sql := 'SELECT arc_id-1 FROM ' || edgeMapTable::text || ' WHERE edge_id = $1';
          EXECUTE sql INTO arcid USING rec2.edge_id;
          IF arcid IS NULL THEN
            EXECUTE 'INSERT INTO ' || edgeMapTable::text
              || '(edge_id) VALUES ($1) RETURNING arc_id-1'
            INTO arcid USING rec2.edge_id;
          END IF;
        ELSE
          arcid := rec2.edge_id;
        END IF;

        -- edge goes in opposite direction
        IF rec2.pos2 < rec2.pos THEN
          arcid := -(arcid+1);
        END IF;

        arcs := arcs || arcid;

      END LOOP; -- }

      comptxt := comptxt || ( '[' || array_to_string(arcs, ',') || ']' );
      arcs := NULL;

    END LOOP; -- }

    json := '{ "type": "MultiLineString", "arcs": [' || array_to_string(comptxt,',') || ']}';

    return json;

  ELSIF tg.type = 3 THEN -- areal

    json := '{ "type": "MultiPolygon", "arcs": [';

    EXECUTE 'SHOW search_path' INTO old_search_path;
    EXECUTE 'SET search_path TO ' || quote_ident(toponame) || ',' || old_search_path;

    SELECT array_agg(id) as f
    FROM ( SELECT (topology.GetTopoGeomElements(tg))[1] as id ) as f
    INTO all_faces;


    visited_edges := ARRAY[]::int[];
    faces := all_faces;
    looking_for_holes := false;
    shell_faces := ARRAY[]::int[];

    LOOP -- {

      arcs := NULL;
      edges_found := false;


      FOR rec in -- {
WITH RECURSIVE
_edges AS (
  SELECT e.*, 
         e.left_face = ANY ( faces ) as lf,
         e.right_face = ANY ( faces ) as rf
  FROM edge e
  WHERE ( e.left_face = ANY ( faces ) OR
          e.right_face = ANY ( faces ) )
),
_leftmost_non_dangling_edge AS (
  SELECT * FROM _edges e
    WHERE ( e.lf or e.rf ) AND ( e.lf != e.rf )
          AND NOT e.edge_id = ANY ( visited_edges )
      -- TODO: and not in visited ?
  ORDER BY geom LIMIT 1
),
_edgepath AS (
  SELECT
    CASE
      WHEN e.lf THEN lme.edge_id
      ELSE -lme.edge_id
    END as signed_edge_id,
    false as back,

    e.lf = e.rf as dangling,
    e.left_face, e.right_face,
    e.lf, e.rf,
    e.next_right_edge, e.next_left_edge

  FROM _edges e, _leftmost_non_dangling_edge lme
  WHERE e.edge_id = abs(lme.edge_id)
    UNION
  SELECT
    CASE
      WHEN p.dangling AND NOT p.back THEN -p.signed_edge_id
      WHEN p.signed_edge_id < 0 THEN p.next_right_edge
      ELSE p.next_left_edge
    END, -- signed_edge_id
    CASE
      WHEN p.dangling AND NOT p.back THEN true
      ELSE false
    END, -- back

    e.lf = e.rf, -- dangling
    e.left_face, e.right_face,
    e.lf, e.rf,
    e.next_right_edge, e.next_left_edge

  FROM _edges e, _edgepath p
  WHERE
    e.edge_id = CASE
      WHEN p.dangling AND NOT p.back THEN abs(p.signed_edge_id)
      WHEN p.signed_edge_id < 0 THEN abs(p.next_right_edge)
      ELSE abs(p.next_left_edge)
    END
)
SELECT abs(signed_edge_id) as edge_id, signed_edge_id, dangling,
        lf, rf, left_face, right_face
FROM _edgepath
      LOOP  -- }{



        IF rec.left_face = ANY (all_faces) AND NOT rec.left_face = ANY (shell_faces) THEN
          shell_faces := shell_faces || rec.left_face;
        END IF;

        IF rec.right_face = ANY (all_faces) AND NOT rec.right_face = ANY (shell_faces) THEN
          shell_faces := shell_faces || rec.right_face;
        END IF;

        visited_edges := visited_edges || rec.edge_id;

        edges_found := true;

        -- TODO: drop ?
        IF rec.dangling THEN
          CONTINUE;
        END IF;

        IF rec.left_face = ANY (all_faces) AND rec.right_face = ANY (all_faces) THEN
          CONTINUE;
        END IF;

        IF edgeMapTable IS NOT NULL THEN
          sql := 'SELECT arc_id-1 FROM ' || edgeMapTable::text || ' WHERE edge_id = $1';
          EXECUTE sql INTO arcid USING rec.edge_id;
          IF arcid IS NULL THEN
            EXECUTE 'INSERT INTO ' || edgeMapTable::text
              || '(edge_id) VALUES ($1) RETURNING arc_id-1'
            INTO arcid USING rec.edge_id;
          END IF;
        ELSE
          arcid := rec.edge_id-1;
        END IF;

        -- Swap sign, use two's complement for negative edges
        IF rec.signed_edge_id >= 0 THEN
          arcid := - ( arcid + 1 );
        END IF;


        arcs := arcid || arcs;

      END LOOP; -- }


      IF NOT edges_found THEN
        IF looking_for_holes THEN
          looking_for_holes := false;
          comptxt := comptxt || ( '[' || array_to_string(ringtxt, ',') || ']' );
          ringtxt := NULL;
          faces := all_faces;
          shell_faces := ARRAY[]::int[];
        ELSE
          EXIT; -- end of loop
        END IF;
      ELSE
        faces := shell_faces;
        IF arcs IS NOT NULL THEN
          ringtxt := ringtxt || ( '[' || array_to_string(arcs,',') || ']' );
        END IF;
        looking_for_holes := true;
      END IF;

    END LOOP; -- }

    json := json || array_to_string(comptxt, ',') || ']}';

    EXECUTE 'SET search_path TO ' || old_search_path;


  ELSIF tg.type = 4 THEN -- collection
    RAISE EXCEPTION 'Collection TopoGeometries are not supported by AsTopoJSON';

  END IF;
	
  RETURN json;
	
END
$$ LANGUAGE 'plpgsql' VOLATILE; -- writes into visited table
-- } AsTopoJSON(TopoGeometry, visited_table)


--=}  POSTGIS-SPECIFIC block

--  SQL/MM block
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- 
-- PostGIS - Spatial Types for PostgreSQL
-- http://postgis.net
--
-- Copyright (C) 2010-2015 Sandro Santilli <strk@keybit.net>
-- Copyright (C) 2005 Refractions Research Inc.
--
-- This is free software; you can redistribute and/or modify it under
-- the terms of the GNU General Public Licence. See the COPYING file.
--
-- Author: Sandro Santilli <strk@keybit.net>
--  
-- 



--={ ----------------------------------------------------------------
--  SQL/MM block
--
--  This part contains function in the SQL/MM specification
--
---------------------------------------------------------------------

--
-- Type returned by ST_GetFaceEdges
--



--{
-- Topo-Geo and Topo-Net 3: Routine Details
-- X.3.5
--
--  ST_GetFaceEdges(atopology, aface)
--
--
-- 
CREATE OR REPLACE FUNCTION topology.ST_GetFaceEdges(toponame varchar, face_id integer)
  RETURNS SETOF topology.GetFaceEdges_ReturnType AS
	'$libdir/postgis_topology-2.2', 'ST_GetFaceEdges'
  LANGUAGE 'c' STABLE;
--} ST_GetFaceEdges

--{
-- Topo-Geo and Topo-Net 3: Routine Details
-- X.3.10
--
--  ST_NewEdgeHeal(atopology, anedge, anotheredge)
--
-- Not in the specs:
-- * Refuses to heal two edges if any of the two is closed 
-- * Raise an exception when trying to heal an edge with itself
-- * Raise an exception if any TopoGeometry is defined by only one
--   of the two edges
-- * Update references in the Relation table.
-- 
CREATE OR REPLACE FUNCTION topology.ST_NewEdgeHeal(toponame varchar, e1id integer, e2id integer)
  RETURNS int AS
  '$libdir/postgis_topology-2.2','ST_NewEdgeHeal'
  LANGUAGE 'c' VOLATILE;
--} ST_NewEdgeHeal

--{
-- Topo-Geo and Topo-Net 3: Routine Details
-- X.3.11
--
--  ST_ModEdgeHeal(atopology, anedge, anotheredge)
--
-- Not in the specs:
-- * Returns the id of the node being removed
-- * Refuses to heal two edges if any of the two is closed 
-- * Raise an exception when trying to heal an edge with itself
-- * Raise an exception if any TopoGeometry is defined by only one
--   of the two edges
-- * Update references in the Relation table.
-- {
CREATE OR REPLACE FUNCTION topology.ST_ModEdgeHeal(toponame varchar, e1id integer, e2id integer)
  RETURNS int AS
  '$libdir/postgis_topology-2.2','ST_ModEdgeHeal'
  LANGUAGE 'c' VOLATILE;
--} ST_ModEdgeHeal

--{
-- Topo-Geo and Topo-Net 3: Routine Details
-- X.3.14
--
--  ST_RemEdgeNewFace(atopology, anedge)
--
-- Not in the specs:
-- * Raise an exception if any TopoGeometry is defined by only one
--   of the two faces that will dissolve.
-- * Raise an exception if any TopoGeometry is defined by 
--   the edge being removed.
-- * Properly set containg_face on nodes that remains isolated by the drop
-- * Update containg_face for isolated nodes in the dissolved faces
-- * Update references in the Relation table
-- 
-- }{
CREATE OR REPLACE FUNCTION topology.ST_RemEdgeNewFace(toponame varchar, e1id integer)
  RETURNS int AS
	'$libdir/postgis_topology-2.2','ST_RemEdgeNewFace'
  LANGUAGE 'c' VOLATILE;
--} ST_RemEdgeNewFace

--{
-- Topo-Geo and Topo-Net 3: Routine Details
-- X.3.15
--
--  ST_RemEdgeModFace(atopology, anedge)
--
-- Not in the specs:
-- * Raise an exception if any TopoGeometry is defined by only one
--   of the two faces that will dissolve.
-- * Raise an exception if any TopoGeometry is defined by 
--   the edge being removed.
-- * Properly set containg_face on nodes that remains isolated by the drop
-- * Update containg_face for isolated nodes in the dissolved faces
-- * Update references in the Relation table
-- * Return id of the face taking up the removed edge space
--
-- }{
CREATE OR REPLACE FUNCTION topology.ST_RemEdgeModFace(toponame varchar, e1id integer)
  RETURNS int AS
	'$libdir/postgis_topology-2.2','ST_RemEdgeModFace'
  LANGUAGE 'c' VOLATILE;
--} ST_RemEdgeModFace


--{
-- Topo-Geo and Topo-Net 3: Routine Details
-- X.3.16
--
--  ST_GetFaceGeometry(atopology, aface)
-- 
CREATE OR REPLACE FUNCTION topology.ST_GetFaceGeometry(toponame varchar, aface integer)
  RETURNS GEOMETRY AS
	'$libdir/postgis_topology-2.2', 'ST_GetFaceGeometry'
  LANGUAGE 'c' STABLE;
--} ST_GetFaceGeometry


--{
-- Topo-Geo and Topo-Net 3: Routine Details
-- X.3.1 
--
--  ST_AddIsoNode(atopology, aface, apoint)
--
CREATE OR REPLACE FUNCTION topology.ST_AddIsoNode(atopology varchar, aface integer, apoint geometry)
  RETURNS INTEGER AS
	'$libdir/postgis_topology-2.2','ST_AddIsoNode'
  LANGUAGE 'c' VOLATILE;
--} ST_AddIsoNode

--{
-- Topo-Geo and Topo-Net 3: Routine Details
-- X.3.2 
--
--  ST_MoveIsoNode(atopology, anode, apoint)
--
CREATE OR REPLACE FUNCTION topology.ST_MoveIsoNode(atopology character varying, anode integer, apoint geometry)
  RETURNS text AS
  '$libdir/postgis_topology-2.2','ST_MoveIsoNode'
  LANGUAGE 'c' VOLATILE;
--} ST_MoveIsoNode

--{
-- Topo-Geo and Topo-Net 3: Routine Details
-- X.3.3 
--
--  ST_RemoveIsoNode(atopology, anode)
--
CREATE OR REPLACE FUNCTION topology.ST_RemoveIsoNode(atopology varchar, anode integer)
  RETURNS TEXT AS
	'$libdir/postgis_topology-2.2','ST_RemoveIsoNode'
  LANGUAGE 'c' VOLATILE;
--} ST_RemoveIsoNode

--{
-- According to http://trac.osgeo.org/postgis/ticket/798
-- ST_RemoveIsoNode was renamed to ST_RemIsoNode in the final ISO
-- document
--
CREATE OR REPLACE FUNCTION topology.ST_RemIsoNode(varchar, integer)
  RETURNS TEXT AS
	'$libdir/postgis_topology-2.2','ST_RemoveIsoNode'
  LANGUAGE 'c' VOLATILE;
--} ST_RemIsoNode

--{
-- Topo-Geo and Topo-Net 3: Routine Details
-- X.3.7 
--
--  ST_RemoveIsoEdge(atopology, anedge)
--
CREATE OR REPLACE FUNCTION topology.ST_RemoveIsoEdge(atopology varchar, anedge integer)
  RETURNS TEXT AS
	'$libdir/postgis_topology-2.2','ST_RemIsoEdge'
	LANGUAGE 'c' VOLATILE;
--} ST_RemoveIsoEdge

--{
-- Topo-Geo and Topo-Net 3: Routine Details
-- X.3.8 
--
--  ST_NewEdgesSplit(atopology, anedge, apoint)
--
-- Not in the specs:
-- * Update references in the Relation table.
--
CREATE OR REPLACE FUNCTION topology.ST_NewEdgesSplit(atopology varchar, anedge integer, apoint geometry)
  RETURNS INTEGER AS
  '$libdir/postgis_topology-2.2','ST_NewEdgesSplit'
  LANGUAGE 'c' VOLATILE;
--} ST_NewEdgesSplit

--{
-- Topo-Geo and Topo-Net 3: Routine Details
-- X.3.9 
--
--  ST_ModEdgeSplit(atopology, anedge, apoint)
--
-- Not in the specs:
-- * Update references in the Relation table.
--
CREATE OR REPLACE FUNCTION topology.ST_ModEdgeSplit(atopology varchar, anedge integer, apoint geometry)
  RETURNS INTEGER AS
	'$libdir/postgis_topology-2.2','ST_ModEdgeSplit'
  LANGUAGE 'c' VOLATILE;
--} ST_ModEdgesSplit

--{
-- Topo-Geo and Topo-Net 3: Routine Details
-- X.3.4 
--
--  ST_AddIsoEdge(atopology, anode, anothernode, acurve)
-- 
-- Not in the specs:
-- * Reset containing_face for starting and ending point,
--   as they stop being isolated nodes
-- * Refuse to add a closed edge, as it would not be isolated
--   (ie: would create a ring)
--
-- }{
--
CREATE OR REPLACE FUNCTION topology.ST_AddIsoEdge(atopology varchar, anode integer, anothernode integer, acurve geometry)
  RETURNS INTEGER AS
	'$libdir/postgis_topology-2.2','ST_AddIsoEdge'
  LANGUAGE 'c' VOLATILE;
--} ST_AddIsoEdge

-- Internal function used by ST_ChangeEdgeGeom to compare
-- adjacent edges of an edge endpoint
--
-- @param anode the node to use edge end star of
-- @param anedge the directed edge to get adjacents from
--        if positive `anode' is assumed to be its start node
--        if negative `anode' is assumed to be its end node
--      
-- @todo DROP, NOT NEEDED ANYMORE (might need to go in some _drop, I guess)
-- {
CREATE OR REPLACE FUNCTION topology._ST_AdjacentEdges(atopology varchar, anode integer, anedge integer)
RETURNS integer[] AS
$$
DECLARE
  ret integer[];
BEGIN
  WITH edgestar AS (
    SELECT *, count(*) over () AS cnt
    FROM topology.GetNodeEdges(atopology, anode)
  )
  SELECT ARRAY[ (
      SELECT p.edge AS prev FROM edgestar p
      WHERE p.sequence = CASE WHEN m.sequence-1 < 1 THEN cnt
                         ELSE m.sequence-1 END
    ), (
      SELECT p.edge AS prev FROM edgestar p WHERE p.sequence = ((m.sequence)%cnt)+1
    ) ]
  FROM edgestar m
  WHERE edge = anedge
  INTO ret;

  RETURN ret;
END
$$
LANGUAGE 'plpgsql' STABLE;
--}

--{
-- Topo-Geo and Topo-Net 3: Routine Details
-- X.3.6
--
--  ST_ChangeEdgeGeom(atopology, anedge, acurve)
--
-- Not in the specs:
-- * Raise an exception if given a non-existent edge
-- * Raise an exception if movement is not topologically isomorphic
--
-- }{
CREATE OR REPLACE FUNCTION topology.ST_ChangeEdgeGeom(atopology varchar, anedge integer, acurve geometry)
  RETURNS TEXT AS
	'$libdir/postgis_topology-2.2','ST_ChangeEdgeGeom'
  LANGUAGE 'c' VOLATILE;
--} ST_ChangeEdgeGeom

--
-- _ST_AddFaceSplit
--
-- Add a split face by walking on the edge side.
--
-- @param atopology topology name
-- @param anedge edge id and walking side (left:positive right:negative)
-- @param oface the face in which the edge identifier is known to be
-- @param mbr_only do not create a new face but update MBR of the current
--
-- The created face, if any, will be at the left hand of the walking path
--
-- Return:
--  NULL: if mbr_only was requested
--     0: if the edge does not form a ring
--  NULL: if it is impossible to create a face on the requested side
--        ( new face on the side is the universe )
--   >0 : id of newly added face
--
-- {
CREATE OR REPLACE FUNCTION topology._ST_AddFaceSplit(atopology varchar, anedge integer, oface integer, mbr_only bool)
  RETURNS INTEGER AS
$$
DECLARE
  fan RECORD;
  newface INTEGER;
  sql TEXT;
  isccw BOOLEAN;
  ishole BOOLEAN;

BEGIN

  IF oface = 0 AND mbr_only THEN
    RETURN NULL;
  END IF;

  SELECT null::int[] as newring_edges,
         null::geometry as shell
  INTO fan;

  SELECT array_agg(edge)
  FROM topology.getringedges(atopology, anedge)
  INTO STRICT fan.newring_edges;


  -- You can't get to the other side of an edge forming a ring 
  IF fan.newring_edges @> ARRAY[-anedge] THEN
    RETURN 0;
  END IF;


  sql := 'WITH ids as ( select row_number() over () as seq, edge '
    || 'from unnest($1) u(edge) ), edges AS ( select CASE WHEN i.edge < 0 '
    || 'THEN ST_Reverse(e.geom) ELSE e.geom END as g FROM ids i left join '
    || quote_ident(atopology) || '.edge_data e ON(e.edge_id = abs(i.edge)) '
    || 'ORDER BY seq) SELECT ST_MakePolygon(ST_MakeLine(g.g)) FROM edges g';
  EXECUTE sql INTO fan.shell USING
    fan.newring_edges
  ;


  isccw := NOT ST_OrderingEquals(fan.shell, ST_ForceRHR(fan.shell));


  IF oface = 0 THEN
    IF NOT isccw THEN
      RETURN NULL;
    END IF;
  END IF;

  IF mbr_only AND oface != 0 THEN
    -- Update old face mbr (nothing to do if we're opening an hole)
    IF isccw THEN -- {
      sql := 'UPDATE '
        || quote_ident(atopology)
        || '.face SET mbr = $1 WHERE face_id = $2';
    	EXECUTE sql USING
        ST_Envelope(fan.shell),
        oface
      ;
    END IF; -- }
    RETURN NULL;
  END IF;

  IF oface != 0 AND NOT isccw THEN -- {
    -- Face created an hole in an outer face
    sql := 'INSERT INTO '
      || quote_ident(atopology) || '.face(mbr) SELECT mbr FROM '
      || quote_ident(atopology)
      || '.face WHERE face_id = ' || oface
      || ' RETURNING face_id';
  ELSE
    sql := 'INSERT INTO '
      || quote_ident(atopology) || '.face(mbr) VALUES ($1) RETURNING face_id';
  END IF; -- }

  -- Insert new face
  EXECUTE sql INTO STRICT newface USING ST_Envelope(fan.shell);

  -- Update forward edges
  sql := 'UPDATE ' || quote_ident(atopology) ||
    '.edge_data SET left_face = $1 WHERE edge_id = ANY($3)'
  ;
  EXECUTE sql USING newface, oface,
    array(select +x from unnest(fan.newring_edges) u(x) where x > 0)
  ;

  -- Update backward edges
  sql := 'UPDATE ' || quote_ident(atopology) ||
    '.edge_data SET right_face = $1 WHERE edge_id = ANY($3)'
  ;
  EXECUTE sql USING newface, oface,
    array(select -x from unnest(fan.newring_edges) u(x) where x < 0)
  ;

  IF oface != 0 AND NOT isccw THEN -- {
    -- face shrinked, must update all non-contained edges and nodes
    ishole := true;
  ELSE
    ishole := false;
  END IF; -- }

  -- Update edges bounding the old face
  sql := 'UPDATE '
    || quote_ident(atopology)
    || '.edge_data SET left_face = CASE WHEN left_face = $2 THEN $3'
    || ' ELSE left_face END, right_face = CASE WHEN right_face = $2 '
    || ' THEN $3 ELSE right_face END WHERE ( left_face = $2 '
    || ' OR right_face = $2 ) AND NOT edge_id = ANY ($4) AND ';
  IF ishole THEN sql := sql || 'NOT '; END IF;
  sql := sql || '($1 && geom AND _ST_Contains($1'
    -- We only need to check a single point, but must not be an endpoint
    || ', ST_LineInterpolatePoint(geom, 0.2)) )';
  EXECUTE sql USING fan.shell, oface, newface,
    array(select abs(x) from unnest(fan.newring_edges) u(x));

  -- Update isolated nodes in new new face 
  sql := 'UPDATE '
    || quote_ident(atopology) || '.node SET containing_face = $2 '
    || ' WHERE containing_face = $3 AND ';
  IF ishole THEN sql := sql || 'NOT '; END IF;
  sql := sql || 'ST_Contains($1, geom)';
  EXECUTE sql USING fan.shell, newface, oface;

  RETURN newface;

END
$$
LANGUAGE 'plpgsql' VOLATILE;
--}

--{
-- Topo-Geo and Topo-Net 3: Routine Details
-- X.3.12
--
--  ST_AddEdgeNewFaces(atopology, anode, anothernode, acurve)
--
-- Not in the specs:
-- * Reset containing_face for starting and ending point,
--   as they stop being isolated nodes
-- * Update references in the Relation table.
--
CREATE OR REPLACE FUNCTION topology.ST_AddEdgeNewFaces(atopology varchar, anode integer, anothernode integer, acurve geometry)
  RETURNS INTEGER AS
	'$libdir/postgis_topology-2.2','ST_AddEdgeNewFaces'
  LANGUAGE 'c' VOLATILE;
--} ST_AddEdgeNewFaces

--{
-- Topo-Geo and Topo-Net 3: Routine Details
-- X.3.13
--
--  ST_AddEdgeModFace(atopology, anode, anothernode, acurve)
--
-- Not in the specs:
-- * Reset containing_face for starting and ending point,
--   as they stop being isolated nodes
-- * Update references in the Relation table.
--
CREATE OR REPLACE FUNCTION topology.ST_AddEdgeModFace(atopology varchar, anode integer, anothernode integer, acurve geometry)
  RETURNS INTEGER AS
	'$libdir/postgis_topology-2.2','ST_AddEdgeModFace'
  LANGUAGE 'c' VOLATILE;
--} ST_AddEdgeModFace

--{
-- Topo-Geo and Topo-Net 3: Routine Details
-- X.3.17
--
--  ST_InitTopoGeo(atopology)
--
CREATE OR REPLACE FUNCTION topology.ST_InitTopoGeo(atopology varchar)
RETURNS text
AS
$$
DECLARE
  rec RECORD;
  topology_id numeric;
BEGIN
  IF atopology IS NULL THEN
    RAISE EXCEPTION 'SQL/MM Spatial exception - null argument';
  END IF;

  FOR rec IN SELECT * FROM pg_namespace WHERE text(nspname) = atopology
  LOOP
    RAISE EXCEPTION 'SQL/MM Spatial exception - schema already exists';
  END LOOP;

  FOR rec IN EXECUTE 'SELECT topology.CreateTopology('
    ||quote_literal(atopology)|| ') as id'
  LOOP
    topology_id := rec.id;
  END LOOP;

  RETURN 'Topology-Geometry ' || quote_literal(atopology)
    || ' (id:' || topology_id || ') created.';
END
$$
LANGUAGE 'plpgsql' VOLATILE;
--} ST_InitTopoGeo

--{
-- Topo-Geo and Topo-Net 3: Routine Details
-- X.3.18
--
--  ST_CreateTopoGeo(atopology, acollection)
--}{
CREATE OR REPLACE FUNCTION topology.ST_CreateTopoGeo(atopology varchar, acollection geometry)
RETURNS text
AS
$$
DECLARE
  typ char(4);
  rec RECORD;
  ret int;
  nodededges GEOMETRY;
  points GEOMETRY;
  snode_id int;
  enode_id int;
  tolerance FLOAT8;
  topoinfo RECORD;
BEGIN

  IF atopology IS NULL OR acollection IS NULL THEN
    RAISE EXCEPTION 'SQL/MM Spatial exception - null argument';
  END IF;

  -- Get topology information
  BEGIN
    SELECT * FROM topology.topology
      INTO STRICT topoinfo WHERE name = atopology;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE EXCEPTION 'SQL/MM Spatial exception - invalid topology name';
  END;

  -- Check SRID compatibility
  IF ST_SRID(acollection) != topoinfo.SRID THEN
    RAISE EXCEPTION 'Geometry SRID (%) does not match topology SRID (%)',
      ST_SRID(acollection), topoinfo.SRID;
  END IF;

  -- Verify pre-conditions (valid, empty topology schema exists)
  BEGIN -- {

    -- Verify the topology views in the topology schema to be empty
    FOR rec in EXECUTE
      'SELECT count(*) FROM '
      || quote_ident(atopology) || '.edge_data '
      || ' UNION ' ||
      'SELECT count(*) FROM '
      || quote_ident(atopology) || '.node '
    LOOP
      IF rec.count > 0 THEN
    RAISE EXCEPTION 'SQL/MM Spatial exception - non-empty view';
      END IF;
    END LOOP;

    -- face check is separated as it will contain a single (world)
    -- face record
    FOR rec in EXECUTE
      'SELECT count(*) FROM '
      || quote_ident(atopology) || '.face '
    LOOP
      IF rec.count != 1 THEN
    RAISE EXCEPTION 'SQL/MM Spatial exception - non-empty face view';
      END IF;
    END LOOP;

  EXCEPTION
    WHEN INVALID_SCHEMA_NAME THEN
      RAISE EXCEPTION 'SQL/MM Spatial exception - invalid topology name';
    WHEN UNDEFINED_TABLE THEN
      RAISE EXCEPTION 'SQL/MM Spatial exception - non-existent view';

  END; -- }


  --
  -- Node input linework with itself
  --
  WITH components AS ( SELECT geom FROM ST_Dump(acollection) )
  SELECT ST_UnaryUnion(ST_Collect(geom)) FROM (
    SELECT geom FROM components
      WHERE ST_Dimension(geom) = 1
    UNION ALL
    SELECT ST_Boundary(geom) FROM components
      WHERE ST_Dimension(geom) = 2
  ) as linework INTO STRICT nodededges;


  --
  -- Linemerge the resulting edges, to reduce the working set
  -- NOTE: this is more of a workaround for GEOS splitting overlapping
  --       lines to each of the segments.
  --
  SELECT ST_LineMerge(nodededges) INTO STRICT nodededges;



  --
  -- Collect input points and input lines endpoints
  --
  WITH components AS ( SELECT geom FROM ST_Dump(acollection) )
  SELECT ST_Union(geom) FROM (
    SELECT geom FROM components
      WHERE ST_Dimension(geom) = 0
    UNION ALL
    SELECT ST_Boundary(geom) FROM components
      WHERE ST_Dimension(geom) = 1
  ) as nodes INTO STRICT points;


  --
  -- Further split edges by points
  -- TODO: optimize this adding ST_Split support for multiline/multipoint
  --
  FOR rec IN SELECT geom FROM ST_Dump(points)
  LOOP
    -- Use the node to split edges
    SELECT ST_Collect(geom) 
    FROM ST_Dump(ST_Split(nodededges, rec.geom))
    INTO STRICT nodededges;
  END LOOP;
  SELECT ST_UnaryUnion(nodededges) INTO STRICT nodededges;


  --
  -- Collect all nodes (from points and noded linework endpoints)
  --

  WITH edges AS ( SELECT geom FROM ST_Dump(nodededges) )
  SELECT ST_Union( -- TODO: ST_UnaryUnion ?
          COALESCE(ST_UnaryUnion(ST_Collect(geom)), 
            ST_SetSRID('POINT EMPTY'::geometry, topoinfo.SRID)),
          COALESCE(points,
            ST_SetSRID('POINT EMPTY'::geometry, topoinfo.SRID))
         )
  FROM (
    SELECT ST_StartPoint(geom) as geom FROM edges
      UNION ALL
    SELECT ST_EndPoint(geom) FROM edges
  ) as endpoints INTO points;


  --
  -- Add all nodes as isolated so that 
  -- later calls to AddEdgeModFace will tweak their being
  -- isolated or not...
  --
  FOR rec IN SELECT geom FROM ST_Dump(points)
  LOOP
    PERFORM topology.ST_AddIsoNode(atopology, 0, rec.geom);
  END LOOP;
  

  FOR rec IN SELECT geom FROM ST_Dump(nodededges)
  LOOP
    SELECT topology.GetNodeByPoint(atopology, st_startpoint(rec.geom), 0)
      INTO STRICT snode_id;
    SELECT topology.GetNodeByPoint(atopology, st_endpoint(rec.geom), 0)
      INTO STRICT enode_id;
    PERFORM topology.ST_AddEdgeModFace(atopology, snode_id, enode_id, rec.geom);
  END LOOP;

  RETURN 'Topology ' || atopology || ' populated';

END
$$
LANGUAGE 'plpgsql' VOLATILE;
--} ST_CreateTopoGeo

--=}  SQL/MM block


-- The following files needs getfaceedges_returntype, defined in sqlmm.sql
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- 
-- PostGIS - Spatial Types for PostgreSQL
-- http://postgis.net
--
-- Copyright (C) 2011 2012 Sandro Santilli <strk@keybit.net>
--
-- This is free software; you can redistribute and/or modify it under
-- the terms of the GNU General Public Licence. See the COPYING file.
--
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--
-- Developed by Sandro Santilli <strk@keybit.net>
-- for Faunalia (http://www.faunalia.it) with funding from
-- Regione Toscana - Sistema Informativo per la Gestione del Territorio
-- e dell' Ambiente [RT-SIGTA].
-- For the project: "Sviluppo strumenti software per il trattamento di dati
-- geografici basati su QuantumGIS e Postgis (CIG 0494241492)"
--
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

--{
--
-- Return a list of edges (sequence, id) resulting by starting from the
-- given edge and following the leftmost turn at each encountered node.
--
-- Edge ids are signed, they are negative if traversed backward. 
-- Sequence numbers start with 1.
--
-- Use a negative starting_edge to follow its rigth face rather than
-- left face (to start traversing it in reverse).
--
-- Optionally pass a limit on the number of edges to traverse. This is a
-- safety measure against not-properly linked topologies, where you may
-- end up looping forever (single edge loops edge are detected but longer
-- ones are not). Default is no limit (good luck!)
--
-- GetRingEdges(atopology, anedge, [maxedges])
--
CREATE OR REPLACE FUNCTION topology.GetRingEdges(atopology varchar, anedge int, maxedges int DEFAULT null)
	RETURNS SETOF topology.GetFaceEdges_ReturnType
AS
$$
DECLARE
  rec RECORD;
  retrec topology.GetFaceEdges_ReturnType;
  n int;
  sql text;
BEGIN
  sql := 'WITH RECURSIVE edgering AS ( SELECT '
    || anedge
    || ' as signed_edge_id, edge_id, next_left_edge, next_right_edge FROM '
    || quote_ident(atopology)
    || '.edge_data WHERE edge_id = '
    || abs(anedge)
    || ' UNION '
    || ' SELECT CASE WHEN p.signed_edge_id < 0 THEN p.next_right_edge '
    || ' ELSE p.next_left_edge END, e.edge_id, e.next_left_edge, e.next_right_edge '
    || ' FROM ' || quote_ident(atopology)
    || '.edge_data e, edgering p WHERE e.edge_id = CASE WHEN p.signed_edge_id < 0 '
    || 'THEN abs(p.next_right_edge) ELSE abs(p.next_left_edge) END ) SELECT * FROM edgering';

  n := 1;
  FOR rec IN EXECUTE sql
  LOOP
    retrec.sequence := n;
    retrec.edge := rec.signed_edge_id;
    RETURN NEXT retrec;

    n := n + 1;

    IF n > maxedges THEN
      RAISE EXCEPTION 'Max traversing limit hit: %', maxedges;
    END IF;
  END LOOP;

END
$$
LANGUAGE 'plpgsql' STABLE;
--} GetRingEdges
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- 
-- PostGIS - Spatial Types for PostgreSQL
-- http://postgis.net
--
-- Copyright (C) 2012 Sandro Santilli <strk@keybit.net>
--
-- This is free software; you can redistribute and/or modify it under
-- the terms of the GNU General Public Licence. See the COPYING file.
--
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

--{
--
-- Return a list of edges (sequence, id) incident to the given node.
--
-- Edge ids are signed, they are negative if the node is their endpoint.
-- Sequence numbers start with 1 ordering edges by azimuth (clockwise).
--
-- GetNodeEdges(atopology, anode)
--
CREATE OR REPLACE FUNCTION topology.GetNodeEdges(atopology varchar, anode int)
	RETURNS SETOF topology.GetFaceEdges_ReturnType
AS
$$
DECLARE
  curedge int;
  nextedge int;
  rec RECORD;
  retrec topology.GetFaceEdges_ReturnType;
  n int;
  sql text;
BEGIN

  n := 0;
  sql :=
    'WITH incident_edges AS ( SELECT edge_id, start_node, end_node, ST_RemoveRepeatedPoints(geom) as geom FROM '
    || quote_ident(atopology)
    || '.edge_data WHERE start_node = ' || anode
    || ' or end_node = ' || anode
    || ') SELECT edge_id, ST_Azimuth(ST_StartPoint(geom), ST_PointN(geom, 2)) as az FROM  incident_edges WHERE start_node = ' || anode
    || ' UNION ALL SELECT -edge_id, ST_Azimuth(ST_EndPoint(geom), ST_PointN(geom, ST_NumPoints(geom)-1)) FROM incident_edges WHERE end_node = ' || anode
    || ' ORDER BY az';

  FOR rec IN EXECUTE sql
  LOOP -- incident edges {

    n := n + 1;
    retrec.sequence := n;
    retrec.edge := rec.edge_id;
    RETURN NEXT retrec;
  END LOOP; -- incident edges }

END
$$
LANGUAGE 'plpgsql' STABLE;
--} GetRingEdges

--general management --
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- 
-- PostGIS - Spatial Types for PostgreSQL
-- http://www.postgis.net
--
-- Copyright (C) 2011 Regina Obe <lr@pcorp.us>
--
-- This is free software; you can redistribute and/or modify it under
-- the terms of the GNU General Public Licence. See the COPYING file.
--
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

--{
--  AddToSearchPath(schema_name)
--
-- Adds the specified schema to the database search path
-- if it is not already in the database search path
-- This is a helper function for upgrade/install
-- We may want to move this function as a generic helper
CREATE OR REPLACE FUNCTION topology.AddToSearchPath(a_schema_name varchar)
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

--} AddToSearchPath

CREATE OR REPLACE FUNCTION topology.postgis_topology_scripts_installed() RETURNS text
	AS $$ SELECT '2.2.3'::text || ' r' || 15172::text AS version $$
	LANGUAGE 'sql' IMMUTABLE;

-- Make sure topology is in database search path --
SELECT topology.AddToSearchPath('topology');


-- PostGIS - Spatial Types for PostgreSQL
-- http://postgis.net
--
-- Copyright (C) 2012 Regina Obe <lr@pcorp.us>
-- This is free software; you can redistribute and/or modify it under
-- the terms of the GNU General Public Licence. See the COPYING file.
--
--  
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- These are reserved for functions where the they are changed to use default args  
-- This is installed after the new functions are installed
-- We don't have any of these yet for topology
-- The reason we put these after install is 
-- you can't drop a function that is used by sql functions
-- without forcing a drop on those as well which may cause issues with user functions.  
-- This allows us to CREATE OR REPLACE those in general topology.sql
-- without dropping them.

SELECT pg_catalog.pg_extension_config_dump('topology', '');
SELECT pg_catalog.pg_extension_config_dump('layer', '');

COMMENT ON TYPE topology.getfaceedges_returntype IS 'postgis type: A composite type that consists of a sequence number and edge number. This is the return type for ST_GetFaceEdges';

COMMENT ON TYPE topology.TopoGeometry IS 'postgis type: A composite type representing a topologically defined geometry';

COMMENT ON TYPE topology.validatetopology_returntype IS 'postgis type: A composite type that consists of an error message and id1 and id2 to denote location of error. This is the return type for ValidateTopology';

COMMENT ON DOMAIN topology.TopoElement IS 'postgis domain: An array of 2 integers generally used to identify a TopoGeometry component.';

COMMENT ON DOMAIN topology.TopoElementArray IS 'postgis domain: An array of TopoElement objects';

COMMENT ON FUNCTION topology.AddTopoGeometryColumn(varchar , varchar , varchar , varchar , varchar ) IS 'args: topology_name, schema_name, table_name, column_name, feature_type - Adds a topogeometry column to an existing table, registers this new column as a layer in topology.layer and returns the new layer_id.';
			
COMMENT ON FUNCTION topology.AddTopoGeometryColumn(varchar , varchar , varchar , varchar , varchar , integer ) IS 'args: topology_name, schema_name, table_name, column_name, feature_type, child_layer - Adds a topogeometry column to an existing table, registers this new column as a layer in topology.layer and returns the new layer_id.';
			
COMMENT ON FUNCTION topology.DropTopology(varchar ) IS 'args: topology_schema_name - Use with caution: Drops a topology schema and deletes its reference from topology.topology table and references to tables in that schema from the geometry_columns table.';
			
COMMENT ON FUNCTION topology.DropTopoGeometryColumn(varchar , varchar , varchar ) IS 'args: schema_name, table_name, column_name - Drops the topogeometry column from the table named table_name in schema schema_name and unregisters the columns from topology.layer table.';
			
COMMENT ON FUNCTION topology.TopologySummary(varchar ) IS 'args: topology_schema_name - Takes a topology name and provides summary totals of types of objects in topology';
			
COMMENT ON FUNCTION topology.ValidateTopology(varchar ) IS 'args: topology_schema_name - Returns a set of validatetopology_returntype objects detailing issues with topology';
			
COMMENT ON FUNCTION topology.CreateTopology(varchar ) IS 'args: topology_schema_name - Creates a new topology schema and registers this new schema in the topology.topology table.';
			
COMMENT ON FUNCTION topology.CreateTopology(varchar , integer ) IS 'args: topology_schema_name, srid - Creates a new topology schema and registers this new schema in the topology.topology table.';
			
COMMENT ON FUNCTION topology.CreateTopology(varchar , integer , double precision ) IS 'args: topology_schema_name, srid, tolerance - Creates a new topology schema and registers this new schema in the topology.topology table.';
			
COMMENT ON FUNCTION topology.CreateTopology(varchar , integer , double precision , boolean ) IS 'args: topology_schema_name, srid, tolerance, hasz - Creates a new topology schema and registers this new schema in the topology.topology table.';
			
COMMENT ON FUNCTION topology.CopyTopology(varchar , varchar ) IS 'args: existing_topology_name, new_name - Makes a copy of a topology structure (nodes, edges, faces, layers and TopoGeometries).';
			
COMMENT ON FUNCTION topology.ST_InitTopoGeo(varchar ) IS 'args: topology_schema_name - Creates a new topology schema and registers this new schema in the topology.topology table and details summary of process.';
			
COMMENT ON FUNCTION topology.ST_CreateTopoGeo(varchar , geometry ) IS 'args: atopology, acollection - Adds a collection of geometries to a given empty topology and returns a message detailing success.';
			
COMMENT ON FUNCTION topology.TopoGeo_AddPoint(varchar , geometry , float8 ) IS 'args: toponame, apoint, tolerance - Adds a point to an existing topology using a tolerance and possibly splitting an existing edge.';
			
COMMENT ON FUNCTION topology.TopoGeo_AddLineString(varchar , geometry , float8 ) IS 'args: toponame, aline, tolerance - Adds a linestring to an existing topology using a tolerance and possibly splitting existing edges/faces. Returns edge identifiers';
			
COMMENT ON FUNCTION topology.TopoGeo_AddPolygon(varchar , geometry , float8 ) IS 'args: atopology, apoly, atolerance - Adds a polygon to an existing topology using a tolerance and possibly splitting existing edges/faces.';
			
COMMENT ON FUNCTION topology.ST_AddIsoNode(varchar , integer , geometry ) IS 'args: atopology, aface, apoint - Adds an isolated node to a face in a topology and returns the nodeid of the new node. If face is null, the node is still created.';
			
COMMENT ON FUNCTION topology.ST_AddIsoEdge(varchar , integer , integer , geometry ) IS 'args: atopology, anode, anothernode, alinestring - Adds an isolated edge defined by geometry alinestring to a topology connecting two existing isolated nodes anode and anothernode and returns the edge id of the new edge.';
			
COMMENT ON FUNCTION topology.ST_AddEdgeNewFaces(varchar , integer , integer , geometry ) IS 'args: atopology, anode, anothernode, acurve - Add a new edge and, if in doing so it splits a face, delete the original face and replace it with two new faces.';
			
COMMENT ON FUNCTION topology.ST_AddEdgeModFace(varchar , integer , integer , geometry ) IS 'args: atopology, anode, anothernode, acurve - Add a new edge and, if in doing so it splits a face, modify the original face and add a new face.';
			
COMMENT ON FUNCTION topology.ST_RemEdgeNewFace(varchar , integer ) IS 'args: atopology, anedge - Removes an edge and, if the removed edge separated two faces,delete the original faces and replace them with a new face.';
			
COMMENT ON FUNCTION topology.ST_RemEdgeModFace(varchar , integer ) IS 'args: atopology, anedge - Removes an edge and, if the removed edge separated two faces,delete one of the them and modify the other to take the space of both.';
			
COMMENT ON FUNCTION topology.ST_ChangeEdgeGeom(varchar , integer , geometry ) IS 'args: atopology, anedge, acurve - Changes the shape of an edge without affecting the topology structure.';
			
COMMENT ON FUNCTION topology.ST_ModEdgeSplit(varchar , integer , geometry ) IS 'args: atopology, anedge, apoint - Split an edge by creating a new node along an existing edge, modifying the original edge and adding a new edge.';
			
COMMENT ON FUNCTION topology.ST_ModEdgeHeal(varchar , integer , integer ) IS 'args: atopology, anedge, anotheredge - Heal two edges by deleting the node connecting them, modifying the first edgeand deleting the second edge. Returns the id of the deleted node.';
			
COMMENT ON FUNCTION topology.ST_NewEdgeHeal(varchar , integer , integer ) IS 'args: atopology, anedge, anotheredge - Heal two edges by deleting the node connecting them, deleting both edges,and replacing them with an edge whose direction is the same as the firstedge provided.';
			
COMMENT ON FUNCTION topology.ST_MoveIsoNode(varchar , integer , geometry ) IS 'args: atopology, anedge, apoint - Moves an isolated node in a topology from one point to another. If new apoint geometry exists as a node an error is thrown. REturns description of move.';
			
COMMENT ON FUNCTION topology.ST_NewEdgesSplit(varchar , integer , geometry ) IS 'args: atopology, anedge, apoint - Split an edge by creating a new node along an existing edge, deleting the original edge and replacing it with two new edges. Returns the id of the new node created that joins the new edges.';
			
COMMENT ON FUNCTION topology.ST_RemoveIsoNode(varchar , integer ) IS 'args: atopology, anode - Removes an isolated node and returns description of action. If the node is not isolated (is start or end of an edge), then an exception is thrown.';
			
COMMENT ON FUNCTION topology.GetEdgeByPoint(varchar , geometry , float8 ) IS 'args: atopology, apoint, tol - Find the edge-id of an edge that intersects a given point';
			
COMMENT ON FUNCTION topology.GetFaceByPoint(varchar , geometry , float8 ) IS 'args: atopology, apoint, tol - Find the face-id of a face that intersects a given point';
			
COMMENT ON FUNCTION topology.GetNodeByPoint(varchar , geometry , float8 ) IS 'args: atopology, point, tol - Find the id of a node at a point location';
			
COMMENT ON FUNCTION topology.GetTopologyID(varchar) IS 'args: toponame - Returns the id of a topology in the topology.topology table given the name of the topology.';
			
COMMENT ON FUNCTION topology.GetTopologyID(varchar) IS 'args: toponame - Returns the SRID of a topology in the topology.topology table given the name of the topology.';
			
COMMENT ON FUNCTION topology.GetTopologyName(integer) IS 'args: topology_id - Returns the name of a topology (schema) given the id of the topology.';
			
COMMENT ON FUNCTION topology.ST_GetFaceEdges(varchar , integer ) IS 'args: atopology, aface - Returns a set of ordered edges that bound aface.';
			
COMMENT ON FUNCTION topology.ST_GetFaceGeometry(varchar , integer ) IS 'args: atopology, aface - Returns the polygon in the given topology with the specified face id.';
			
COMMENT ON FUNCTION topology.GetRingEdges(varchar , integer , integer ) IS 'args: atopology, aring, max_edges=null - Returns the ordered set of signed edge identifiers met by walking on ana given edge side.';
			
COMMENT ON FUNCTION topology.GetNodeEdges(varchar , integer ) IS 'args: atopology, anode - Returns an ordered set of edges incident to the given node.';
			
COMMENT ON FUNCTION topology.Polygonize(varchar ) IS 'args: toponame - Find and register all faces defined by topology edges';
			
COMMENT ON FUNCTION topology.AddNode(varchar , geometry , boolean , boolean ) IS 'args: toponame, apoint, allowEdgeSplitting=false, computeContainingFace=false - Adds a point node to the node table in the specified topology schema and returns the nodeid of new node. If point already exists as node, the existing nodeid is returned.';
			
COMMENT ON FUNCTION topology.AddEdge(varchar , geometry ) IS 'args: toponame, aline - Adds a linestring edge to the edge table and associated start and end points to the point nodes table of the specified topology schema using the specified linestring geometry and returns the edgeid of the new (or existing) edge.';
			
COMMENT ON FUNCTION topology.AddFace(varchar , geometry , boolean ) IS 'args: toponame, apolygon, force_new=false - Registers a face primitive to a topology and gets its identifier.';
			
COMMENT ON FUNCTION topology.ST_Simplify(TopoGeometry, float) IS 'args: geomA, tolerance - Returns a "simplified" geometry version of the given TopoGeometry using the Douglas-Peucker algorithm.';
			
COMMENT ON FUNCTION topology.CreateTopoGeom(varchar , integer , integer, topoelementarray) IS 'args: toponame, tg_type, layer_id, tg_objs - Creates a new topo geometry object from topo element array - tg_type: 1:[multi]point, 2:[multi]line, 3:[multi]poly, 4:collection';
			
COMMENT ON FUNCTION topology.CreateTopoGeom(varchar , integer , integer) IS 'args: toponame, tg_type, layer_id - Creates a new topo geometry object from topo element array - tg_type: 1:[multi]point, 2:[multi]line, 3:[multi]poly, 4:collection';
			
COMMENT ON FUNCTION topology.toTopoGeom(geometry , varchar , integer, float8) IS 'args: geom, toponame, layer_id, tolerance - Converts a simple Geometry into a topo geometry';
			
COMMENT ON FUNCTION topology.toTopoGeom(geometry , topogeometry , float8) IS 'args: geom, topogeom, tolerance - Converts a simple Geometry into a topo geometry';
			
COMMENT ON AGGREGATE topology.TopoElementArray_Agg(topoelement) IS 'args: tefield - Returns a topoelementarray for a set of element_id, type arrays (topoelements)';
			
COMMENT ON FUNCTION topology.clearTopoGeom(topogeometry ) IS 'args: topogeom - Clears the content of a topo geometry';
			
COMMENT ON FUNCTION topology.GetTopoGeomElementArray(varchar , integer , integer) IS 'args: toponame, layer_id, tg_id - Returns a topoelementarray (an array of topoelements) containing the topological elements and type of the given TopoGeometry (primitive elements)';
			
COMMENT ON FUNCTION topology.GetTopoGeomElementArray(topogeometry ) IS 'args: tg - Returns a topoelementarray (an array of topoelements) containing the topological elements and type of the given TopoGeometry (primitive elements)';
			
COMMENT ON FUNCTION topology.GetTopoGeomElements(varchar , integer , integer) IS 'args: toponame, layer_id, tg_id - Returns a set of topoelement objects containing the topological element_id,element_type of the given TopoGeometry (primitive elements)';
			
COMMENT ON FUNCTION topology.GetTopoGeomElements(topogeometry ) IS 'args: tg - Returns a set of topoelement objects containing the topological element_id,element_type of the given TopoGeometry (primitive elements)';
			
COMMENT ON FUNCTION topology.AsGML(topogeometry ) IS 'args: tg - Returns the GML representation of a topogeometry.';
			
COMMENT ON FUNCTION topology.AsGML(topogeometry , text ) IS 'args: tg, nsprefix_in - Returns the GML representation of a topogeometry.';
			
COMMENT ON FUNCTION topology.AsGML(topogeometry , regclass ) IS 'args: tg, visitedTable - Returns the GML representation of a topogeometry.';
			
COMMENT ON FUNCTION topology.AsGML(topogeometry , regclass , text ) IS 'args: tg, visitedTable, nsprefix - Returns the GML representation of a topogeometry.';
			
COMMENT ON FUNCTION topology.AsGML(topogeometry , text , integer , integer ) IS 'args: tg, nsprefix_in, precision, options - Returns the GML representation of a topogeometry.';
			
COMMENT ON FUNCTION topology.AsGML(topogeometry , text , integer , integer , regclass ) IS 'args: tg, nsprefix_in, precision, options, visitedTable - Returns the GML representation of a topogeometry.';
			
COMMENT ON FUNCTION topology.AsGML(topogeometry , text , integer , integer , regclass , text ) IS 'args: tg, nsprefix_in, precision, options, visitedTable, idprefix - Returns the GML representation of a topogeometry.';
			
COMMENT ON FUNCTION topology.AsGML(topogeometry , text , integer , integer , regclass , text , int ) IS 'args: tg, nsprefix_in, precision, options, visitedTable, idprefix, gmlversion - Returns the GML representation of a topogeometry.';
			
COMMENT ON FUNCTION topology.AsTopoJSON(topogeometry , regclass ) IS 'args: tg, edgeMapTable - Returns the TopoJSON representation of a topogeometry.';
			
COMMENT ON FUNCTION topology.Equals(topogeometry , topogeometry ) IS 'args: tg1, tg2 - Returns true if two topogeometries are composed of the same topology primitives.';
			
COMMENT ON FUNCTION topology.Intersects(topogeometry , topogeometry ) IS 'args: tg1, tg2 - Returns true if any pair of primitives from thetwo topogeometries intersect.';
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
