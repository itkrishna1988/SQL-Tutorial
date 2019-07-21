-- Demo script for DBCC WRITEPAGE Examples demo.

-- Demo databases can be downloaded from
-- http://bit.ly/10fKpbS (that's a zero).

-- Download the 2008 SalesDB Sample Database from the link above
-- and unzip into D:\Pluralsight.

-- Restore as follows:
USE [master];
GO

IF DATABASEPROPERTYEX (N'SalesDB', N'Version') > 0
BEGIN
	ALTER DATABASE [SalesDB] SET SINGLE_USER
		WITH ROLLBACK IMMEDIATE;
	DROP DATABASE [SalesDB];
END
GO

RESTORE DATABASE [SalesDB]
FROM DISK = N'D:\Pluralsight\SalesDBOriginal.bak'
WITH
    MOVE N'SalesDBData' TO N'D:\Pluralsight\SalesDB.mdf',
	MOVE N'SalesDBLog' TO N'D:\Pluralsight\SalesDB.ldf';
GO

-- Change the column type and rebuild the index
USE [SalesDB];
GO

ALTER TABLE [products] ALTER COLUMN [price] FLOAT;
GO
ALTER INDEX [productsPK] ON [products] REBUILD;
GO

-- What pages are there?
DBCC IND (N'SalesDB', N'Products', -1);
GO

-- How I did the data purity error from Module 8
-- of the basic course

-- Pick the page two up from the bottom
-- Check slot 23 is product ID 306
DBCC TRACEON (3604)
DBCC PAGE (N'SalesDB', 1, xx, 3);
GO

-- Look for the float offset: 8

-- Take the slot 23 offset and add 8, convert to an int
SELECT CONVERT (INT, 0x613 + 8);
GO

-- Corrupt slot 23's float value record
ALTER DATABASE [SalesDB] SET SINGLE_USER;
GO
DBCC WRITEPAGE (N'SalesDB', 1, xx, zz, 8, 0xFFFFFFFFFFFFFFFF);
GO
ALTER DATABASE [SalesDB] SET MULTI_USER;
GO

DBCC CHECKDB (N'SalesDB') WITH NO_INFOMSGS;
GO

-- Now let's mess with a page ID in the page header
-- What pages are there?
DBCC IND (N'SalesDB', N'Products', -1);
GO

-- Pick a page to corrupt
DBCC PAGE (N'SalesDB', 1, xx, 0);
GO

-- Pick a page and figure out its hex page ID using calc
-- Where's the page ID in the header?

-- Corrupt the page ID
DBCC WRITEPAGE (N'SalesDB', 1, xx, offset, 2, 0xzzzz);
GO

-- Did we corrupt it?
DBCC CHECKDB (N'SalesDB') WITH NO_INFOMSGS;
GO

-- What about something nasty?
DBCC WRITEPAGE (N'tempdb', 1, 9, 0, 4, 0x00000000);
DBCC WRITEPAGE (N'tempdb', 1, 1, 0, 4, 0x00000000);
GO

-- We have to execute this twice
DBCC WRITEPAGE (N'tempdb', 1, 9, 0, 4, 0x00000000);
DBCC WRITEPAGE (N'tempdb', 1, 1, 0, 4, 0x00000000);
GO

DBCC DROPCLEANBUFFERS;
GO

-- DROP TABLE [tempdb].[dbo].[test]
CREATE TABLE [tempdb].[dbo].[test] ([c1] INT);
INSERT INTO [tempdb].[dbo].[test] VALUES (1);
GO

CREATE TABLE [tempdb].[dbo].[test] ([c1] INT);
INSERT INTO [tempdb].[dbo].[test] VALUES (1);
GO

-- Restart and look in the error log