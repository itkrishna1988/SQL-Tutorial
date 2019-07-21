-- Setup script for Piecemeal Restore demo.

-- Demo databases can be downloaded from
-- http://bit.ly/10fKpbS (that's a zero).

-- Download the 2008 SalesDB Sample Database from the link above
-- and unzip into D:\Pluralsight.

USE [master];
GO

IF DATABASEPROPERTYEX (N'SalesDB', N'Version') > 0
BEGIN
	ALTER DATABASE [SalesDB] SET SINGLE_USER
		WITH ROLLBACK IMMEDIATE;
	DROP DATABASE [SalesDB];
END
GO

RESTORE DATABASE [SalesDB]
FROM DISK = N'D:\Pluralsight\SalesDBOriginal.bak'
WITH
    MOVE N'SalesDBData' TO N'D:\Pluralsight\SalesDB.mdf',
	MOVE N'SalesDBLog' TO N'D:\Pluralsight\SalesDB_Log.ldf';
GO

-- Repartition the big sales table onto
--  new filegroups
USE [SalesDB];
GO

-- Create the filegroups
ALTER DATABASE [SalesDB] ADD FILEGROUP [SalesDBSales2010];
ALTER DATABASE [SalesDB] ADD FILEGROUP [SalesDBSales2009];
ALTER DATABASE [SalesDB] ADD FILEGROUP [SalesDBSales2008];
ALTER DATABASE [SalesDB] ADD FILEGROUP [SalesDBSales2007];
GO

-- And add a file in each
ALTER DATABASE [SalesDB] ADD FILE (
	NAME = N'SalesDBSales2010',
	FILENAME = N'D:\Pluralsight\SalesDBSales2010.ndf', 
	SIZE = 100,
	MAXSIZE = 120,
	FILEGROWTH = 10)
TO FILEGROUP [SalesDBSales2010];

ALTER DATABASE [SalesDB] ADD FILE (
	NAME = N'SalesDBSales2009',
	FILENAME = N'D:\Pluralsight\SalesDBSales2009.ndf', 
	SIZE = 100,
	MAXSIZE = 120,
	FILEGROWTH = 10)
TO FILEGROUP [SalesDBSales2009];

ALTER DATABASE [SalesDB] ADD FILE (
	NAME = N'SalesDBSales2008',
	FILENAME = N'D:\Pluralsight\SalesDBSales2008.ndf', 
	SIZE = 100,
	MAXSIZE = 120,
	FILEGROWTH = 10)
TO FILEGROUP [SalesDBSales2008];

ALTER DATABASE [SalesDB] ADD FILE (
	NAME = N'SalesDBSales2007',
	FILENAME = N'D:\Pluralsight\SalesDBSales2007.ndf', 
	SIZE = 100,
	MAXSIZE = 120,
	FILEGROWTH = 10)
TO FILEGROUP [SalesDBSales2007];
GO

-- Create the partitioning metadata
CREATE PARTITION FUNCTION [Sales4Partitions_PFN] (INT)
AS 
RANGE RIGHT FOR VALUES (
	2000000,		-- 2 million
	4000000,		-- 4 million
	6000000);		-- 6 million
GO

CREATE PARTITION SCHEME [Sales4Partitions_PS]
AS 
PARTITION [Sales4Partitions_PFN] TO (
	[SalesDBSales2007],
	[SalesDBSales2008], 
	[SalesDBSales2009],
	[SalesDBSales2010]);
GO

-- Move the table to the new schema
-- (Takes a minute or so)
CREATE UNIQUE CLUSTERED INDEX [SalesPK] 
	ON [Sales] ([SalesID])
WITH (DROP_EXISTING = ON, ONLINE = ON)
ON [Sales4Partitions_PS] ([SalesID])
GO

-- Check it got moved
EXEC sp_help [Sales];
GO

-- Make sure we have backups to restore from
BACKUP DATABASE [SalesDB] TO
DISK = N'D:\Pluralsight\SalesDB_Full.bak'
WITH INIT, STATS;
GO

BACKUP LOG [SalesDB] TO
DISK = N'D:\Pluralsight\SalesDB_Log1.bak'
WITH INIT, STATS;
GO