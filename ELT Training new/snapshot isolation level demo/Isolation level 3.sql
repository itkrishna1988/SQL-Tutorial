begin tran
		set transaction isolation level  snapshot
	
				select *from HumanResources.Employee where EmployeeID=2 -- this also blocks
-- assume you have many other DML here

			select *from HumanResources.Employee where EmployeeID=2 -- this also blocks