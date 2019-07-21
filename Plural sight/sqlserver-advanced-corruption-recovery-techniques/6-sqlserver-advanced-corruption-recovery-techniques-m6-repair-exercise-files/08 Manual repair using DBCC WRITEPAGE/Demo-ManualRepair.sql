-- Demo script for Manual Repair demo.

-- Run Setup-ManualRepair.sql first

-- Now imagine we don't have any backups

-- Check the database using DBCC CHECKDB
DBCC CHECKDB (N'Company') WITH NO_INFOMSGS;
GO

-- First thing - take a backup of the corrupt database
-- in case anything goes wrong.
BACKUP DATABASE [Company] TO
DISK = N'D:\Pluralsight\Company_BeforeRepair.bak'
WITH INIT;
GO

-- Hmm - no backups this time and no non-clustered indexes

-- We want to preserve the LOB data as repair will delete it
-- Create a dummy row with off-row LOB and then substitute
-- the pointer and text linkage to point to the one linked by
-- the corrupt record
USE [Company];
GO

-- Get the relevant values
DBCC CHECKDB (N'Company') WITH NO_INFOMSGS;
GO

-- LOB page: xxx
-- Slot: yy
-- Text timestamp: zzzz

-- Look at the text page, how long is the value?
-- Subtract 14 bytes for the versioning pointer
-- which is always added to a LOB value
DBCC TRACEON (3604);
DBCC PAGE (N'Company', 1, xx, 3);
GO

-- Length: xx

-- Create a dummy record, making sure to get the value
-- of the ID value used. Can't simply use MAX() as the 
-- identity might have been reseeded lower. This is
-- the simplest way.
DECLARE @MyTableVar TABLE (ID INT);

INSERT INTO [RandomData] ([c3], [c4])
	OUTPUT INSERTED.[c1] INTO @MyTableVar
VALUES ('Pauls Dummy row', 'Some very very very very very long dummy dummy dummy dummy text');

SELECT * FROM @MyTableVar; 
GO

-- Which page is the dummy row on?
SELECT
	sys.fn_PhysLocFormatter (%%PHYSLOC%%) AS [Physical RID]
FROM
	[RandomData]
WHERE
	[c1] = XX;
GO

-- Look at that page
DBCC TRACEON (3604);
DBCC PAGE (N'Company', 1, xx, 3);
GO

-- Figure out the offset of the LOB slot number
-- and swap it using DBCC WRITEPAGE
DBCC WRITEPAGE ([Company], 1, xx, yyyy, 1, 0xzz);
GO

-- Figure out offset of length of the LOB and fix that up
DBCC WRITEPAGE ([Company], 1, xx, yyyy, 1, 0xzz);
GO

-- What did that do?
DBCC CHECKDB (N'Company') WITH NO_INFOMSGS;
GO

-- Need to swap the timestamp too
DBCC PAGE (N'Company', 1, xx, 3);
GO

-- Where does it start and how is it stored?
-- Offset: 

-- Grab offset from above and convert to hex, and figure out
-- where to put it. Just the two bytes have to be changed,
-- but they're byte-reversed
DBCC WRITEPAGE (N'Company', 1, xx, yyyy, 2, 0xzzzz);
GO

-- What did that do?
DBCC CHECKDB (N'Company') WITH NO_INFOMSGS;
GO

-- Now the matching error has gone!
-- Can we select the value?
SELECT * FROM [RandomData] WHERE [c1] = XX;
GO

-- And then we can run repair, delete the
-- dummy row, etc etc

-- This was very contrived. Even for this example, it could be
-- a lot more complex: LOB value spans multiple pages, multiple
-- damaged rows, multiple data rows per data page, ghost records
-- on the data page.

-- Now imagine it's a very large XML blob - this little hack is
-- way simpler than having to manually transcribe all the values
-- and stitch them together.

-- And another example is fixing SQL Server 2000 sysindexes stats
-- blob linkages which is impossible any other way.

-- Hopefully you get the idea of how cool this can be to do!