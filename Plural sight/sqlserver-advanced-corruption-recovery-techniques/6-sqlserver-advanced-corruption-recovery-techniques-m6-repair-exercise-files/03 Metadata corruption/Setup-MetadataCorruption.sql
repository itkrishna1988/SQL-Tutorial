-- Setup script for Metadata Corruption demo.

-- Boot the server in single-user mode with -m
-- Connect using the DAC

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

-- Create a table with a primary key
USE [Company];
GO

CREATE TABLE [RandomData] (
	[c1]  INT IDENTITY,
	[c2]  CHAR (8000) DEFAULT 'a');
GO

ALTER TABLE [RandomData] ADD PRIMARY KEY ([c1]);
GO

INSERT INTO [RandomData] DEFAULT VALUES;
GO 10

-- Now cause corruption in the system tables
DELETE FROM [sys].[sysschobjs]
WHERE [id] = OBJECT_ID (N'RandomData');
GO

-- After setup, restart the server normally
