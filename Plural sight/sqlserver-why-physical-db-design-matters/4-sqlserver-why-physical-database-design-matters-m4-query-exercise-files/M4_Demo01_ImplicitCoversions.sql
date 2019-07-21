-- Setup & demo script for Implicit Coversions demo.

-- Demo databases can be downloaded from
-- http://bit.ly/10fKpbS (that's a zero).

-- Download the 2008 Credit sample database from the link 
-- above and unzip into D:\Pluralsight.

-- Restore as follows:
USE [master];
GO

IF DATABASEPROPERTYEX (N'Credit', N'Version') > 0
BEGIN
	ALTER DATABASE [Credit] 
		SET SINGLE_USER
		WITH ROLLBACK IMMEDIATE;
	DROP DATABASE [Credit];
END
GO

RESTORE DATABASE [Credit]
FROM DISK = N'D:\Pluralsight\CreditBackup100.bak'
WITH
    MOVE N'CreditData'
		TO N'D:\Pluralsight\CreditData.mdf',
	MOVE N'CreditLog' 
		TO N'D:\Pluralsight\CreditLog.ldf';
GO

USE [Credit];
GO

-- This example will use LastNames to look up rows
-- An index can be helpful, especially when the data
-- is highly selective
CREATE INDEX [LastNameInd] 
ON [dbo].[member] ([lastname]);
GO

-- To ensure a highly selective value, let's set
-- one row to Tripp
UPDATE [dbo].[member]
    SET [lastname] = 'Tripp'
    WHERE [member_no] = 1234;
GO

-- To see the I/Os performed
SET STATISTICS IO ON;
GO

-- Turn on showplan (Query, Include Actual Execution Plan)

-- Execute these two statements TWICE 
-- (the plan won't be in cache if Opt for Adhoc Workloads is on)
SELECT [m].* 
FROM [dbo].[member] AS [m]
WHERE m.[lastname] = 'Tripp';
GO

SELECT [m].* 
FROM [dbo].[member] AS [m]
WHERE m.[lastname] = N'Tripp';
GO

-- Showplan percentages are different
--		SCAN vs. SEEK

-- Plan affects the I/Os and query cost