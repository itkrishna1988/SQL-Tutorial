-- Setup script for Simple Page Restore demo.

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

-- Pick a page and corrupt it
-- List the pages in the table
DBCC IND (N'Company', N'RandomData', -1);
GO

-- Pick a page to corrupt
ALTER DATABASE [Company] SET SINGLE_USER;
GO

DECLARE @offset INT;
SELECT @offset = 0;

WHILE (@offset < 8185)
BEGIN
	DBCC WRITEPAGE (N'Company', 1, XX, @offset, 8, 0x0000000000000000, 1);
	SELECT @offset = @offset + 8;
END;
GO

ALTER DATABASE [Company] SET MULTI_USER;
GO

-- Clean up
DELETE FROM [msdb].[dbo].[suspect_pages];
GO