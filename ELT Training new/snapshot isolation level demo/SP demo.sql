-- Auto parameterisation
-- Straight forward simple/safe  plans are auto parameterised
-- It replace the value with parameter so that any value can be accomodated
-- Automatically parameterise search arguments and place the plan in cache.
use AdventureWorks
go

-- auto parameterised
select EmployeeID from HumanResources.Employee where EmployeeID=2

-- non auto parameterised
-- any value for which the result may  vary will not be auto parameterised
select EmployeeID from HumanResources.Employee where Title like '%aa%'

dbcc freeproccache
checkpoint;-- write dirty pages to disk
dbcc dropcleanbuffers -- clean all data cache

select st.text,Execution_count, cp.*,qp.* from sys.dm_exec_query_stats cp
cross apply sys.dm_exec_sql_text (plan_handle) st
cross apply sys.dm_exec_query_plan(plan_handle) qp
where text like '%temp%'
order  by execution_count

 
select *from master.dbo.syscacheobjects where cacheobjtype='Compiled Plan'


select EmployeeID from HumanResources.Employee where EmployeeID=3 -- different value
select EmployeeID from HumanResources.Employee where EmployeeID='3' -- different type with same value


