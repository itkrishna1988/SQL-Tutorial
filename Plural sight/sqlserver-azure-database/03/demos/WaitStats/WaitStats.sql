/*
	Restore WWI database
	*you may need to change the backup and restore locations
	https://github.com/Microsoft/sql-server-samples/
*/
USE [master];
GO
RESTORE DATABASE [WideWorldImportersB] 
	FROM  DISK = N'C:\Backups\WWI_Standard.bak' 
		WITH  FILE = 1,  
	MOVE N'WWI_Primary' 
		TO N'C:\Databases\WideWorldImportersLarge\WideWorldImporters.mdf',  
	MOVE N'WWI_UserData' 
		TO N'C:\Databases\WideWorldImportersLarge\WideWorldImporters_UserData.ndf',  
	MOVE N'WWI_Log' 
		TO N'C:\Databases\WideWorldImportersLarge\WideWorldImporters.ldf',  
	NOUNLOAD,  
	REPLACE,  
	STATS = 5;
GO

/*
	Create some stored procedures for testing
*/

USE [WideWorldImportersB];
GO

DROP PROCEDURE IF EXISTS [Sales].[usp_CustomerOrdersByDate];
GO

CREATE PROCEDURE [Sales].[usp_CustomerOrdersByDate]
	@StartDate DATE, @EndDate DATE
AS	

	SELECT [o].[CustomerID], [ol].[StockItemID], SUM([ol].[Quantity])
	FROM Sales.Orders [o]
	JOIN Sales.OrderLines [ol]
		ON [o].[OrderID] = [ol].[OrderID]
	WHERE [o].[OrderDate] BETWEEN @StartDate AND @EndDate
	GROUP BY [o].[CustomerID], [ol].[StockItemID]
	ORDER BY [o].[CustomerID], [ol].[StockItemID]

GO


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


DROP PROCEDURE IF EXISTS [Sales].[usp_FindOrderByDescription];
GO

CREATE PROCEDURE [Sales].[usp_FindOrderByDescription]
	@Description VARCHAR(100)
AS	

	SELECT [ol].[StockItemID], [ol].[Description], [ol].[UnitPrice],
		[o].[CustomerID], [o].[SalespersonPersonID]
	FROM [Sales].[OrderLines] [ol]
	JOIN [Sales].[Orders] [o]
		ON [ol].[OrderID] = [o].[OrderID]
	WHERE [ol].[Description] = @Description 

GO


DROP PROCEDURE IF EXISTS [Sales].[usp_GetFullProductInfo];
GO

CREATE PROCEDURE [Sales].[usp_GetFullProductInfo]
	@StockItemID INT
AS	

	SELECT 
		[o].[CustomerID], 
		[o].[OrderDate], 
		[ol].[StockItemID], 
		[ol].[Quantity],
		[ol].[UnitPrice]
	FROM [Sales].[Orders] [o]
	JOIN [Sales].[OrderLines] [ol] 
		ON [o].[OrderID] = [ol].[OrderID]
	WHERE [ol].[StockItemID] = @StockItemID
	ORDER BY [o].[OrderDate] DESC;

	SELECT
		[o].[CustomerID], 
		SUM([ol].[Quantity]*[ol].[UnitPrice])
	FROM [Sales].[Orders] [o]
	JOIN [Sales].[OrderLines] [ol] 
		ON [o].[OrderID] = [ol].[OrderID]
	WHERE [ol].[StockItemID] = @StockItemID
	GROUP BY [o].[CustomerID]
	ORDER BY [o].[CustomerID] ASC;
GO

DROP PROCEDURE IF EXISTS [Application].[usp_GetPersonInfo];
GO

CREATE PROCEDURE [Application].[usp_GetPersonInfo] (@PersonID INT)
AS

	SELECT 
		[p].[FullName], 
		[p].[EmailAddress], 
		[c].[FormalName]
	FROM [Application].[People] [p]
	LEFT OUTER JOIN [Application].[Countries] [c] 
		ON [p].[PersonID] = [c].[LastEditedBy]
	WHERE [p].[PersonID] = @PersonID;
GO


/*
	Check status of Query Store and wait stats collection
*/
USE [WideWorldImportersB];
GO
SELECT *
FROM [sys].[database_query_store_options];
GO

/*
	Enable Query Store and clear anything that may be in there
*/
ALTER DATABASE [WideWorldImportersB] SET QUERY_STORE = ON;
GO

ALTER DATABASE [WideWorldImportersB] SET QUERY_STORE (
	OPERATION_MODE = READ_WRITE, 
	INTERVAL_LENGTH_MINUTES = 10
	);
GO

ALTER DATABASE [WideWorldImportersB] SET QUERY_STORE CLEAR;
GO


/*
	Check status again
*/
USE [WideWorldImportersB];
GO
SELECT *
FROM [sys].[database_query_store_options];
GO


/*
	Create table for testing
*/
USE [WideWorldImportersB];
GO

CREATE TABLE [Sales].[NewCustomers](
	[CustomerID] [INT] IDENTITY PRIMARY KEY NOT NULL,
	[CustomerName] [NVARCHAR](100) NOT NULL,
	[BillToCustomerID] [INT] NOT NULL,
	[CustomerCategoryID] [INT] NOT NULL,
	[BuyingGroupID] [INT] NULL,
	[PrimaryContactPersonID] [INT] NOT NULL,
	[PostalCityID] [INT] NOT NULL,
	[CreditLimit] [DECIMAL] (18, 2) NULL,
	[AccountOpenedDate] [DATE] NOT NULL,
	[StandardDiscountPercentage] [DECIMAL](18, 3) NOT NULL,
	[IsStatementSent] [BIT] NOT NULL,
	[IsOnCreditHold] [BIT] NOT NULL,
	[PaymentDays] [INT] NOT NULL,
	[PhoneNumber] [NVARCHAR](20) NOT NULL,
	[WebsiteURL] [NVARCHAR](256) NOT NULL,
	[DeliveryAddressLine1] [NVARCHAR](60) NOT NULL,
	[DeliveryAddressLine2] [NVARCHAR](60) NULL,
	[DeliveryPostalCode] [NVARCHAR](10) NOT NULL,
	[PostalAddressLine1] [NVARCHAR](60) NOT NULL,
	[PostalAddressLine2] [NVARCHAR](60) NULL,
	[PostalPostalCode] [NVARCHAR](10) NOT NULL,
	[LastEditedBy] [INT] NOT NULL
) ON [USERDATA];
GO


/*
	Add some data
*/
USE [WideWorldImportersB]
GO

INSERT INTO [Sales].[NewCustomers]
    ([CustomerName]
    ,[BillToCustomerID]
    ,[CustomerCategoryID]
    ,[BuyingGroupID]
    ,[PrimaryContactPersonID]
    ,[PostalCityID]
    ,[CreditLimit]
    ,[AccountOpenedDate]
    ,[StandardDiscountPercentage]
    ,[IsStatementSent]
    ,[IsOnCreditHold]
    ,[PaymentDays]
    ,[PhoneNumber]
    ,[WebsiteURL]
    ,[DeliveryAddressLine1]
    ,[DeliveryAddressLine2]
    ,[DeliveryPostalCode]
    ,[PostalAddressLine1]
    ,[PostalAddressLine2]
    ,[PostalPostalCode]
    ,[LastEditedBy])
SELECT
	[CustomerName]
    ,[BillToCustomerID]
    ,[CustomerCategoryID]
    ,[BuyingGroupID]
    ,[PrimaryContactPersonID]
    ,[PostalCityID]
    ,[CreditLimit]
    ,[AccountOpenedDate]
    ,[StandardDiscountPercentage]
    ,[IsStatementSent]
    ,[IsOnCreditHold]
    ,[PaymentDays]
    ,[PhoneNumber]
    ,[WebsiteURL]
    ,[DeliveryAddressLine1]
    ,[DeliveryAddressLine2]
    ,[DeliveryPostalCode]
    ,[PostalAddressLine1]
    ,[PostalAddressLine2]
    ,[PostalPostalCode]
    ,[LastEditedBy]
FROM [Sales].[Customers];
GO


/* 
	Run in a separate window 
*/
USE [WideWorldImportersB];
GO

BEGIN TRANSACTION;

UPDATE [Sales].[NewCustomers] SET [PaymentDays] = 4;

WAITFOR DELAY '00:00:20';

COMMIT;

GO 10 


/* 
	Run in a separate window 
*/
USE [WideWorldImportersB];
GO

BEGIN TRANSACTION;

UPDATE [Sales].[NewCustomers] SET [PaymentDays] = 2;

WAITFOR DELAY '00:00:20';

COMMIT;

GO 10


/*
	What do we see in the UI?
*/


/*
	Query plan and execution information
*/
SELECT 
	[rsi].[start_time] AS [IntervalStartTime],
	[rsi].[end_time] AS [IntervalEndTime],
	[qsq].[query_id], 
	[qst].[query_sql_text],
	[qsp].[plan_id],
	[qsq].[object_id],
	CASE
		WHEN [qsq].[object_id] = 0 THEN N'Ad-hoc'
		ELSE OBJECT_NAME([qsq].[object_id]) 
	END AS [Object],
	[rs].[count_executions],
	[rs].[avg_duration],
	[rs].[avg_logical_io_reads],
	TRY_CONVERT(XML, [qsp].[query_plan]) AS [QueryPlan]
FROM [sys].[query_store_query] [qsq] 
JOIN [sys].[query_store_query_text] [qst]
	ON [qsq].[query_text_id] = [qst].[query_text_id]
JOIN [sys].[query_store_plan] [qsp] 
	ON [qsq].[query_id] = [qsp].[query_id]
JOIN [sys].[query_store_runtime_stats] [rs] 
	ON [qsp].[plan_id] = [rs].[plan_id]
JOIN [sys].[query_store_runtime_stats_interval] [rsi]
	ON [rs].[runtime_stats_interval_id] = [rsi].[runtime_stats_interval_id]
WHERE [qst].[query_sql_text] LIKE '%UPDATE%'
ORDER BY [rsi].[start_time]
GO

/*
	Adding in waits
	https://docs.microsoft.com/en-us/sql/relational-databases/system-catalog-views/sys-query-store-wait-stats-transact-sql
*/
SELECT 
	[rsi].[start_time] AS [IntervalStartTime],
	[rsi].[end_time] AS [IntervalEndTime],
	[qsq].[query_id], 
	[qst].[query_sql_text],
	[qsp].[plan_id],
	[qsq].[object_id],
	CASE
		WHEN [qsq].[object_id] = 0 THEN N'Ad-hoc'
		ELSE OBJECT_NAME([qsq].[object_id]) 
	END AS [Object],
	[rs].[count_executions],
	[rs].[avg_duration],
	[rs].[avg_logical_io_reads],
	TRY_CONVERT(XML, [qsp].[query_plan]) AS [QueryPlan],
	[ws].[wait_category_desc],
	[ws].[total_query_wait_time_ms]
FROM [sys].[query_store_query] [qsq] 
JOIN [sys].[query_store_query_text] [qst]
	ON [qsq].[query_text_id] = [qst].[query_text_id]
JOIN [sys].[query_store_plan] [qsp] 
	ON [qsq].[query_id] = [qsp].[query_id]
JOIN [sys].[query_store_runtime_stats] [rs] 
	ON [qsp].[plan_id] = [rs].[plan_id]
JOIN [sys].[query_store_runtime_stats_interval] [rsi]
	ON [rs].[runtime_stats_interval_id] = [rsi].[runtime_stats_interval_id]
JOIN [sys].[query_store_wait_stats] ws
	ON [qsp].[plan_id] = [ws].[plan_id]
	AND [rsi].[runtime_stats_interval_id] = [ws].[runtime_stats_interval_id]
WHERE [qst].[query_sql_text] LIKE '%UPDATE%'
ORDER BY [rsi].[start_time] ASC, [ws].[total_query_wait_time_ms] DESC;
GO

/*
	Highest waits in last 10 minutes
*/
SELECT
	TOP 25
	[ws].[wait_category_desc],
	[ws].[avg_query_wait_time_ms],
	[ws].[total_query_wait_time_ms],
	[ws].[plan_id],
	CASE
		WHEN [q].[object_id] = 0 THEN N'Ad-hoc'
		ELSE OBJECT_NAME([q].[object_id]) 
	END AS [Object],
	[qt].[query_sql_text],
	[rsi].[start_time] AS [IntervalStartTime],
	[rsi].[end_time] AS [IntervalEndTime]
FROM [sys].[query_store_query_text] [qt]
JOIN [sys].[query_store_query] [q]
	ON [qt].[query_text_id] = [q].[query_text_id]
JOIN [sys].[query_store_plan] [qp] 
	ON [q].[query_id] = [qp].[query_id]
JOIN [sys].[query_store_runtime_stats] [rs] 
	ON [qp].[plan_id] = [rs].[plan_id]
JOIN [sys].[query_store_runtime_stats_interval] [rsi] 
	ON [rs].[runtime_stats_interval_id] = [rsi].[runtime_stats_interval_id]
JOIN [sys].[query_store_wait_stats] [ws]
	ON [ws].[runtime_stats_interval_id] = [rs].[runtime_stats_interval_id]
		AND [ws].[plan_id] = [qp].[plan_id]
WHERE [rsi].[end_time] > DATEADD(MINUTE, -10, GETUTCDATE()) 
	AND [ws].[execution_type] = 0
ORDER BY [ws].[avg_query_wait_time_ms] DESC;
GO

/*
	Waits aggregated by plan, for query or SP
*/
SELECT 
	[qsq].[query_id], 
	[qsp].[plan_id],
	[qst].[query_sql_text],
	TRY_CONVERT(XML, MAX([qsp].[query_plan])) [QueryPlan],
	SUM([rs].[count_executions] * [rs].avg_duration)/
		SUM([rs].[count_executions]) AS AverageDurationMicroseconds,
	SUM([rs].[count_executions] * [rs].[avg_logical_io_reads])/
		SUM([rs].[count_executions]) AS [AverageLogicalIO],
	[ws].[wait_category_desc],
	AVG([ws].[avg_query_wait_time_ms]) [AvgWaitTimes]
FROM [sys].[query_store_query] [qsq] 
JOIN [sys].[query_store_query_text] [qst]
	ON [qsq].[query_text_id] = [qst].[query_text_id]
JOIN [sys].[query_store_plan] [qsp] 
	ON [qsq].[query_id] = [qsp].[query_id]
JOIN [sys].[query_store_runtime_stats] [rs] 
	ON [qsp].[plan_id] = [rs].[plan_id]
JOIN [sys].[query_store_runtime_stats_interval] [rsi]
	ON [rs].[runtime_stats_interval_id] = [rsi].[runtime_stats_interval_id]
JOIN [sys].[query_store_wait_stats] ws
	ON [qsp].[plan_id] = [ws].[plan_id]
	AND [rsi].[runtime_stats_interval_id] = [ws].[runtime_stats_interval_id]
WHERE [qst].[query_sql_text] LIKE '%UPDATE%'
AND [rsi].[end_time] BETWEEN DATEADD(HOUR, -1, GETUTCDATE()) AND DATEADD(HOUR, 0, GETUTCDATE())
AND [ws].[execution_type] = 0
GROUP BY [qsq].[query_id], [qsp].[plan_id],
	[qst].[query_sql_text],
	[ws].[wait_category_desc]
ORDER BY [qsp].[plan_id];
GO

/*
	Clean up
*/
DROP TABLE [Sales].[NewCustomers];
GO
