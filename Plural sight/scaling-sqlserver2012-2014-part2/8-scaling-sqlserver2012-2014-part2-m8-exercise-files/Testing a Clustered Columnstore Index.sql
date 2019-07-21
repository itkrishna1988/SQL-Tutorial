-- Testing a Clustered Columnstore Index
-- Glenn Berry
-- SQLskills

USE AdventureWorks2014;
GO

-- Three new tables have been added to the AdventureWorks2014 database
-- dbo.bigTransactionHistory				- Uses Row store with no data compression
-- dbo.bigTransactionHistoryPageCompressed  - Uses Row store PAGE data compression
-- dbo.bigTransactionHistoryCCSI			- Uses a clustered columnstore index

-- Each table has identical data and a row count of 62.5 million rows

-- You can use any large table for similar testing

-- Turn on Graphical Execution Plan (Ctrl + M)

SET STATISTICS IO ON;

SET NOCOUNT ON;

-- Flush dirty pages to disk
CHECKPOINT;

-- Flush buffer pool (don't do this in Production)
-- This will force SQL Server to do physical reads
DBCC DROPCLEANBUFFERS;

-- Query 1 *******************************
DECLARE @StartTime datetime = GETDATE();

SELECT COUNT(*) AS [Row Count]
FROM dbo.bigTransactionHistory WITH (INDEX(0));

DECLARE @EndTime datetime = GETDATE();
DECLARE @ElapsedTime int = DATEDIFF(ms, @StartTime, @EndTime);
SELECT @ElapsedTime AS [Query 1 Elapsed Time in ms]
PRINT 'Query 1 Done';
PRINT ' ';

-- Query 2 ********************************
SET @StartTime = GETDATE();

SELECT COUNT(*) AS [Row Count]
FROM dbo.bigTransactionHistoryPageCompressed WITH (INDEX(0));

SET @EndTime = GETDATE();
SET @ElapsedTime = DATEDIFF(ms, @StartTime, @EndTime);
SELECT @ElapsedTime AS [Query 2 Elapsed Time in ms]
PRINT 'Query 2 Done';
PRINT ' ';

-- Query 3 ********************************
SET @StartTime = GETDATE();

SELECT COUNT(*) AS [Row Count]
FROM dbo.bigTransactionHistoryCCSI WITH (INDEX(0));

SET @EndTime = GETDATE();
SET @ElapsedTime = DATEDIFF(ms, @StartTime, @EndTime);
SELECT @ElapsedTime AS [Query 3 Elapsed Time in ms]
PRINT 'Query 3 Done';
PRINT ' ';


-- Query 1 Elapsed time 4320ms, 66% of batch cost
-- Table 'bigTransactionHistory'. Scan count 5, logical reads 287953, physical reads 1, read-ahead reads 287462, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.


-- Query 2 Elapsed time 2030ms, 32% of batch cost  
-- Table 'bigTransactionHistoryPageCompressed'. Scan count 5, logical reads 121261, physical reads 1, read-ahead reads 120753, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.


-- Query 3 Elapsed time 173ms, 3% of batch cost
-- Table 'bigTransactionHistoryCCSI'. Scan count 4, logical reads 0, physical reads 0, read-ahead reads 0, lob logical reads 627, lob physical reads 2, lob read-ahead reads 3.
-- Table 'Worktable'. Scan count 0, logical reads 0, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
-- Table 'Workfile'. Scan count 0, logical reads 0, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
