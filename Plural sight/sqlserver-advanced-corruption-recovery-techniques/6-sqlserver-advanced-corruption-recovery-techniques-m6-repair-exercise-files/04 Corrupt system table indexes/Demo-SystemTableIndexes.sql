-- Demo script for System Table Indexes demo.

-- Run Setup-SystemTableIndexes.sql first

USE [master];
GO

-- ** Company1 **
-- What's wrong with this database?
DBCC CHECKDB (N'Company1') WITH NO_INFOMSGS;
GO

-- Try to do a repair
ALTER DATABASE [Company1] SET SINGLE_USER;
GO

DBCC CHECKDB (N'Company1', REPAIR_ALLOW_DATA_LOSS)
WITH NO_INFOMSGS;
GO

ALTER DATABASE [Company1] SET MULTI_USER;
GO

-- Check again
DBCC CHECKDB (N'Company1') WITH NO_INFOMSGS;
GO

-- ** Company2 **
-- What's wrong with this database?
DBCC CHECKDB (N'Company2') WITH NO_INFOMSGS;
GO

-- Try to do a repair
ALTER DATABASE [Company2] SET SINGLE_USER;
GO

DBCC CHECKDB (N'Company2', REPAIR_ALLOW_DATA_LOSS)
WITH NO_INFOMSGS;
GO

ALTER DATABASE [Company2] SET MULTI_USER;
GO

-- Check again
DBCC CHECKDB (N'Company2') WITH NO_INFOMSGS;
GO