-- New Cardinality Estimator Demonstration
-- Glenn Berry
-- SQLskills

USE AdventureWorks2014;
GO

-- Optimizing Your Query Plans with the SQL Server 2014 Cardinality Estimator
-- https://msdn.microsoft.com/en-us/library/dn673537.aspx 


-- Query hint 2312 is associated with new Cardinality Estimator
-- Query hint 9481 is associated with legacy Cardinality Estimator

-- Turn on Graphical Execution Plan (Ctrl+M)

-- Get compatibility level for all databases
SELECT name, compatibility_level
FROM sys.databases;

-- Browse the data
SELECT City, COUNT(City) AS [City Count]
FROM Person.[Address]
GROUP BY City
ORDER BY COUNT(City) DESC;

-- Use legacy Cardinality Estimator for this database
ALTER DATABASE AdventureWorks2014 SET COMPATIBILITY_LEVEL = 110;


-- Database is in 110 compatibility level, so it uses the legacy Cardinality Estimator
SELECT AddressID, AddressLine1, AddressLine2, City, StateProvinceID,
       PostalCode, SpatialLocation, rowguid, ModifiedDate  
FROM Person.[Address] 
WHERE City = N'Berkeley' 
AND PostalCode = N'94704';
-- Estimated number of rows is 2.08
-- Actual number of rows is 202


-- Use new Cardinality Estimator for this query
SELECT AddressID, AddressLine1, AddressLine2, City, StateProvinceID,
       PostalCode, SpatialLocation, rowguid, ModifiedDate  
FROM Person.[Address] 
WHERE City = N'Berkeley' 
AND PostalCode = N'94704'
OPTION (QUERYTRACEON 2312);
-- Estimated number of rows is 20.49 
-- Actual number of rows is 202


-- Use new Cardinality Estimator for this database
ALTER DATABASE AdventureWorks2014 SET COMPATIBILITY_LEVEL = 120;



-- Database is in 120 compatibility level, so it uses the new Cardinality Estimator
SELECT AddressID, AddressLine1, AddressLine2, City, StateProvinceID,
       PostalCode, SpatialLocation, rowguid, ModifiedDate  
FROM Person.[Address] 
WHERE City = N'Berkeley' 
AND PostalCode = N'94704';
-- Estimated number of rows is 20.49 
-- Actual number of rows is 202


-- Use legacy Cardinality Estimator for this query
SELECT AddressID, AddressLine1, AddressLine2, City, StateProvinceID,
       PostalCode, SpatialLocation, rowguid, ModifiedDate  
FROM Person.[Address] 
WHERE City = N'Berkeley' 
AND PostalCode = N'94704'
OPTION (QUERYTRACEON 9481);
-- Estimated number of rows is 2.08
-- Actual number of rows is 202

-- Run previous two queries in a batch and compare costs for each query




