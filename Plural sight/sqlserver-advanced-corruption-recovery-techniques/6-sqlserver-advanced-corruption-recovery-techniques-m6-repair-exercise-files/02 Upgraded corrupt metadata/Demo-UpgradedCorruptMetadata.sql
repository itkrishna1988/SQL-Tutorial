-- Demo script for Upgraded Corrupt Metadata demo.

-- Demo databases can be downloaded from
-- http://bit.ly/10fKpbS (that's a zero).

-- Download the 2000 Corrupt Database from the link above
-- and unzip into D:\Pluralsight.

USE [master];
GO

-- Restore the corrupt 2000 database
RESTORE DATABASE [DemoCorruptMetadata] FROM
DISK = N'D:\Pluralsight\DemoCorruptMetadata2000.bak'
WITH MOVE N'DemoCorruptMetadata' TO
	N'D:\Pluralsight\DemoCorruptMetadata.mdf',
MOVE N'DemoCorruptMetadata_log' TO
	N'D:\Pluralsight\DemoCorruptMetadata_log.ldf',
REPLACE;
GO

-- Not compatible with 2012 as it's too old. Switch to a
-- 2005/2008/2008 R2 instance and try again

RESTORE DATABASE [DemoCorruptMetadata] FROM
DISK = N'D:\Pluralsight\DemoCorruptMetadata2000.bak'
WITH MOVE N'DemoCorruptMetadata' TO
	N'D:\Pluralsight\DemoCorruptMetadata.mdf',
MOVE N'DemoCorruptMetadata_log' TO
	N'D:\Pluralsight\DemoCorruptMetadata_log.ldf',
REPLACE;
GO

-- Check consistency
DBCC CHECKDB (N'DemoCorruptMetadata') WITH NO_INFOMSGS;
GO

-- Note the object ID: 

-- Try to repair...
ALTER DATABASE [DemoCorruptMetadata] SET SINGLE_USER;
GO
DBCC CHECKDB (N'DemoCorruptMetadata', REPAIR_ALLOW_DATA_LOSS)
WITH NO_INFOMSGS;
GO
ALTER DATABASE [DemoCorruptMetadata] SET MULTI_USER;
GO

USE [DemoCorruptMetadata];
GO

-- Which system tables exist?
SELECT
	[name]
FROM
	[sys].[objects];
GO

-- Narrow down to columns
--
SELECT
	[name]
FROM
	[sys].[objects]
WHERE
	[name] LIKE N'%col%';
GO

-- Try looking at columns
SELECT * FROM [sys].[XXX]
WHERE 1=0;
GO

-- Connect with the DAC and try again...
USE [DemoCorruptMetadata];
GO

SELECT * FROM [sys].[XXX]
WHERE 1=0;
GO

-- Find the right table, then try deleting

-- Reboot in single-user mode and delete it,
-- remembering to USE the database first

-- Then check the boot page...
DBCC TRACEON (3604);
DBCC DBINFO;
GO

-- Reboot out of single-user mode and disconnect
-- from the DAC