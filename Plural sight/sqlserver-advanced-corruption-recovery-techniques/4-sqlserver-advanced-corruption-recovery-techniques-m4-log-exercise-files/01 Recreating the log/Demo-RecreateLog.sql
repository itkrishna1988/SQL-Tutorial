-- Demo script for Recreating the Log demo.

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

-- Look at the VLFs
DBCC LOGINFO (N'Company');
GO

-- Detach the database
EXEC sp_detach_db @dbname = N'Company';
GO

-- Delete the log file

-- Attach the database again
CREATE DATABASE [Company] ON (
    FILENAME = N'D:\Pluralsight\Company.mdf')
FOR ATTACH;
GO

-- Look at the VLFs
DBCC LOGINFO (N'Company');
GO

-- Now with two transaction log files
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
    FILEGROWTH = 1MB), (
    NAME = N'Company_log2',
    FILENAME = N'D:\Pluralsight\Company_log2.ldf',
    SIZE = 5MB,
    FILEGROWTH = 1MB)
GO

-- Look at the VLFs
DBCC LOGINFO (N'Company');
GO

-- Detach the database
EXEC sp_detach_db @dbname = N'Company';
GO

-- Delete the log file

-- Attach the database again
CREATE DATABASE [Company] ON (
    FILENAME = N'D:\Pluralsight\Company.mdf')
FOR ATTACH;
GO

-- Try the other syntax
CREATE DATABASE [Company] ON (
    FILENAME = N'D:\Pluralsight\Company.mdf')
FOR ATTACH_REBUILD_LOG;
GO

-- Look at the VLFs
DBCC LOGINFO (N'Company');
GO
