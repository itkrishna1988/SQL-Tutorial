-- Workload for Piecemeal Restore demo.

-- Switch to text mode output

-- Infinite simple workload
WHILE (1 = 1)
BEGIN
	SELECT
		COUNT (*)
	FROM
		[SalesDB].[dbo].[Sales]
	WHERE
		[SalesID] > 6000000;
END;
GO
