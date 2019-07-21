-- Demo script for DBCC DBTABLE and DBCC DBINFO demo.

-- Demo databases can be downloaded from
-- http://bit.ly/10fKpbS (that's a zero).

-- Download the 2008 SalesDB Sample Database from the link above
-- and unzip into D:\Pluralsight.

-- Restore as follows:
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
	MOVE N'SalesDBLog' TO N'D:\Pluralsight\SalesDB.ldf';
GO

-- And create a small database
IF DATABASEPROPERTYEX (N'Company', N'Version') > 0
BEGIN
	ALTER DATABASE [Company] SET SINGLE_USER
		WITH ROLLBACK IMMEDIATE;
	DROP DATABASE [Company];
END
GO

CREATE DATABASE [Company] ON PRIMARY (
    NAME = N'Company',
    FILENAME = N'D:\Pluralsight\Company.mdf')
LOG ON (
    NAME = N'Company_log',
    FILENAME = N'D:\Pluralsight\Company_log.ldf');
GO

-- Enable the trace flag
DBCC TRACEON (3604);
GO

-- DBCC DBINFO
DBCC DBINFO (N'SalesDB');
GO

-- DBCC DBTABLE
DBCC DBTABLE (N'Company');
GO

-- And for SalesDB
-- Note the upgrade time
DBCC DBTABLE (N'SalesDB');
GO

