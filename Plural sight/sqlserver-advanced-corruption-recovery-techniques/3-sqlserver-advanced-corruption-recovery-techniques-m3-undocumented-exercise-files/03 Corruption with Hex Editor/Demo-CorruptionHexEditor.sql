-- Demo script for Causing Corruption with a Hex Editor demo.

-- Create the database
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

USE [Company];
GO

-- Make sure page checksums are enabled
ALTER DATABASE [Company] SET PAGE_VERIFY CHECKSUM;
GO

CREATE TABLE [RandomData] (
	[c1]  INT IDENTITY,
	[c2]  CHAR (8000) DEFAULT 'a');
GO

INSERT INTO [RandomData] DEFAULT VALUES;
GO 10

-- List the pages in the table
DBCC IND (N'Company', N'RandomData', -1);
GO

-- Pick any page and work out the file offset in bytes
SELECT XX * 8192;
GO

-- Set the database offline
ALTER DATABASE [Company] SET OFFLINE;
GO

-- Open the hex editor and go to the offset
-- Insert some zeroes
-- Save the file

-- Bring the database online
ALTER DATABASE [Company] SET ONLINE;
GO

-- Did we cause corruption?
SELECT * FROM [Company].[dbo].[RandomData];
GO

-- Much more tedious for specific corruptions
-- Use DBCC WRITEPAGE instead


