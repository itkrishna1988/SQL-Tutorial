-- Demo script for EMERGENCY-Mode Repair demo.

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

-- Simulate an in-flight transaction
BEGIN TRAN;
GO

-- Accidentally remove Jane's bonus
UPDATE [Employees]
SET [YearlyBonus] = 0
WHERE [FirstName] = 'Jane'
AND [LastName] = 'Doe';
GO

-- Force the updated page to disk
CHECKPOINT;
GO

-- Simulate hardware failure with corruption
-- SHUTDOWN WITH NOWAIT in another window and
-- use a hex editor to corrupt the log file header.

-- Restart SQL Server

-- After shutdown/corruption/startup

USE [Company];
GO

-- Uh-oh - what's the status?
SELECT DATABASEPROPERTYEX (N'Company', N'STATUS');
GO

-- No backups...
-- Let's try EMERGENCY mode repair
ALTER DATABASE [Company] SET EMERGENCY;
GO

-- What's the state of the data?
SELECT * FROM [Company].[dbo].[Employees];
GO

DBCC CHECKDB (N'Company', REPAIR_ALLOW_DATA_LOSS) WITH NO_INFOMSGS;
GO

-- Set single user mode as well
ALTER DATABASE [Company] SET SINGLE_USER;
GO
DBCC CHECKDB (N'Company', REPAIR_ALLOW_DATA_LOSS) WITH NO_INFOMSGS;
GO

-- Now try again...
USE [Company];
GO

-- Check the state
SELECT DATABASEPROPERTYEX (N'Company', N'STATUS');
GO

-- What about the data?
SELECT * FROM [Employees];
GO
