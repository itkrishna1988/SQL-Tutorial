-- Demo script for Hack Attach Tail Log demo

-- Start and connect to the second instance

-- Imagine the first instance is completely gone

USE [master];
GO

IF DATABASEPROPERTYEX (N'Company', N'Version') > 0
BEGIN
	ALTER DATABASE [Company] SET SINGLE_USER
		WITH ROLLBACK IMMEDIATE;
	DROP DATABASE [Company];
END
GO

-- Restore the full backup
RESTORE DATABASE [Company]
FROM DISK = N'D:\Pluralsight\Company_Full_HAD.bak'
WITH REPLACE, NORECOVERY;
GO

-- Pretend we have a lot of other backups...

-- Restore the most recent log backup
RESTORE LOG [Company]
FROM DISK = N'D:\Pluralsight\Company_Log1_HAD.bak'
WITH NORECOVERY;
GO

-- Bring it online
RESTORE DATABASE [Company] WITH RECOVERY;
GO

-- Check the data
SELECT * FROM [Company].[dbo].[RandomData];
GO

-- What about getting the data from the log file?

-- Get rid of the newly restored database
DROP DATABASE [Company];
GO

-- Create a dummy database
CREATE DATABASE [Company] ON PRIMARY (
    NAME = N'Company',
    FILENAME = N'D:\Pluralsight\Company.mdf')
LOG ON (
    NAME = N'Company_log',
    FILENAME = N'D:\Pluralsight\Company_log.ldf',
    SIZE = 5MB,
    FILEGROWTH = 1MB);
GO

-- Shut the database down
ALTER DATABASE [Company] SET OFFLINE;
GO

-- Delete the data file and swap in the old log file

-- Restart the database
ALTER DATABASE [Company] SET ONLINE;
GO

-- Take a log backup?
BACKUP LOG [Company] TO
DISK = N'D:\Pluralsight\Company_Log_Tail.bak'
WITH INIT;
GO

-- Use the special syntax!
BACKUP LOG [Company] TO
DISK = N'D:\Pluralsight\Company_Log_Tail.bak'
WITH INIT, NO_TRUNCATE;
GO

-- Now we can restore everything
-- First the full backup...
RESTORE DATABASE [Company]
FROM DISK = N'D:\Pluralsight\Company_Full_HAD.bak'
WITH REPLACE, NORECOVERY;
GO

-- And all other backups...
RESTORE LOG [Company]
FROM DISK = N'D:\Pluralsight\Company_Log1_HAD.bak'
WITH NORECOVERY;
GO

-- And restore the tail of the log backup
-- we just took
RESTORE LOG [Company]
FROM DISK = N'D:\Pluralsight\Company_Log_Tail.bak'
WITH NORECOVERY;
GO

-- And finalize recovery
RESTORE DATABASE [Company] WITH RECOVERY;
GO

-- Check the data
SELECT * FROM [Company].[dbo].[RandomData];
GO