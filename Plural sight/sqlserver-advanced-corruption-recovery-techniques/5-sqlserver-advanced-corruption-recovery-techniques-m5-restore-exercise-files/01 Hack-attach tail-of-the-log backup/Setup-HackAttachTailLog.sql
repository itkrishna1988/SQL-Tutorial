-- Setup script for Hack Attach Tail Log demo.

-- Run this on instance #1

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

-- Create a table
CREATE TABLE [RandomData] (
	[C1] INT IDENTITY,
	[C2] CHAR (100));
GO

-- And take a full backup
BACKUP DATABASE [Company]
TO DISK = N'D:\Pluralsight\Company_Full_HAD.bak'
WITH INIT;
GO

-- Now add some data and take a log backup
INSERT INTO [RandomData] VALUES
	('Transaction 1');
INSERT INTO [RandomData] VALUES
	('Transaction 2');
GO

BACKUP LOG [Company]
TO DISK = N'D:\Pluralsight\Company_Log1_HAD.bak'
WITH INIT;
GO

-- Now add some data
INSERT INTO [RandomData] VALUES
	('Transaction 3');
INSERT INTO [RandomData] VALUES
	('Transaction 4');
GO

-- Take the database offline
ALTER DATABASE [Company] SET OFFLINE;
GO

-- Create a copy of the log file then delete both files

-- Now delete the database completely
DROP DATABASE [Company];
GO
