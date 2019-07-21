-- Demo script for Detached SUSPECT Database 
-- with Different File IDs demo.

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
    FILENAME = N'D:\Pluralsight\Company.mdf'),
    (NAME = N'Company2',
    FILENAME = N'D:\Pluralsight\Company2.ndf'),
    (NAME = N'Company3',
    FILENAME = N'D:\Pluralsight\Company3.ndf')
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

-- Remove file ID 3
ALTER DATABASE [Company] REMOVE FILE [Company2];
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

-- Simulate the database being detached
ALTER DATABASE [Company] SET OFFLINE;
GO

-- ***** COPY THE FILES *****

-- Copy... then:
DROP DATABASE [Company];
GO

-- Try attaching it again
EXEC sp_attach_db @dbname = N'Company', 
    @filename1 = N'D:\Pluralsight\Company.mdf',
	@filename2 = N'D:\Pluralsight\Company3.ndf',
    @filename3 = N'D:\Pluralsight\Company_log.ldf';
GO

-- We know we're going to have to hack it back into the server

-- Delete the files from the dropped database

-- Create the dummy database
CREATE DATABASE [Company] ON PRIMARY (
    NAME = N'Company',
    FILENAME = N'D:\Pluralsight\Company.mdf'),
    (NAME = N'Company3',
    FILENAME = N'D:\Pluralsight\Company3.ndf')
LOG ON (
    NAME = N'Company_log',
    FILENAME = N'D:\Pluralsight\Company_log.ldf');
GO

-- Set the dummy database offline
ALTER DATABASE [Company] SET OFFLINE;
GO

-- ***** Copy in the corrupt files

-- Now try using the database
ALTER DATABASE [Company] SET ONLINE;
GO

-- We have to use the correct file IDs

ALTER DATABASE [Company] SET OFFLINE;
GO

-- Copy the real files again

DROP DATABASE [Company];
GO

-- Create the dummy database with the correct file IDs
CREATE DATABASE [Company] ON PRIMARY (
    NAME = N'Company',
    FILENAME = N'D:\Pluralsight\Company.mdf'),
    (NAME = N'Company2',
    FILENAME = N'D:\Pluralsight\Company2.ndf'),
    (NAME = N'Company3',
    FILENAME = N'D:\Pluralsight\Company3.ndf')
LOG ON (
    NAME = N'Company_log',
    FILENAME = N'D:\Pluralsight\Company_log.ldf');
GO
ALTER DATABASE [Company] REMOVE FILE [Company2];
GO

-- Set the dummy database offline
ALTER DATABASE [Company] SET OFFLINE;
GO

-- ***** Copy in the corrupt files

-- Now try using the database
ALTER DATABASE [Company] SET ONLINE;
GO


SELECT DATABASEPROPERTYEX (N'Company', N'STATUS');
GO

-- And now we can proceed with EMERGENCY-mode repair
ALTER DATABASE [Company] SET EMERGENCY;
GO
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
