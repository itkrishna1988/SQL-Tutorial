-- Demo script for Piecemeal Restore demo.

-- Run Setup-PiecemealRestore.sql first

-- Start Demo-Workload.sql in another connection

-- Imagine a disaster in a non-PRIMARY filegroup
-- To restore we must first put the damaged
-- filegroup offline by setting one of the files
-- offline. Beware - one-way operation!
ALTER DATABASE [SalesDB]
MODIFY FILE (NAME = [SalesDBSales2009], OFFLINE);
GO

-- What happened to the workload?

-- Restart the workload

-- Check the file states
SELECT
	[name],
	[state_desc]
FROM
	[SalesDB].[sys].[database_files];
GO

-- Back up the tail of the log
BACKUP LOG [SalesDB] TO
DISK = N'D:\Pluralsight\SalesDB_Log_Tail.bak'
WITH INIT;
GO

-- Now restore the filegroup
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

RESTORE LOG [SalesDB]
FROM DISK = N'D:\Pluralsight\SalesDB_Log_Tail.bak'
WITH NORECOVERY;
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
