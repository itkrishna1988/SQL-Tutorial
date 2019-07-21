-- Setup script for System Table Indexes demo.

-- Drop old databases
USE [master];
GO

IF DATABASEPROPERTYEX (N'Company1', N'Version') > 0
BEGIN
	ALTER DATABASE [Company1] SET SINGLE_USER
		WITH ROLLBACK IMMEDIATE;
	DROP DATABASE [Company1];
END
IF DATABASEPROPERTYEX (N'Company2', N'Version') > 0
BEGIN
	ALTER DATABASE [Company2] SET SINGLE_USER
		WITH ROLLBACK IMMEDIATE;
	DROP DATABASE [Company2];
END

-- Create databases
CREATE DATABASE [Company1] ON PRIMARY (
    NAME = N'Company1',
    FILENAME = N'D:\Pluralsight\Company1.mdf')
LOG ON (
    NAME = N'Company1_log',
    FILENAME = N'D:\Pluralsight\Company1_log.ldf',
    SIZE = 5MB,
    FILEGROWTH = 1MB);

CREATE DATABASE [Company2] ON PRIMARY (
    NAME = N'Company2',
    FILENAME = N'D:\Pluralsight\Company2.mdf')
LOG ON (
    NAME = N'Company2_log',
    FILENAME = N'D:\Pluralsight\Company2_log.ldf',
    SIZE = 5MB,
    FILEGROWTH = 1MB);
GO

-- Install the sp_allocationMetadata script
-- from http://bit.ly/12wHHzQ

-- Corrupt first database
USE [Company1];
GO

EXEC [sp_AllocationMetadata] N'sys.sysschobjs';
GO

-- Pick the Root Page of index ID 1
DBCC WRITEPAGE (N'Company1', 1, xx, 96, 4, 0x00000000);
GO

-- Corrupt second database
USE [Company2];
GO

EXEC [sp_AllocationMetadata] N'sys.sysidxstats';
GO

-- Pick the Root Page of index ID 1
DBCC WRITEPAGE (N'Company2', 1, xx, 96, 4, 0x00000000);
GO

USE [master];
GO
