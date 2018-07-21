-- demo of RCSI
	select *from HumanResources.Employee where EmployeeID=2 -- this will get the old value
	
	set transaction isolation level  read committed
	go
	select *from HumanResources.Employee where EmployeeID=2 -- this also gets the old value
	
	
	
	-- demo of SI - Transactional 
	
	select *from HumanResources.Employee where EmployeeID=2 -- this blocks
	
	set transaction isolation level  read committed
	go
	select *from HumanResources.Employee where EmployeeID=2 -- this also blocks
	
	go
		set transaction isolation level  snapshot
			select *from HumanResources.Employee where EmployeeID=2 -- this also blocks

	
	
	
	-- Both - RCSI window
	begin tran
	
				select *from HumanResources.Employee where EmployeeID=2 -- this also blocks
-- assume you have many other DML here

			select *from HumanResources.Employee where EmployeeID=2 -- this also blocks
