-- Setup script for Example Output demo.

-- This setup script uses the undocumented DBCC WRITEPAGE
-- command to cause corruption and the undocumented DBCC IND
-- command to find pages to corrupt. These commands are explained
-- in detail in Module 3 of the course SQL Server: Advanced
-- Corruption Recovery Techniques.

USE [master];
GO

IF DATABASEPROPERTYEX (N'Company', N'Version') > 0
BEGIN
	ALTER DATABASE [Company] SET SINGLE_USER
		WITH ROLLBACK IMMEDIATE;
	DROP DATABASE [Company];
END
GO

IF DATABASEPROPERTYEX (N'Company2', N'Version') > 0
BEGIN
	ALTER DATABASE [Company2] SET SINGLE_USER
		WITH ROLLBACK IMMEDIATE;
	DROP DATABASE [Company2];
END
GO

CREATE DATABASE [Company] ON PRIMARY (
    NAME = N'Company',
    FILENAME = N'D:\Pluralsight\Company.mdf')
LOG ON (
    NAME = N'Company_log',
    FILENAME = N'D:\Pluralsight\Company_log.ldf');
GO

USE [Company];
GO

CREATE TABLE [RandomData] (
	[c1]  INT IDENTITY,
	[c2]  CHAR (8000) DEFAULT 'a');
GO

INSERT INTO [RandomData] DEFAULT VALUES;
GO 10

CREATE DATABASE [Company2] ON PRIMARY (
    NAME = N'Company2',
    FILENAME = N'D:\Pluralsight\Company2.mdf')
LOG ON (
    NAME = N'Company2_log',
    FILENAME = N'D:\Pluralsight\Company2_log.ldf');
GO

USE [Company2];
GO

CREATE TABLE [RandomData] (
	[c1]  INT IDENTITY,
	[c2]  CHAR (8000) DEFAULT 'a');
GO

INSERT INTO [RandomData] DEFAULT VALUES;
GO 10

-- List the pages in the table
DBCC IND (N'Company2', N'RandomData', -1);
GO

-- Pick a page to corrupt
ALTER DATABASE [Company2] SET SINGLE_USER;
GO
DBCC WRITEPAGE (N'Company2', X, X, 0, 2, 0x0000, 1);
GO
ALTER DATABASE [Company2] SET MULTI_USER;
GO

-- Clean the error log and suspect_pages
DELETE FROM [msdb].[dbo].[suspect_pages];
EXEC sp_cycle_errorlog;
GO