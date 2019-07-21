/*
	DBCC USEROPTIONS
*/
DBCC USEROPTIONS;
GO

SELECT [session_id], [text_size], [language], [date_format], [date_first], 
	[lock_timeout], [quoted_identifier], [arithabort], [ansi_null_dflt_on], 
	[ansi_warnings], [ansi_padding], [ansi_nulls], [concat_null_yields_null], 
	[transaction_isolation_level]
FROM [sys].[dm_exec_sessions];
GO


/*
	DBCC OPENTRAN
*/
DBCC OPENTRAN;


/*
	Leave a transaction open...
*/
USE [AdventureWorks2014];
GO

BEGIN TRANSACTION;
UPDATE [Sales].[SalesOrderDetail] 
SET [ModifiedDate] = SYSDATETIME();
--ROLLBACK;

DBCC OPENTRAN;
GO


/*
	For 2012 and higher
*/
SELECT *
FROM [sys].[dm_exec_sessions]
WHERE [open_transaction_count] > 0;
GO


/*
	For 2008R2 and below
*/
SELECT [s].* 
FROM sys.dm_exec_sessions [s] 
WHERE EXISTS ( 
	SELECT * 
	FROM sys.dm_tran_session_transactions [t]
	WHERE [t].[session_id] = [s].[session_id] 
	) 
AND NOT EXISTS ( 
	SELECT * 
	FROM sys.dm_exec_requests [r] 
	WHERE [r].[session_id] = [s].[session_id] 
	);
GO


/*
	DBCC INPUTBUFFER
	Edit session_id if needed
*/
DBCC INPUTBUFFER (53);
GO

SELECT [c].[session_id], [c].[connect_time], [c].[num_reads], [c].[num_writes], DB_NAME([t].[dbid]) [Database], [t].[text]
FROM [sys].[dm_exec_connections] [c]
CROSS APPLY [sys].[dm_exec_sql_text]([c].[most_recent_sql_handle]) [t];
GO


/*
	DBCC OUTPUTBUFFER
	edit session_id if needed
*/
DBCC OUTPUTBUFFER (53);
GO


/*
	DBCC PROCCACHE
*/
DBCC PROCCACHE;

SELECT *
FROM [sys].[dm_exec_cached_plans];

SELECT 
	[objtype] AS [CacheType],
	COUNT_BIG(*) AS [Total Plans],
	SUM(CAST([size_in_bytes] AS DECIMAL(18,2)))/1024/1024 AS [Total MBs],
	AVG([usecounts]) AS [Avg Use Count],
	SUM(CAST((CASE WHEN [usecounts] = 1 THEN [size_in_bytes] ELSE 0 END) 
	AS DECIMAL(18,2)))/1024/1024 AS [Total MBs – USE Count 1],
	SUM(CASE WHEN [usecounts] = 1 THEN 1 ELSE 0 END) AS [Total Plans – USE Count 1]
FROM [sys].[dm_exec_cached_plans]
GROUP BY [objtype]
ORDER BY [Total MBs – USE Count 1] DESC;


/*
	DBCC SHOWCONTIG 
*/
USE [AdventureWorks2014];
GO
DBCC SHOWCONTIG ('Sales.SalesOrderDetail', 1);
GO
DBCC SHOWCONTIG ('Sales.SalesOrderDetail') WITH ALL_INDEXES;
GO

SELECT *
FROM [sys].[dm_db_index_physical_stats](DB_ID(),OBJECT_ID(N'Sales.SalesOrderDetail'),1,NULL,'Detailed');
GO

SELECT *
FROM [sys].[dm_db_index_physical_stats](DB_ID(),OBJECT_ID(N'Sales.SalesOrderDetail'),1,NULL,'Limited');
GO

