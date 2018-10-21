/*
Ch 64 - Indexing Strategies
SQL Server 2008 Bible
Paul Nielsen
*/

USE AdventureWorks2008

SELECT Count(*) FROM Production.WorkOrder

--------------------------------------------------------
-- query path 1 - Fetch All
-- no filter, select every row
DBCC FREEPROCCACHE;DBCC DROPCLEANBUFFERS;

SELECT *
  FROM Production.WorkOrder;

--------------------------------------------------------
-- query path 2 - Clustered Index Seek
-- filter for single row using clustered index key
DBCC FREEPROCCACHE;DBCC DROPCLEANBUFFERS;

SELECT *
  FROM Production.WorkOrder
  WHERE WorkOrderID = 1234;

--------------------------------------------------------
-- query path 3 - Range Seek Query
-- filter for narrow range using clustered index key
DBCC FREEPROCCACHE;DBCC DROPCLEANBUFFERS;

-- narrow
SELECT *
  FROM Production.WorkOrder
  WHERE WorkOrderID between 10000 and 10010; 

DBCC FREEPROCCACHE;DBCC DROPCLEANBUFFERS;

-- wide
SELECT *
  FROM Production.WorkOrder
  WHERE WorkOrderID >= 1 and WorkOrderID <=72591
  
SELECT *
  FROM Production.WorkOrder
  WHERE WorkOrderID between 1 and 72591;

--------------------------------------------------------
-- query path 4 - Filter by Non-Key Column
-- select all columns, filter by non-key column
DBCC FREEPROCCACHE;DBCC DROPCLEANBUFFERS;

SELECT *
  FROM Production.WorkOrder
  WHERE StartDate = '2003-06-25'

--------------------------------------------------------
-- query path 5 - Bookmark Lookup 
-- select all columns, filter by non-clustered key

DBCC FREEPROCCACHE;DBCC DROPCLEANBUFFERS;

-- return all columns
SELECT *                       
  FROM Production.WorkOrder
  WHERE ProductID = 757			-- 9 rows

DBCC FREEPROCCACHE;DBCC DROPCLEANBUFFERS;

-- return single non-index column
SELECT WorkOrderID, StartDate  
  FROM Production.WorkOrder
  WHERE ProductID = 757			-- 9 rows

--------------------------------------------------------
-- query path 6 - Covering Index 
-- select non-clustered NC include columns, filter by non-clustered key
DROP INDEX Production.WorkOrder.IX_WorkOrder_ProductID

CREATE INDEX IX_WorkOrder_ProductID
  ON Production.WorkOrder (ProductID)
  INCLUDE (StartDate)
  
DBCC FREEPROCCACHE;DBCC DROPCLEANBUFFERS;

SELECT WorkOrderID, StartDate
  FROM Production.WorkOrder
  WHERE ProductID = 757 -- 9 rows

DBCC FREEPROCCACHE;DBCC DROPCLEANBUFFERS;

SELECT WorkOrderID, StartDate
  FROM Production.WorkOrder
  WHERE ProductID = 945  -- 1105 rows
  
DBCC FREEPROCCACHE;DBCC DROPCLEANBUFFERS;

-- return clustered index key
SELECT WorkOrderID
  FROM Production.WorkOrder
  WHERE ProductID = 757			-- 11 rows

DBCC FREEPROCCACHE;DBCC DROPCLEANBUFFERS;

SELECT WorkOrderID
  FROM Production.WorkOrder
  WHERE ProductID = 945			-- 1105 rows  

DBCC FREEPROCCACHE;DBCC DROPCLEANBUFFERS;

-- filter by included column
SELECT WorkOrderID, StartDate
  FROM Production.WorkOrder
  WHERE ProductID = 757
    AND StartDate = '2002-01-04'
    
--------------------------------------------------------
-- query path 7 - filter by 2 x NC Indexes
-- select clustered index key, filter by two NC index keys

DROP INDEX Production.WorkOrder.IX_WorkOrder_ProductID

CREATE INDEX IX_WorkOrder_ProductID
  ON Production.WorkOrder (ProductID)

CREATE INDEX IX_WorkOrder_StartDate
  ON Production.WorkOrder (StartDate)

DBCC FREEPROCCACHE;DBCC DROPCLEANBUFFERS;
  
SELECT WorkOrderID, StartDate
  FROM Production.WorkOrder
  WHERE ProductID = 757
    AND StartDate = '2002-01-04'  

--------------------------------------------------------
-- query path 8 - Filter by Ordered Composite Index
-- select key column, filter by composite NC keys

DROP INDEX Production.WorkOrder.IX_WorkOrder_ProductID
DROP INDEX Production.WorkOrder.IX_WorkOrder_StartDate

CREATE INDEX IX_WorkOrder_ProductID
  ON Production.WorkOrder (ProductID, StartDate)

DBCC FREEPROCCACHE;DBCC DROPCLEANBUFFERS;
  
SELECT WorkOrderID, StartDate
  FROM Production.WorkOrder
  WHERE ProductID = 757
    AND StartDate = '2002-01-04'  

--------------------------------------------------------
-- query path 9 - Filter by unordered Composite index 
-- select key column, filter by second composite NC key
DBCC FREEPROCCACHE;DBCC DROPCLEANBUFFERS;

SELECT WorkOrderID, StartDate
  FROM Production.WorkOrder
  WHERE StartDate = '2002-01-04'  

--------------------------------------------------------
-- query path 10 - non-SARG-able Expressions
-- select key columns, filter by function(key)
DBCC FREEPROCCACHE;DBCC DROPCLEANBUFFERS;
 
-- conditions with expressions  non-SARG-able   
SELECT WorkOrderID, StartDate
  FROM Production.WorkOrder
  WHERE ProductID + 2 = 759
 
 SELECT WorkOrderID, StartDate
  FROM Production.WorkOrder
  WHERE ProductID = 759 - 2
 
-- ORs non-SARG-able  
SELECT WorkOrderID, StartDate
  FROM Production.WorkOrder
  WHERE ProductID = 757
    OR  StartDate = '2002-01-04' 
    
-- Negative Conditions non-SARG-able
SELECT WorkOrderID, StartDate
  FROM Production.WorkOrder
  WHERE ProductID NOT IN (400,800, 950)
  
-- Wildcards non-SARG-able
SELECT WorkOrderID, StartDate
  FROM Production.WorkOrder
  WHERE WorkOrderID like '%7'
  
-- Functions non-SARG-able
SELECT WorkOrderID, StartDate
  FROM Production.WorkOrder
  WHERE DateName(dw, StartDate) = 'Monday'


------------------------------------------------------------
-- Analyzing Trace Data
 
alter table trace
  alter column textdata nvarchar(max)  

select substring(querytext, 1, CHARINDEX(' ',querytext, 6)), 
		count(*) as 'count', 
		sum(duration) as 'SumDuration',
		avg(duration) as 'AvgDuration', 
		max(duration) as 'MaxDuration', 
		cast(SUM(duration) as numeric(20,2)) 
		  / (select sum(Duration) from trace) as 'Percentage',
		sum(rowcounts) as 'SumRows'
	from trace
	group by substring(querytext, 1, charindex(' ',querytext, 6))
	order by sum(Duration) desc
	


