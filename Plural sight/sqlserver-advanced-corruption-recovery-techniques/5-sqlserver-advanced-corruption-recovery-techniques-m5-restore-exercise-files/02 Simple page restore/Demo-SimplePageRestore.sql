-- Demo script for Simple Page Restore demo.

-- Run Setup-SimplePageRestore.sql first

-- Innocent user query on the sales table
SELECT * FROM [Company].[dbo].[RandomData];
GO

-- Uh-oh - corruption!
-- Check the database using DBCC CHECKDB
DBCC CHECKDB (N'Company') WITH NO_INFOMSGS;
GO

-- What does the page look like? Try doing an
-- interpreted dump of the page using DBCC PAGE
DBCC TRACEON (3604); -- necessary for correct output
GO
DBCC PAGE (N'Company', 1, XX, 3);
GO

-- DBCC PAGE can't work out how to dump the page
-- because the header is zero'd. Try a hex dump.
DBCC PAGE (N'Company', 1, XX, 2);
GO

-- Wow - totally zero! Looks like an IO error.

-- First thing to do, disallow user access.
-- Remember not to set it to OFFLINE otherwise not
-- even sysadmin can access the database.
ALTER DATABASE [Company] SET RESTRICTED_USER;
GO

-- Before we decide to fix the database using single-page
-- restore, let's see if any other pages are corrupt
SELECT * FROM [msdb].[dbo].[suspect_pages];
GO

-- Now restore the single damaged page
USE [master];
GO

-- First with the full backup...
RESTORE DATABASE [Company]
PAGE = 'XX' FROM
DISK = N'D:\Pluralsight\Company_Full.bak';
GO

-- Now the first log backup...
RESTORE LOG [Company] FROM
DISK = N'D:\Pluralsight\Company_Log1.bak'
WITH NORECOVERY;
GO
-- And so on...

-- Backup and restore the tail of the log...
BACKUP LOG [Company] TO
DISK = N'D:\Pluralsight\Company_Log_Tail.bak'
WITH INIT;
GO

RESTORE LOG [Company] FROM
DISK = N'D:\Pluralsight\Company_Log_Tail.bak'
WITH NORECOVERY;
GO

-- And finish up with recovery
RESTORE DATABASE [Company] WITH RECOVERY;
GO

-- Check the database for corruption again
DBCC CHECKDB (N'Company') WITH NO_INFOMSGS;
GO

-- Bring the database online again
ALTER DATABASE [Company] SET MULTI_USER;
GO

-- Final sanity check - run the user query again
SELECT * FROM [Company].[dbo].[RandomData];
GO