

---STArea()
DECLARE @g geometry;
SET @g = geometry::STGeomFromText('POLYGON((0 0, 3 0, 3 3, 0 3, 0 0),(2 2, 2 1, 1 1, 1 2, 2 2))', 0);
SELECT @g.STArea();
GO

--STAsBinary ()
DECLARE @g geometry;
SET @g = geometry::STGeomFromText('LINESTRING(0 0, 2 3)', 0);
SELECT @g.STAsBinary();
SELECT @g.STArea();

GO
--STDifference ( other_geometry )

DECLARE @g geometry;
DECLARE @h geometry;
SET @g = geometry::STGeomFromText('POLYGON((0 0, 0 2, 2 2, 2 0, 0 0))', 0);
SET @h = geometry::STGeomFromText('POLYGON((1 1, 3 1, 3 3, 1 3, 1 1))', 0);
SELECT @g.STDifference(@h)
SELECT @g.STDifference(@h).ToString();
GO

--AsGml ( )
DECLARE @g geometry;
SET @g = geometry::STGeomFromText('LINESTRING(0 0, 0 1, 1 0)', 0)
SELECT @g.AsGml()

GO
--BufferWithTolerance ( distance, tolerance, relative )
DECLARE @g geography;
SET @g = geography::STGeomFromText('POINT(-122.34900 47.65100)', 4326);
SELECT @g.BufferWithTolerance(1, .5, 0).ToString();
GO
--MakeValid ()

DECLARE @g geometry;
SET @g = geometry::STGeomFromText('LINESTRING(0 2, 1 1, 1 0, 1 1, 2 2)', 0);
SELECT @g.STIsValid()
GO

--STGeomFromText ( 'geometry_tagged_text' , SRID )
DECLARE @g geometry;
SET @g = geometry::STGeomFromText('LINESTRING (100 100, 20 180, 180 180)', 0);
SELECT @g
SELECT @g.ToString()
GO

--STPointFromText ( 'point_tagged_text' , SRID )

DECLARE @g geometry;
SET @g = geometry::STPointFromText('POINT (100 100)', 0);
SELECT @g.ToString()
GO

---Conversion from geometry to geography

DECLARE @WKT VARCHAR(255) = 'POLYGON((2 52, 0 52, 0 50, 2 50, 2 52))';
DECLARE @SRID INT = 4326;
SELECT geography::STGeomFromText(@WKT, @SRID)
SELECT geometry::STGeomFromText(@WKT, @SRID)

/*****************  Geogrphy ********************************/

  
CREATE table test_geom(PlaceName Varchar(100),location geometry)
GO
insert into test_geom
select 'madurai','POLYGON((2 50, 0 50, 0 48, 2 48, 2 50))'

GO
select * from test_geom
GO
ALTER TABLE test_geom
ADD geog geography
GO
UPDATE test_geom
SET geog = geography::STGeomFromWKB(location.STAsBinary(), location.STSrid)
WHERE PlaceName  IN('chennai', 'Madurai')
GO
----Fixing any invalid geometries with MakeValid()
select location.STIsValid()
,* from test_geom

GO
UPDATE test_geom
SET geog = geography::STGeomFromWKB(location.MakeValid().STAsBinary(), 4326)
WHERE PlaceName = 'chennai'

select location.STIsValid()
,* from test_geom

GO
---Ensuring the correct ring orientation with Spatial Ed's trick
UPDATE test_geom
SET geog = geography::STGeomFromWKB(location.STUnion(location.STStartPoint()).STAsBinary(), 4326)
WHERE PlaceName = 'chennai'
select * from test_geom

GO
--Buffer()-ing and UnBuffer()-ing
UPDATE test_geom
SET geog = geography::STGeomFromWKB(location.STBuffer(0.00001).STBuffer(-0.00001).STAsBinary(), 4326)
WHERE PlaceName = 'Madurai'
select * from test_geom
 
 GO
 -- Create spatial index
 create table test_spatial_idx(companyID int Primary key,location geography )
 CREATE SPATIAL INDEX spatial_idx 
   ON test_spatial_idx(location)
 
GO


