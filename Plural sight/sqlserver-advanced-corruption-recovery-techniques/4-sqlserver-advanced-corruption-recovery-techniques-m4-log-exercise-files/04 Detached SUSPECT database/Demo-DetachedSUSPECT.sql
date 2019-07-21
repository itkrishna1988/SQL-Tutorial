-- Demo script for Detached SUSPECT Database demo.

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
    @filename2 = N'D:\Pluralsight\Company_log.ldf';
GO

-- Ok - try using the ATTACH_REBUILD_LOG command
CREATE DATABASE [Company] ON
    (NAME = N'Company',
	FILENAME = N'D:\Pluralsight\Company.mdf')
FOR ATTACH_REBUILD_LOG;
GO

-- Ok - try removing the log file and then
-- using the ATTACH_REBUILD_LOG command
CREATE DATABASE [Company] ON
    (NAME = N'Company',
	FILENAME = N'D:\Pluralsight\Company.mdf')
FOR ATTACH_REBUILD_LOG;
GO

-- Ok - we're going to have to hack it back into the server

-- Create a dummy database, shutdown the database and swap in
-- the corrupt files, restart and it should be there

CREATE DATABASE [Company] ON PRIMARY (
    NAME = N'Company',
    FILENAME = N'D:\Pluralsight\Company.mdf')
LOG ON (
    NAME = N'Company_log',
    FILENAME = N'D:\Pluralsight\Company_log.ldf');
GO

-- Check the files are there...

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
