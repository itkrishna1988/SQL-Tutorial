-- Demo script for Introducing DBCC WRITEPAGE demo.

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

-- Pick a page and engineer a page checksum failure
DBCC WRITEPAGE (N'Company', 1, XX, 0, 2, 0x0000);
GO

-- Did it get corrupted?
SELECT * FROM [Company].[dbo].[RandomData];
GO

DBCC CHECKDB (N'Company') WITH NO_INFOMSGS;
GO

-- Yes, but why no 824?

-- Now use the special parameter
ALTER DATABASE [Company] SET SINGLE_USER;
GO
DBCC WRITEPAGE (N'Company', 1, XX, 0, 2, 0x0000, 1);
GO
ALTER DATABASE [Company] SET MULTI_USER;
GO

-- Did it get corrupted?
SELECT * FROM [Company].[dbo].[RandomData];
GO

-- Still why no corruption?

-- Now use the special parameter
ALTER DATABASE [Company] SET SINGLE_USER;
GO
DBCC WRITEPAGE (N'Company', 1, XX, 0, 2, 0x1111, 1);
GO
ALTER DATABASE [Company] SET MULTI_USER;
GO

-- Did it get corrupted?
SELECT * FROM [Company].[dbo].[RandomData];
GO

DBCC CHECKDB (N'Company') WITH NO_INFOMSGS;
GO