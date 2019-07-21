-- Demo script for Partial Restore demo.

-- Run Setup-PartialRestore.sql first

-- Disaster strikes!
DROP DATABASE [SalesDB];
GO

-- How to restore as fast as possible?

-- Start with the PRIMARY filegroup
RESTORE DATABASE [SalesDB]
FILEGROUP = N'PRIMARY'
FROM DISK = N'D:\Pluralsight\SalesDB_Full.bak'
WITH PARTIAL, NORECOVERY;
GO

-- Bring the OLTP filegroup online
RESTORE DATABASE [SalesDB]
FILEGROUP = N'SalesDBSales2010'
FROM DISK = N'D:\Pluralsight\SalesDB_Full.bak'
WITH NORECOVERY, STATS;
GO

-- Restore transaction log backups...
RESTORE LOG [SalesDB]
FROM DISK = N'D:\Pluralsight\SalesDB_Log1.bak'
WITH NORECOVERY, STATS;
GO

-- Bring the database online
RESTORE DATABASE [SalesDB] WITH RECOVERY;
GO

-- Check the file states
SELECT
	[name],
	[state_desc]
FROM
	[SalesDB].[sys].[database_files];
GO

-- Beware of queries that need to access all
-- filegroups
SELECT
	COUNT (*)
FROM
	[SalesDB].[dbo].[Sales]
WHERE
	[CustomerID] = 1440;
GO

-- Start Demo-Workload.sql in another connection

-- Piecemeal restore of other filegroups is possible,
-- and can be done with online activity in Enterprise Edition

-- Restore another filegroup
RESTORE DATABASE [SalesDB]
FILEGROUP = N'SalesDBSales2009'
FROM DISK = N'D:\Pluralsight\SalesDB_Full.bak'
WITH NORECOVERY, STATS;
GO

-- Restore transaction log backups...
RESTORE LOG [SalesDB]
FROM DISK = N'D:\Pluralsight\SalesDB_Log1.bak'
WITH NORECOVERY, STATS;
GO

-- Bring the database online
RESTORE DATABASE [SalesDB] WITH RECOVERY;
GO

-- Check the file states
SELECT
	[name],
	[state_desc]
FROM
	[SalesDB].[sys].[database_files];
GO

-- No change to the online workload