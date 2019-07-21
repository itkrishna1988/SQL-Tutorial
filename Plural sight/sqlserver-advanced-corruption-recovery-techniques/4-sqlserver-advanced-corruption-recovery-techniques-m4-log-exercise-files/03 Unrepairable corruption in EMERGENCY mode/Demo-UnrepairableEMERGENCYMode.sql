-- Demo script for Unrepairable EMERGENCY-Mode demo.

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
    FILENAME = N'D:\Pluralsight\Company_log.ldf');
GO

-- Create an employee table and some data
USE [Company];
GO

CREATE TABLE [Employees] (
	[FirstName]    VARCHAR (20),
	[LastName]     VARCHAR (20),
	[YearlyBonus]	INT);
GO

INSERT INTO [Employees] VALUES (
	'John', 'Doe', 5000);
INSERT INTO [Employees] VALUES (
	'Jane', 'Doe', 5000);
GO

-- Now we add in a corruption
ALTER DATABASE [Company] SET SINGLE_USER;
GO
DBCC WRITEPAGE (N'Company', 1, 1, 0, 8, 0x0000000000000000, 1);
GO
ALTER DATABASE [Company] SET MULTI_USER;
GO

-- Simulate an in-flight transaction
BEGIN TRAN;
GO

-- Accidentally remove Jane's bonus
UPDATE [Employees]
SET [YearlyBonus] = 0
WHERE [FirstName] = 'Jane'
AND [LastName] = 'Doe';
GO

--Now the database is in trouble

-- Uh-oh - what's the status?
SELECT DATABASEPROPERTYEX (N'Company', N'STATUS');
GO

-- What's the state of the data?
SELECT * FROM [Company].[dbo].[Employees];
GO

-- What's up with the database?
DBCC CHECKDB (N'Company') WITH NO_INFOMSGS;
GO

-- No backups...
-- Let's try EMERGENCY mode
ALTER DATABASE [Company] SET EMERGENCY;
GO

DBCC CHECKDB (N'Company') WITH NO_INFOMSGS;
GO

-- Try EMERGENCY-mode repair
ALTER DATABASE [Company] SET SINGLE_USER;
GO
DBCC CHECKDB (N'Company', REPAIR_ALLOW_DATA_LOSS) WITH NO_INFOMSGS;
GO

-- Check the state
SELECT DATABASEPROPERTYEX (N'Company', N'STATUS');
GO

-- What about the data?
SELECT * FROM [Employees];
GO

-- How's the database?
DBCC CHECKDB (N'Company') WITH NO_INFOMSGS;
GO

-- EMERGENCY-mode repair managed to bring the database online
-- but not actually repair it
