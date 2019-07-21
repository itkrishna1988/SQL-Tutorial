-- Demo script for Using Older Backups demo.

-- Run Setup-OlderBackups.sql first

-- Now imagine we only have the full backup and the database
-- is in SIMPLE recovery mode. No single page restore is
-- possible.

-- Innocent user query on the sales table
SELECT
	SUM ([SalesAmount])
FROM
	[Company].[dbo].[Sales]
WHERE
	[SalesAmount] < $1.00;
GO

-- Uh-oh - corruption!
-- Check the database using DBCC CHECKDB
DBCC CHECKDB (N'Company') WITH NO_INFOMSGS;
GO

-- Hmm - only a full backup. What to do?
-- We're going to have to run repair to fix this.
-- Can we use the full backup to get the data back?

-- First thing - take a backup of the corrupt database
-- in case anything goes wrong.
BACKUP DATABASE [Company] TO
DISK = N'D:\Pluralsight\Company_BeforeRepair.bak'
WITH INIT;
GO

-- Now run repair
ALTER DATABASE [Company] SET SINGLE_USER;
GO

DBCC CHECKDB (N'Company', REPAIR_ALLOW_DATA_LOSS)
	WITH NO_INFOMSGS;
GO

ALTER DATABASE [Company] SET RESTRICTED_USER;
GO

-- Did we fix the problem?
DBCC CHECKDB (N'Company') WITH NO_INFOMSGS;
GO

-- How many rows did we lose?
SELECT COUNT (*) FROM [Company].[dbo].[Sales];
GO

-- Can we tell the range? We know the SalesID is monotonically
-- increasing...
-- Start of the missing range is when a value does not have a
-- plus-1 neighbor.
SELECT MIN([SalesID] + 1) FROM [Company].[dbo].[Sales] as [A]
WHERE NOT EXISTS (
	SELECT [SalesID] FROM [Company].[dbo].[Sales] as [B]
	WHERE [B].[SalesID] = [A].[SalesID] + 1);
GO
-- End of the missing range is when a value does not have a
-- minus-1 neighbor
SELECT MAX([salesID] - 1) FROM [Company].[dbo].[Sales] as [A]
WHERE NOT EXISTS (
	SELECT [salesID] FROM [Company].[dbo].[Sales] as [B]
	WHERE [B].[SalesID] = [A].[salesID] - 1)
GO

-- Let's restore the full backup to a different location
RESTORE FILELISTONLY FROM
	DISK = N'D:\Pluralsight\Company_Full.bak';
GO

RESTORE DATABASE [CompanyCopy] FROM
	DISK = N'D:\Pluralsight\Company_Full.bak'
	WITH MOVE N'Company'
		TO N'D:\Pluralsight\CompanyCopy.mdf', 
	MOVE N'Company_log'
		TO N'D:\Pluralsight\CompanyCopy_log.ldf', 
	REPLACE;
GO

-- And look in the corrupt page
DBCC TRACEON (3604);
GO
DBCC PAGE (N'CompanyCopy', 1, XX, 3);
GO

-- Cool! The page in the backup contains the
-- data range that is missing. Now we can copy it
-- back to the real database. Only problem is that we
-- don't know if anything changed on the rows - but at
-- least we get the data back.

-- Preserve identity values
SET IDENTITY_INSERT [Company].[dbo].[Sales] ON;
GO

-- Copy the rows over
SET NOCOUNT OFF;
GO

INSERT INTO [Company].[dbo].[Sales] (
	[SalesID], [CustomerID], [SalesDate], [SalesAmount])
SELECT * FROM [CompanyCopy].[dbo].[Sales] AS [copy]
WHERE [copy].[SalesID] > X AND [copy].[SalesID] < X;
GO

-- Restore identity behavior.
SET IDENTITY_INSERT [Company].[dbo].[Sales] OFF;
GO

-- Check the row count
SELECT COUNT (*) FROM [Company].[dbo].[Sales];
GO

-- Release the database
ALTER DATABASE [Company] SET MULTI_USER;
GO