-- Setup script for Failed Page Restore demo.

-- Create a database to use
USE [master];
GO

IF DATABASEPROPERTYEX (N'Company', N'Version') > 0
BEGIN
	ALTER DATABASE [Company] SET SINGLE_USER
		WITH ROLLBACK IMMEDIATE;
	DROP DATABASE [Company];
END
GO

-- Create the database to use
CREATE DATABASE [Company] ON PRIMARY (
    NAME = N'Company',
    FILENAME = N'D:\Pluralsight\Company.mdf')
LOG ON (
    NAME = N'Company_log',
    FILENAME = N'D:\Pluralsight\Company_log.ldf',
    SIZE = 5MB,
    FILEGROWTH = 1MB);
GO

USE [Company];
GO

CREATE TABLE [RandomData] (
	[c1]  INT IDENTITY,
	[c2]  CHAR (8000) DEFAULT 'a');
GO

INSERT INTO [RandomData] DEFAULT VALUES;
GO 10

-- Create backups
BACKUP DATABASE [Company] TO
DISK = N'D:\Pluralsight\Company_Full.bak'
WITH INIT;
GO

BACKUP LOG [Company] TO
DISK = N'D:\Pluralsight\Company_Log1.bak'
WITH INIT;
GO

-- Pick a page to corrupt
ALTER DATABASE [Company] SET SINGLE_USER;
GO

-- Corrupt a PFS page
DBCC WRITEPAGE (N'Company', 1, 1, 0, 4, 0x00000000);

ALTER DATABASE [Company] SET MULTI_USER;
GO

-- Clean up
DELETE FROM [msdb].[dbo].[suspect_pages];
GO