-- Demo script for Reconstructing demo.

-- Run Setup-Reconstructing.sql first

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

-- Can we tell the range? We know the SalesID is monotonically
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

-- If the bad page IDs are equal, only one missing range

-- What indexes are there?
sp_helpindex [Sales];

-- Doesn't tell us INCLUDEd columns
-- Script out the indexes...

-- Use the nonclustered indexes to get the corrupt data
SELECT
	[SalesID], [CustomerID]
FROM
	[Sales]
WITH (INDEX(2))
WHERE
	[SalesID] > XX AND [SalesID] < XX
ORDER BY [SalesID]
GO

SELECT
	[SalesID], [SalesAmount], [SalesDate]
FROM
	[Sales]
WITH (INDEX(3))
WHERE
	[SalesID] > XX AND [SalesID] < XX
ORDER BY [SalesID]
GO

-- Preserve the data
-- Create a dummy table
CREATE TABLE [Sales_Copy] (
	[SalesID] INT,
	[CustomerID] INT,
	[SalesDate] DATETIME,
	[SalesAmount] MONEY);
GO

-- Pull in the first two columns
INSERT INTO [Sales_Copy] (
	[SalesID], [CustomerID], [SalesDate], [SalesAmount])
SELECT
	[SalesID], [CustomerID], NULL, NULL
FROM
	[Sales]
WITH (INDEX(2))
WHERE
	[SalesID] > XX AND [SalesID] < XX
ORDER BY [SalesID];
GO

-- And the last two
UPDATE
	[Sales_Copy]
SET
	[SalesDate] = [a].[SalesDate],
	[SalesAmount] = [a].[SalesAmount]
FROM
	[Sales_Copy]
INNER JOIN
	(SELECT
		[SalesID], [SalesAmount], [SalesDate]
	FROM
		[Sales]
	WITH (INDEX(3))
	WHERE
		[SalesID] > XX AND [SalesID] < XX) [a]
ON [Sales_Copy].[SalesID] = [a].SalesID;

-- Now run repair
ALTER DATABASE [Company] SET SINGLE_USER
WITH ROLLBACK IMMEDIATE;
GO

DBCC CHECKDB (N'Company', REPAIR_ALLOW_DATA_LOSS)
	WITH NO_INFOMSGS;
GO

ALTER DATABASE [Company] SET RESTRICTED_USER;
GO

-- Did we fix the problem?
DBCC CHECKDB (N'Company') WITH NO_INFOMSGS;
GO

-- How many rows were lost?
SELECT COUNT (*) FROM [Sales];
GO

-- Preserve identity values
SET IDENTITY_INSERT [Sales] ON;
GO

-- Copy the rows over
SET NOCOUNT OFF;
GO

INSERT INTO [Sales] (
	[SalesID], [CustomerID], [SalesDate], [SalesAmount])
SELECT * FROM [Sales_Copy];
GO

-- Restore identity behavior.
SET IDENTITY_INSERT [Sales] OFF;
GO

-- Check the row count
SELECT COUNT (*) FROM [Company].[dbo].[Sales];
GO

-- Release the database
ALTER DATABASE [Company] SET MULTI_USER;
GO