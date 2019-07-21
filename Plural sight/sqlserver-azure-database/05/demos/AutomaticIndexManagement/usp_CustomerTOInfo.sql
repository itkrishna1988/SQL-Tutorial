USE [WideWorldImportersPS];
GO

SET NOCOUNT ON;
GO

ALTER DATABASE SCOPED CONFIGURATION CLEAR PROCEDURE_CACHE 
GO

EXEC [Sales].[usp_CustomerTransactionInfo] 1088;
GO

DECLARE @CustomerID INT;
DECLARE @RowNum INT = 1;
DECLARE @TotalRows INT;

SELECT @TotalRows = COUNT(*) FROM [WideWorldImportersPS].[dbo].[CustomerIDs]

WHILE 1=1
BEGIN

	SELECT @CustomerID = (
		SELECT [CustomerID] 
		FROM [WideWorldImportersPS].[dbo].[CustomerIDs]
		WHERE RowNum = @RowNum);

	EXEC [Sales].[usp_CustomerTransactionInfo] @CustomerID;

	EXEC [Sales].[usp_CustomerOrderInfo] @CustomerID;

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