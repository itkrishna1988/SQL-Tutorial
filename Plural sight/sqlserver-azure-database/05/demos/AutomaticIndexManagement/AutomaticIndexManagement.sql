USE [WideWorldImportersPS];
GO

/*
	Check current settings (since this is a restored DB)
*/
SELECT *
FROM [sys].[database_query_store_options];
GO


/*
	Enable QS if needed
*/
ALTER DATABASE [WideWorldImportersPS] SET QUERY_STORE = ON;
GO


/*
	Alter settings if needed/desired
*/
ALTER DATABASE [WideWorldImportersPS] SET QUERY_STORE (
	OPERATION_MODE = READ_WRITE,
	INTERVAL_LENGTH_MINUTES = 10,
	MAX_STORAGE_SIZE_MB = 256 
	);
GO


/*
	Check options again
*/
SELECT *
FROM [sys].[database_query_store_options];
GO


/*
	Clear out any old data (since it's a demo DB)
*/
ALTER DATABASE [WideWorldImportersPS] SET QUERY_STORE CLEAR;
GO


/*
	Check Automatic Tuning options
*/
SELECT *
FROM [sys].[database_automatic_tuning_mode];
GO

SELECT *
FROM [sys].[database_automatic_tuning_options];
GO


/*
	Enable Automatic Index Management Options
	https://docs.microsoft.com/en-us/azure/sql-database/sql-database-automatic-tuning-enable
	https://azure.microsoft.com/en-us/blog/automatic-tuning-will-be-a-new-default/
*/
ALTER DATABASE [WideWorldImportersPS] 
	SET AUTOMATIC_TUNING (
		FORCE_LAST_GOOD_PLAN = OFF, 
		CREATE_INDEX = ON, 
		DROP_INDEX = ON
		);
GO


/*
	Check distribution of CustomerIDs
*/
USE [WideWorldImportersPS];
GO

SELECT [CustomerID], COUNT([CustomerID])
FROM [WideWorldImportersPS].[Sales].[CustomerTransactions]
GROUP BY [CustomerID]
ORDER BY COUNT([CustomerID]) DESC;
GO


/*
	Generate CustomerID list for SP to use
*/	
DROP TABLE IF EXISTS [WideWorldImportersPS].[dbo].[CustomerIDs];
GO

SELECT 
	DISTINCT [CustomerID], 
	DENSE_RANK() OVER (ORDER BY [CustomerID]) AS RowNum
INTO [WideWorldImportersPS].[dbo].[CustomerIDs]
FROM [WideWorldImportersPS].[Sales].[CustomerTransactions];
GO


/*
	Create SP
*/
DROP PROCEDURE IF EXISTS [Sales].[usp_CustomerTransactionInfo];
GO

CREATE PROCEDURE [Sales].[usp_CustomerTransactionInfo]
	@CustomerID INT
AS	

	SELECT [CustomerID], SUM([AmountExcludingTax])
	FROM [Sales].[CustomerTransactions]
	WHERE [CustomerID] = @CustomerID
	GROUP BY [CustomerID];
GO


/*
	Drop index that supports index seek against CustomerID
*/
DROP INDEX [FK_Sales_CustomerTransactions_CustomerID] 
	ON [Sales].[CustomerTransactions];
GO


/*
	Execute SP with Actual Plan enabled to see
	missing index recommendation
*/	
EXEC [Sales].[usp_CustomerTransactionInfo] 834;
GO


/*
	Create SP for Orders
*/
DROP PROCEDURE IF EXISTS [Sales].[usp_CustomerOrderInfo];
GO

CREATE PROCEDURE [Sales].[usp_CustomerOrderInfo]
	@CustomerID INT
AS	

	SELECT TOP 1 [CustomerID], [OrderDate], [ExpectedDeliveryDate]
	FROM [Sales].[Orders]
	WHERE [CustomerID] = @CustomerID;
GO


/*
	Create duplicate indexes
*/
CREATE NONCLUSTERED INDEX NCI_CustomerID_1 
	ON Sales.Orders ([CustomerID])
	INCLUDE ([OrderDate], [ExpectedDeliveryDate]);
GO

CREATE NONCLUSTERED INDEX NCI_CustomerID_2 
	ON Sales.Orders ([CustomerID])
	INCLUDE ([OrderDate], [ExpectedDeliveryDate]);
GO


/*
	Execute SP with Actual Plan enabled to 
	confirm one of the indexes is used
*/	
EXEC [Sales].[usp_CustomerOrderInfo] 834;
GO


/*
	Index usage data
	https://www.sqlskills.com/blogs/glenn/category/dmv-queries/
*/
SELECT 
	OBJECT_NAME(s.[object_id]) AS [Table Name], 
	i.name AS [Index Name], 
	i.index_id, 
	user_updates AS [Total Writes], 
	user_seeks + user_scans + user_lookups AS [Total Reads],
	user_updates - (user_seeks + user_scans + user_lookups) AS [Difference]
FROM sys.dm_db_index_usage_stats AS s WITH (NOLOCK)
INNER JOIN sys.indexes AS i WITH (NOLOCK)
	ON s.[object_id] = i.[object_id]
	AND i.index_id = s.index_id
WHERE OBJECTPROPERTY(s.[object_id],'IsUserTable') = 1
	AND s.database_id = DB_ID()
	AND user_updates > (user_seeks + user_scans + user_lookups)
	AND i.index_id > 1
ORDER BY 
	[Difference] DESC, 
	[Total Writes] DESC, 
	[Total Reads] ASC OPTION (RECOMPILE);
GO


/*
	Missing Indexes for current database by Index Advantage
*/
SELECT 
	DISTINCT CONVERT(decimal(18,2), user_seeks * avg_total_user_cost * 
		(avg_user_impact * 0.01)) AS [index_advantage], 
	migs.last_user_seek, 
	mid.[statement] AS [Database.Schema.Table],
	mid.equality_columns, 
	mid.inequality_columns, 
	mid.included_columns,
	migs.user_seeks, 
	migs.avg_total_user_cost, 
	migs.avg_user_impact,
	OBJECT_NAME(mid.[object_id]) AS [Table Name], 
	p.rows AS [Table Rows]
FROM sys.dm_db_missing_index_group_stats AS migs WITH (NOLOCK)
INNER JOIN sys.dm_db_missing_index_groups AS mig WITH (NOLOCK)
	ON migs.group_handle = mig.index_group_handle
INNER JOIN sys.dm_db_missing_index_details AS mid WITH (NOLOCK)
	ON mig.index_handle = mid.index_handle
INNER JOIN sys.partitions AS p WITH (NOLOCK)
	ON p.[object_id] = mid.[object_id]
WHERE mid.database_id = DB_ID() 
ORDER BY index_advantage DESC OPTION (RECOMPILE);
GO


/*
	Run external script...wait 12 hours...
*/


/*
	Check Performance Recommendations in the Azure portal
	for the database
*/


/*
	Query the database directly to see what was done
*/
SELECT *
FROM [sys].[dm_db_tuning_recommendations];
GO

SELECT
	[type], 
	[CID].[IndexName], 
	[CID].[Schema], 
	[CID].[Table], 
	[CID].[KeyColumns], 
	[CID].[IncludedColumns],
	[valid_since], 
	[execute_action_start_time], 
	[execute_action_duration], 
	[execute_action_initiated_by],
	[revert_action_start_time], 
	[revert_action_duration], 
	[revert_action_initiated_by],
	[IS].[IndexSize],
	[IS].[SizeUnit],
	JSON_VALUE(state, '$.currentValue') [CurrentValue],
	JSON_VALUE(details, '$.implementationDetails.script') [Script]
FROM [sys].[dm_db_tuning_recommendations]
CROSS APPLY OPENJSON (details, '$.createIndexDetails')
    WITH ( [IndexName] NVARCHAR(1000) '$.indexName',
        [Schema] NVARCHAR(1000) '$.schema',
		[Table] NVARCHAR(1000) '$.table',
		[KeyColumns] NVARCHAR(1000) '$.indexColumns',
        [IncludedColumns] NVARCHAR(1000) '$.includedColumns'
    ) AS [CID]
CROSS APPLY OPENJSON (details, '$.estimatedImpact')
	WITH ( [IndexSize] DECIMAL(10,2) '$.absoluteValue',
		[SizeUnit] NVARCHAR(15) '$.unit'
	) AS [IS];
GO


/*
	DMV query to find unused indexes
*/
SELECT 
	OBJECT_NAME(s.[object_id]) AS [Table Name], 
	i.name AS [Index Name], 
	i.index_id, 
	user_updates AS [Total Writes], 
	user_seeks + user_scans + user_lookups AS [Total Reads],
	user_updates - (user_seeks + user_scans + user_lookups) AS [Difference]
FROM sys.dm_db_index_usage_stats AS s WITH (NOLOCK)
INNER JOIN sys.indexes AS i WITH (NOLOCK)
	ON s.[object_id] = i.[object_id]
	AND i.index_id = s.index_id
WHERE OBJECTPROPERTY(s.[object_id],'IsUserTable') = 1
	AND s.database_id = DB_ID()
	AND user_updates > (user_seeks + user_scans + user_lookups)
	AND i.index_id > 1
ORDER BY 
	[Difference] DESC, 
	[Total Writes] DESC, 
	[Total Reads] ASC OPTION (RECOMPILE);
GO


/*
	DMV query to look at missing indexes
*/
SELECT 
	DISTINCT CONVERT(decimal(18,2), user_seeks * avg_total_user_cost * 
		(avg_user_impact * 0.01)) AS [index_advantage], 
	migs.last_user_seek, 
	mid.[statement] AS [Database.Schema.Table],
	mid.equality_columns, 
	mid.inequality_columns, 
	mid.included_columns,
	migs.user_seeks, 
	migs.avg_total_user_cost, 
	migs.avg_user_impact,
	OBJECT_NAME(mid.[object_id]) AS [Table Name], 
	p.rows AS [Table Rows]
FROM sys.dm_db_missing_index_group_stats AS migs WITH (NOLOCK)
INNER JOIN sys.dm_db_missing_index_groups AS mig WITH (NOLOCK)
	ON migs.group_handle = mig.index_group_handle
INNER JOIN sys.dm_db_missing_index_details AS mid WITH (NOLOCK)
	ON mig.index_handle = mid.index_handle
INNER JOIN sys.partitions AS p WITH (NOLOCK)
	ON p.[object_id] = mid.[object_id]
WHERE mid.database_id = DB_ID() 
ORDER BY index_advantage DESC OPTION (RECOMPILE);
GO


/*
	What about the duplicate index?
*/
sp_helpindex 'Sales.Orders';
GO


/*
	Check perf data in the UI
*/