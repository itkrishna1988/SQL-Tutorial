-- Demo script for Failed Page Restore demo.

-- Run Setup-FailedPageRestore.sql first

-- Check the database using DBCC CHECKDB
DBCC CHECKDB (N'Company') WITH NO_INFOMSGS;
GO

DBCC CHECKALLOC (N'Company') WITH NO_INFOMSGS;
GO

-- What does the page look like? Try doing an
-- interpreted dump of the page using DBCC PAGE
DBCC TRACEON (3604); -- necessary for correct output
GO
DBCC PAGE (N'Company', 1, 1, 3);
GO

-- DBCC PAGE can't work out how to dump the page
-- because the header is zero'd. Try a hex dump.
DBCC PAGE (N'Company', 1, 1, 2);
GO

-- Single page restore
RESTORE DATABASE [Company]
PAGE = '1:1' FROM
DISK = N'D:\Pluralsight\Company_Full.bak';
GO

-- Make sure to drop the corrupt database to avoid
-- lots of crash dumps
USE [master];
GO

ALTER DATABASE [Company] SET SINGLE_USER
		WITH ROLLBACK IMMEDIATE;
DROP DATABASE [Company];
GO