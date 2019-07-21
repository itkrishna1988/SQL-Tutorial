-- Demo script for DBCC IND and DBCC PAGE demo.

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

CREATE DATABASE [Company] ON PRIMARY (
    NAME = N'Company',
    FILENAME = N'D:\Pluralsight\Company.mdf')
LOG ON (
    NAME = N'Company_log',
    FILENAME = N'D:\Pluralsight\Company_log.ldf');
GO

USE [Company];
GO

-- Create a table and some indexes
CREATE TABLE [RandomData] (
	[c1]  INT IDENTITY,
	[c2]  DATETIME2,
	[c3]  VARCHAR (5000) DEFAULT REPLICATE ('a', 5000),
	[c4]  VARCHAR (5000) DEFAULT REPLICATE ('b', 5000),
	[c5]  VARCHAR (MAX)  DEFAULT REPLICATE ('c', 5000));
GO

INSERT INTO [RandomData] DEFAULT VALUES;
GO 10

CREATE CLUSTERED INDEX [RandomData_CL_c1]
ON [RandomData] ([c1]);

CREATE NONCLUSTERED INDEX [RandomData_NCL_c2]
ON [RandomData] ([c2]);
GO

-- DBCC IND dump styles
-- Notice the allocation unit types and page linkages
DBCC IND (N'Company', N'RandomData', 0);
GO

DBCC IND (N'Company', N'RandomData', 1);
GO

DBCC IND (N'Company', N'RandomData', 2);
GO

DBCC IND (N'Company', N'RandomData', -1);
GO

DBCC IND (N'Company', N'RandomData', -2);
GO

-- DBCC PAGE dump styles
DBCC TRACEON (3604);
GO

-- Show data page - type 1
DBCC IND (N'Company', N'RandomData', 1);
GO

DBCC PAGE (N'Company', 1, XX, 0);
GO

DBCC PAGE (N'Company', 1, XX, 1);
GO

DBCC PAGE (N'Company', 1, XX, 2);
GO

DBCC PAGE (N'Company', 1, XX, 3);
GO

-- Show index page - type 2
DBCC IND (N'Company', N'RandomData', 1);
GO

DBCC PAGE (N'Company', 1, XX, 3);
GO

DBCC PAGE (N'Company', 1, XX, 1);
GO

-- Show IAM page - type 10
DBCC IND (N'Company', N'RandomData', 1);
GO

DBCC PAGE (N'Company', 1, XX, 3);
GO

-- Show PFS Page, for example
DBCC PAGE (N'Company', 1, 1, 3);
GO
