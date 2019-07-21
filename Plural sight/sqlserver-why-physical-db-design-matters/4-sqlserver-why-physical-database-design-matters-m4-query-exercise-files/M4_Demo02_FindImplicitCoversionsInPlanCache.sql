-- Demo script for Finding Implicit Coversions in the cache.

-- NOTE: This script requires the completion of
-- Demo 01: Implicit Conversions demo

USE [Credit];
go

-- For more information on ALL of the type conversions,
-- check out http://bit.ly/XFS6On 

-- Analyzing the plan cache can be incredibly useful
-- to find inconsistencies within your code
-- This code comes from Jon's blog post: 
--   Finding Implicit Column Conversions in the Plan Cache
-- http://bit.ly/17MdijL


SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED; 

DECLARE @dbname SYSNAME 
SET @dbname = QUOTENAME (DB_NAME ()); 

WITH XMLNAMESPACES 
   (DEFAULT 'http://schemas.microsoft.com/sqlserver/2004/07/showplan') 
SELECT 
   [stmt].[value](N'(@StatementText)[1]', N'VARCHAR(MAX)'), 
   [t].[value](N'(ScalarOperator/Identifier/ColumnReference/@Schema)[1]', N'VARCHAR(128)'), 
   [t].[value](N'(ScalarOperator/Identifier/ColumnReference/@Table)[1]', N'VARCHAR(128)'), 
   [t].[value](N'(ScalarOperator/Identifier/ColumnReference/@Column)[1]', N'VARCHAR(128)'), 
   [ic].[DATA_TYPE] AS [ConvertFrom], 
   [ic].[CHARACTER_MAXIMUM_LENGTH] AS [ConvertFromLength], 
   [t].[value](N'(@DataType)[1]', N'VARCHAR(128)') AS [ConvertTo], 
   [t].[value](N'(@Length)[1]', N'INT') AS [ConvertToLength], 
   [query_plan] 
FROM [sys].[dm_exec_cached_plans] AS [cp]
	CROSS APPLY [sys].[dm_exec_query_plan]([plan_handle]) AS [qp]
	CROSS APPLY [query_plan].[nodes](
		'/ShowPlanXML/BatchSequence/Batch/Statements/StmtSimple')
		AS [batch]([stmt]) 
	CROSS APPLY [stmt].[nodes](
		'.//Convert[@Implicit="1"]') AS [n]([t]) 
JOIN [INFORMATION_SCHEMA].[COLUMNS] AS [ic]
   ON QUOTENAME ([ic].[TABLE_SCHEMA]) 
		= [t].[value](N'(ScalarOperator/Identifier/ColumnReference/@Schema)[1]', N'VARCHAR(128)') 
   AND QUOTENAME ([ic].[TABLE_NAME]) 
		= [t].[value](N'(ScalarOperator/Identifier/ColumnReference/@Table)[1]', 'VARCHAR(128)') 
   AND [ic].[COLUMN_NAME] 
		= [t].[value]('(ScalarOperator/Identifier/ColumnReference/@Column)[1]', 'VARCHAR(128)') 
WHERE [t].[exist]('ScalarOperator/Identifier/ColumnReference[@Database=sql:variable("@dbname")][@Schema!="[sys]"]') 
		= 1 
OPTION (MAXDOP 1);
GO