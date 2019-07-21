-- Setup script for Manual Repair demo.

-- Drop old database
USE [master];
GO

IF DATABASEPROPERTYEX (N'Company', N'Version') > 0
BEGIN
	ALTER DATABASE [Company] SET SINGLE_USER
		WITH ROLLBACK IMMEDIATE;
	DROP DATABASE [Company];
END

-- Create database and table to use
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
	[c1] INT IDENTITY,
	[c2] INT DEFAULT CONVERT (INT, 100000 * RAND ()),
	[c3] CHAR (8000) DEFAULT 'filler',
	[c4] VARCHAR (MAX));
CREATE CLUSTERED INDEX [RandomData_CL]
ON [RandomData] (c1);
GO

INSERT INTO [RandomData] ([c4])
VALUES ('Some random stuff that is quite long and will push the row off-page');

INSERT INTO [RandomData] ([c4])
VALUES ('Very important data including some random and contrived bytes: X&((99X((73=s9930');

INSERT INTO [RandomData] ([c4])
VALUES ('More random stuff that is quite long and will push the row off-page');

INSERT INTO [RandomData] ([c4])
VALUES ('More random stuff that is quite long and will push the row off-page');

INSERT INTO [RandomData] ([c4])
VALUES ('More random stuff that is quite long and will push the row off-page');
GO

-- This time we don't create a backup

-- Pick the second data page, and note the LOB pages
DBCC IND (N'Company', N'RandomData', -1);
GO

ALTER DATABASE [Company] SET SINGLE_USER;
GO

-- First page
DECLARE @offset INT;
SELECT @offset = 0;
WHILE (@offset < 8190)
BEGIN
	DBCC WRITEPAGE (N'Company', 1, XX, @offset, 8, 0x0000000000000000, 1);
	SELECT @offset = @offset + 8;
END;
GO

ALTER DATABASE [Company] SET MULTI_USER;
GO

-- Tidy up
DELETE FROM [msdb].[dbo].[suspect_pages];
GO

USE [master];
GO