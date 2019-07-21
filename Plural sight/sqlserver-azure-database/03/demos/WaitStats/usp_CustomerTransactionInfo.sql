/*

USE [msdb];
GO

DROP TABLE IF EXISTS [msdb].[dbo].[CustomerIDs];
GO

SELECT 
	DISTINCT [CustomerID], 
	DENSE_RANK() OVER (ORDER BY [CustomerID]) AS RowNum
INTO [msdb].[dbo].[CustomerIDs]
FROM [WideWorldImportersB].[Sales].[CustomerTransactions];
GO

*/

USE [WideWorldImportersB];

SET NOCOUNT ON;
SET ARITHABORT OFF;

DECLARE @CustomerID INT;
DECLARE @RowNum INT = 1;
DECLARE @TotalRows INT;

SELECT @TotalRows = COUNT(*) FROM [msdb].[dbo].[CustomerIDs]


WHILE 1=1
BEGIN

	SELECT @CustomerID = (
		SELECT [CustomerID] 
		FROM [msdb].[dbo].[CustomerIDs]
		WHERE RowNum = @RowNum);

	EXEC [Sales].[usp_CustomerTransactionInfo] @CustomerID;

	IF @RowNum <= @TotalRows
	BEGIN
		SET @RowNum = @RowNum + 1
	END
	ELSE
	BEGIN
		SET @RowNum = 1
	END

END
GO