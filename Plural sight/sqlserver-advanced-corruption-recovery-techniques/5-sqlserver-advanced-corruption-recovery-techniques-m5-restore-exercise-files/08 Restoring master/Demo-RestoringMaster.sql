-- Demo script for Restoring Master demo.

-- Ensure the Company database does not exist
USE [master];
GO

IF DATABASEPROPERTYEX (N'Company', N'Version') > 0
BEGIN
	ALTER DATABASE [Company] SET SINGLE_USER
		WITH ROLLBACK IMMEDIATE;
	DROP DATABASE [Company];
END
GO

-- Create a backup of the master database
BACKUP DATABASE [master]
TO DISK = N'D:\Pluralsight\Master.bck'
WITH INIT;

-- Create another database
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

CREATE TABLE [RandomData] (
	[c1]  INT IDENTITY,
	[c2]  CHAR (8000) DEFAULT 'a');
GO

INSERT INTO [RandomData] DEFAULT VALUES;
GO 100

-- Now imagine that master is corrupt in some way

-- Save as much system information as possible
-- For example:
SELECT * FROM sys.configurations;
GO

-- Now in configuration manager restart the server
-- with the -m flag

-- Restore master using the following
-- If you cannot connect, make sure SSMS is not
-- connected through Object Explorer
RESTORE DATABASE [master]
FROM DISK = N'D:\Pluralsight\Master.bck'
WITH REPLACE;
GO

-- When the server shuts down, remove -m and restart

-- Try to access Company database
USE [Company];
GO

-- We need to re-attach or restore it
CREATE DATABASE [Company] ON
    (NAME = N'Company',
	FILENAME = N'D:\Pluralsight\Company.mdf'),
	(NAME = N'Company_log',
	FILENAME = N'D:\Pluralsight\Company_log.ldf')
FOR ATTACH;
GO

