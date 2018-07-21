
with cte (RowNumber,SalesOrderID, OrderDate,CustomerID)
as
(
Select ROW_NUMBER() over (Order by OrderDate, SalesOrderID) as RowNumber,
SalesOrderID, OrderDate,CustomerID
From Sales.SalesOrderHeader)
select *from cte 
Where RowNumber between 1 and 10


-- Create an Employee table.
CREATE TABLE dbo.MyEmployees
(
	EmployeeID smallint NOT NULL,
	FirstName nvarchar(30)  NOT NULL,
	LastName  nvarchar(40) NOT NULL,
	Title nvarchar(50) NOT NULL,
	DeptID smallint NOT NULL,
	ManagerID int NULL,
 CONSTRAINT PK_EmployeeID PRIMARY KEY CLUSTERED (EmployeeID ASC) 
);
-- Populate the table with values.
INSERT INTO dbo.MyEmployees VALUES 
 (1, N'Ken', N'Sánchez', N'Chief Executive Officer',16,NULL)
,(273, N'Brian', N'Welcker', N'Vice President of Sales',3,1)
,(274, N'Stephen', N'Jiang', N'North American Sales Manager',3,273)
,(275, N'Michael', N'Blythe', N'Sales Representative',3,274)
,(276, N'Linda', N'Mitchell', N'Sales Representative',3,274)
,(285, N'Syed', N'Abbas', N'Pacific Sales Manager',3,273)
,(286, N'Lynn', N'Tsoflias', N'Sales Representative',3,285)
,(16,  N'David',N'Bradley', N'Marketing Manager', 4, 273)
,(23,  N'Mary', N'Gibson', N'Marketing Specialist', 4, 16);

-- Down
 
WITH DirectReports (ManagerID, EmployeeID, Title,FirstName,  Level)
AS
(
-- Anchor member definition
    SELECT e.ManagerID, e.EmployeeID, e.Title ,FirstName,
        0 AS Level
    FROM dbo.MyEmployees AS e
     WHERE ManagerID IS NULL
    UNION ALL
-- Recursive member definition
    SELECT c.ManagerID, c.EmployeeID, c.Title,c.FirstName,  
        Level + 1
    FROM 
      DirectReports AS p
     INNER JOIN dbo.MyEmployees AS c
        ON c.ManagerID = p.EmployeeID
)
-- Statement that executes the CTE
SELECT ManagerID, EmployeeID, Title,    Level,Level, REPLICATE(' | ',Level)+FirstName
FROM DirectReports
Where Level<3
 



--up the tree
 
WITH DirectReports (ManagerID, EmployeeID, Title, FirstName, Level)
AS
(
-- Anchor member definition
    SELECT e.ManagerID, e.EmployeeID, e.Title ,e.FirstName,
        0 AS Level
    FROM dbo.MyEmployees AS e
     WHERE ManagerID=16
    UNION ALL
-- Recursive member definition
    SELECT p.ManagerID, p.EmployeeID, p.Title,  p.FirstName,
        Level + 1
    FROM 
      DirectReports AS c
     INNER JOIN dbo.MyEmployees AS p
        ON c.ManagerID = p.EmployeeID
)
-- Statement that executes the CTE
SELECT ManagerID, EmployeeID, Title,    Level, REPLICATE('|',Level)+FirstName
FROM DirectReports
 
 
 