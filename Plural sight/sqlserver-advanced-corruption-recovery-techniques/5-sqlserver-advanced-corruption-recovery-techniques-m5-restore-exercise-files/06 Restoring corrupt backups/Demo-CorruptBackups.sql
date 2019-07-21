-- Demo script for Corrupt Backups demo.

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

CREATE TABLE [RandomData] (
	[c1]  INT IDENTITY,
	[c2]  CHAR (8000) DEFAULT 'a');
GO

INSERT INTO [RandomData] DEFAULT VALUES;
GO 100

-- Create backups
BACKUP DATABASE [Company] TO
DISK = N'D:\Pluralsight\Company_Full.bak'
WITH INIT;
GO

BACKUP LOG [Company] TO
DISK = N'D:\Pluralsight\Company_Log1.bak'
WITH INIT;
GO

-- Now add a known piece of data
INSERT INTO [RandomData] ([c2]) VALUES ('Important data!!!');
GO

INSERT INTO [RandomData] DEFAULT VALUES;
GO 100

-- Now perform a minimally-logged operation
CREATE CLUSTERED INDEX [Random_CL] ON [RandomData] ([c1]);
GO

ALTER DATABASE [Company] SET RECOVERY BULK_LOGGED;
GO

ALTER INDEX [Random_CL] ON [RandomData] REBUILD;
GO

-- And simulate a problem
ALTER DATABASE [Company] SET OFFLINE;

-- Delete the data file

-- Bring the database back online
ALTER DATABASE [Company] SET ONLINE;

-- We need to restore, but first we take a tail-of-the-log
-- backup using NO_TRUNCATE
BACKUP LOG [Company] TO
DISK = N'D:\Pluralsight\Company_Log_Tail.bak'
WITH INIT, NO_TRUNCATE;
GO

-- And now restore
RESTORE DATABASE [Company] FROM 
DISK = N'D:\Pluralsight\Company_Full.bak'
WITH NORECOVERY;
GO

-- Now the first log backup...
RESTORE LOG [Company] FROM
DISK = N'D:\Pluralsight\Company_Log1.bak'
WITH NORECOVERY;
GO
-- And so on...

-- Restore the tail of the log...
RESTORE LOG [Company] FROM
DISK = N'D:\Pluralsight\Company_Log_Tail.bak'
WITH NORECOVERY;
GO

-- Hmmm, force it to restore
RESTORE LOG [Company] FROM
DISK = N'D:\Pluralsight\Company_Log_Tail.bak'
WITH NORECOVERY, CONTINUE_AFTER_ERROR;
GO

-- And complete the restore sequence
RESTORE DATABASE [Company] WITH RECOVERY;
GO

RESTORE DATABASE [Company] WITH RECOVERY, CONTINUE_AFTER_ERROR;
GO

-- Check the database for corruption
DBCC CHECKDB (N'Company') WITH NO_INFOMSGS;
GO

-- Go back and skip restoring the log tail
RESTORE DATABASE [Company] FROM
DISK = N'D:\Pluralsight\Company_Full.bak'
WITH NORECOVERY, REPLACE;
GO

-- Now the first log backup...
RESTORE LOG [Company] FROM
DISK = N'D:\Pluralsight\Company_Log1.bak'
WITH NORECOVERY;
GO
-- And so on...

RESTORE DATABASE [Company] WITH RECOVERY;
GO

-- Check the database for corruption
DBCC CHECKDB (N'Company') WITH NO_INFOMSGS;
GO

-- What about the data?
SELECT * FROM [Company].[dbo].[RandomData];
GO
