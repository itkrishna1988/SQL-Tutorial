-- Group by vs partitioning
select ProductID, sum(UnitPrice) From Sales.SalesOrderDetail  where ProductID=707
group by ProductID

Select ProductID, SUM(UnitPrice) over (partition by ProductID), *
 From Sales.SalesOrderDetail where ProductID=707
 
 -- Empty partition means the whole table is taken as a single partition
 Select ProductID, SUM(UnitPrice) over ( ), *
 From Sales.SalesOrderDetail where ProductID=707
 
 --Multiple partition in same query
 
  Select ProductID, SUM(UnitPrice) over ( ) as totalSale,
   SUM(UnitPrice) over (partition by ProductID) as Productwisesale 
 From Sales.SalesOrderDetail where ProductID=707
 
 -- ROW_NUMBER for the whole table/set
  
  Select SalesOrderDetailID, ProductID, 
  ROW_NUMBER() over ( order by SalesOrderDetailID ) as RowNumber,
   SUM(UnitPrice) over (partition by ProductID) as Productwisesale 
 From Sales.SalesOrderDetail  
 order by SalesOrderDetailID
 
  -- ROW_NUMBER for the partition by product id  /set
  
   Select SalesOrderDetailID, ProductID, 
   COUNT (*) over (partition by ProductID) as totalcnt,
  ROW_NUMBER() over ( partition by ProductID order by ProductID,SalesOrderDetailID ) as RowNumber,
  
   SUM(UnitPrice) over (partition by ProductID) as Productwisesale 
 From Sales.SalesOrderDetail  
 order by ProductID
 
 
 
 Alter proc spGetsalesorderdetails
 @NumberofRows int,  
 @PageNumber int  
 as
 declare @from int,@to int
 Set @from =@NumberofRows*(@PageNumber-1)+1
 Set @to = @NumberofRows*@PageNumber
 
 ;with cte (SalesOrderDetailID, ProductID,RowNumber,Productwisesale ) as
 (
   Select SalesOrderDetailID, ProductID, 
  ROW_NUMBER() over (order by ProductID,SalesOrderDetailID ) as RowNumber,
   SUM(UnitPrice) over (partition by ProductID) as Productwisesale 
 From Sales.SalesOrderDetail  
 )
 select *from cte
 where RowNumber between @from and @to
 
 print @from 
 print @to 
 exec spGetsalesorderdetails 30,4
 
 -- Deleting duplicate rows using CTE +ROW_NUMBER
 
 