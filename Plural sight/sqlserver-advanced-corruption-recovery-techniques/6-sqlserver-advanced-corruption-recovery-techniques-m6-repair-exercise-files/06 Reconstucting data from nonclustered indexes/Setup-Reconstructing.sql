-- Setup script for Reconstructing demo.

-- Drop old database
USE [master];
GO

IF DATABASEPROPERTYEX (N'Company', N'Version') > 0
BEGIN
	ALTER DATABASE [Company] SET SINGLE_USER
		WITH ROLLBACK IMMEDIATE;
	DROP DATABASE [Company];
END

-- Create database and table
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

CREATE TABLE [Sales] (
	[SalesID] INT IDENTITY,
	[CustomerID] INT DEFAULT CONVERT (INT, 100000 * RAND ()),
	[SalesDate] DATETIME DEFAULT GETDATE (),
	[SalesAmount] MONEY);

CREATE CLUSTERED INDEX [SalesCI] ON [Sales] ([SalesID]);
GO

-- Populate the table
SET NOCOUNT ON;
GO

DECLARE @count INT
SELECT @count = 0
WHILE (@count < 5000)
BEGIN
	INSERT INTO [Sales] ([SalesAmount])	VALUES (100 * RAND ());
	SELECT @count = @count + 1;
END;
GO

-- Create some nonclustered indexes
CREATE NONCLUSTERED INDEX [SalesNCI_CustomerID]
ON [Sales] ([CustomerID]);

CREATE NONCLUSTERED INDEX [SalesNCI_SalesDate_SalesAmount]
ON [Sales] ([SalesDate]) INCLUDE ([SalesAmount]);
GO

-- This time we don't create a backup

-- Pick a page to corrupt
DBCC IND (N'Company', N'Sales', -1);
GO

ALTER DATABASE [Company] SET SINGLE_USER;
GO

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