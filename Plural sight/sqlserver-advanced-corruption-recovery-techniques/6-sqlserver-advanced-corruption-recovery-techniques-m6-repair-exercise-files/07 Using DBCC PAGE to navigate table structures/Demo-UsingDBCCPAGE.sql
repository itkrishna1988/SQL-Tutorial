-- Demo script for Using DBCC PAGE demo.

-- Run Setup-UsingDBCCPAGE.sql first

-- Now imagine we don't have any backups

-- Innocent user query on the sales table
SELECT
	[SalesAmount], [CustomerID]
FROM
	[Company].[dbo].[Sales]
WHERE
	[SalesAmount] > $1.00;
GO

-- Uh-oh - corruption!
-- Check the database using DBCC CHECKDB
DBCC CHECKDB (N'Company') WITH NO_INFOMSGS;
GO

-- First thing - take a backup of the corrupt database
-- in case anything goes wrong.
BACKUP DATABASE [Company] TO
DISK = N'D:\Pluralsight\Company_BeforeRepair.bak'
WITH INIT;
GO

-- Hmm - no backups this time. What can we get from
-- nonclustered indexes?
USE [Company];
GO

-- Can we tell the range? We know the SalesID is monatonically
-- increasing...
SELECT * FROM [Sales];
GO

-- Start of missing range:
-- Bad page ID: 

-- And going backwards?
SELECT * FROM [Sales] ORDER BY SalesID DESC;
GO

-- End of missing range:
-- Bad page ID:

-- What pages are there?
DBCC IND (N'Company', N'Sales', 1);
GO

-- Pick the page with the highest level and
-- work down to the leaf
DBCC TRACEON (3604);
GO
DBCC PAGE (N'Company', 1, XX, 3);
GO

-- Find the page that's after the corrupt one
DBCC PAGE (N'Company', 1, XX, 3);
GO

-- Now we know SalesIDs < XX are missing
-- What about the rest?
SELECT * FROM [Sales] WHERE [SalesID] > XX;
GO

-- Explain about the uniquifier, looking at DBCC IND again
-- So we know XX is ok
SELECT * FROM [Sales] WHERE [SalesID] > XX;
GO

-- Our missing ranges are XX-YY, and ZZ onward

-- Now we proceed as in the previous demo

-- What if there were multiple broken pages at the leaf
-- level? We get the next page by using DBCC IND and then
-- the key value to use in the search using DBCC PAGE on
-- the following page.
